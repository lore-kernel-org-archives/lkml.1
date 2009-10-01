Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZJAT74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZJAT74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbZJAT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:59:55 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48747 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZJAT7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:59:55 -0400
Message-ID: <4AC50A3A.4010200@interlog.com>
Date: Thu, 01 Oct 2009 15:59:54 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: iceberg <strakh@ispras.ru>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] sg.c: sleeping function called from invalid context
References: <200910011628.06870.strakh@ispras.ru>
In-Reply-To: <200910011628.06870.strakh@ispras.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iceberg wrote:
> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> Driver sg.c might sleep in atomic context, because it calls 
> scsi_device_put under lock_kernel.
> 
> /drivers/scsi/sg.c:306:
> 	static int
> 	sg_open(struct inode *inode, struct file *filp)
> 	{
> 	...
> 	lock_kernel();
> 	...
> 	error_out:
> 	        if (retval)
> 	                scsi_device_put(sdp->device);
> 	...
> 
> Path to might_sleep macro from scsi_device_put:
> 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> 3. kobject_put calls kref_put at ./lib/kobject.c
> 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> refcount becomes zero, which might_sleep because it calls user event. Details:
> 	5.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> 	5.2 kobject_uevent calls kobject_uevent_env at ./lib/kobject_uevent.c:282
> 	5.3 kobject_uevent_env calls call_usermodehelper_exec at 
> include/linux/kmod.h:83
> 	5.4 call_usermodehelper_exec calls wait_for_completion at ./kernel/kmod.c:481
> 	5.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> 	5.6 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> 
> Found by: Linux Driver Verification

This patch to sg_open() does one (and only one) unlock_kernel()
prior to scsi_device_put(). I presume sg_put_dev() may also
sleep so the unlock_kernel() is moved before it as well.

Hopefully Tomo will comment.

Doug Gilbert


--- linux/drivers/scsi/sg.c2631	2009-09-10 06:22:34.000000000 -0400
+++ linux/drivers/scsi/sg.c	2009-10-01 15:54:30.000000000 -0400
@@ -227,8 +227,10 @@
  	Sg_fd *sfp;
  	int res;
  	int retval;
+	int locked = 0;

  	lock_kernel();
+	locked = 1;
  	nonseekable_open(inode, filp);
  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
  	sdp = sg_get_dev(dev);
@@ -302,12 +304,16 @@
  	}
  	retval = 0;
  error_out:
-	if (retval)
+	if (retval) {
+		unlock_kernel();
+		locked = 0;
  		scsi_device_put(sdp->device);
+	}
  sg_put:
+	if (locked)
+		unlock_kernel();
  	if (sdp)
  		sg_put_dev(sdp);
-	unlock_kernel();
  	return retval;
  }

