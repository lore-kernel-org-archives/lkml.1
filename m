Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZJAUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZJAUZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZJAUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:25:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZJAUZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:25:32 -0400
Subject: Re: [BUG] sg.c: sleeping function called from invalid context
From: James Bottomley <James.Bottomley@suse.de>
To: dgilbert@interlog.com
Cc: iceberg <strakh@ispras.ru>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4AC50A3A.4010200@interlog.com>
References: <200910011628.06870.strakh@ispras.ru>
	 <4AC50A3A.4010200@interlog.com>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 20:25:27 +0000
Message-Id: <1254428727.3885.64.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 15:59 -0400, Douglas Gilbert wrote:
> iceberg wrote:
> > 	KERNEL_VERSION: 2.6.31
> > 	DESCRIBE:
> > Driver sg.c might sleep in atomic context, because it calls 
> > scsi_device_put under lock_kernel.
> > 
> > /drivers/scsi/sg.c:306:
> > 	static int
> > 	sg_open(struct inode *inode, struct file *filp)
> > 	{
> > 	...
> > 	lock_kernel();
> > 	...
> > 	error_out:
> > 	        if (retval)
> > 	                scsi_device_put(sdp->device);
> > 	...
> > 
> > Path to might_sleep macro from scsi_device_put:
> > 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> > 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> > 3. kobject_put calls kref_put at ./lib/kobject.c
> > 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> > refcount becomes zero, which might_sleep because it calls user event. Details:
> > 	5.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> > 	5.2 kobject_uevent calls kobject_uevent_env at ./lib/kobject_uevent.c:282
> > 	5.3 kobject_uevent_env calls call_usermodehelper_exec at 
> > include/linux/kmod.h:83
> > 	5.4 call_usermodehelper_exec calls wait_for_completion at ./kernel/kmod.c:481
> > 	5.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> > 	5.6 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> > 
> > Found by: Linux Driver Verification
> 
> This patch to sg_open() does one (and only one) unlock_kernel()
> prior to scsi_device_put(). I presume sg_put_dev() may also
> sleep so the unlock_kernel() is moved before it as well.
> 
> Hopefully Tomo will comment.

Really, this isn't a bug, so no fix is required.

The analysis is wrong on two levels.  Firstly scsi_device_put() is
designed to be called from interrupt/locked context and secondly
lock_kernel isn't actually a lock taking interrupt context anyway.  The
BLK is a strange beast; it's recursive and it's actually transparently
dropped and reacquired over schedule, so you can sleep by design with
the BKL held.

James


