Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZCBApn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZCBApn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZCBApf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:45:35 -0500
Received: from ozlabs.org ([203.10.76.45]:45287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZCBApe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:45:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Command line parameter not passed to module in linux-next
Date: Mon, 2 Mar 2009 11:15:23 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090227170105.GA22304@schmichrtp.de.ibm.com>
In-Reply-To: <20090227170105.GA22304@schmichrtp.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021115.23878.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009 03:31:05 Christof Schmitt wrote:
> The linux-next kernel does not pass charp parameters from the kernel
> command line to modules:
> 
> # cat /proc/cmdline 
> dasd=4d70-4d73 root=/dev/dasdc1 zfcp.device=0.0.181d,0x500507630310c562,0x401040C300000000 zfcp.dbfsize=4096  BOOT_IMAGE=0 
> 
> # cat /sys/module/zfcp/parameters/device 
> <NULL>

Thanks:

param: fix charp parameters set via sysfs: FIX

We can't kmalloc at early cmdline parsing.

Reported-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -223,10 +223,16 @@ int param_set_charp(const char *val, str
 	if (kp->perm & KPARAM_KMALLOCED)
 		kfree(*(char **)kp->arg);
 
-	kp->perm |= KPARAM_KMALLOCED;
-	*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
-	if (!kp->arg)
-		return -ENOMEM;
+	/* This is a hack.  We can't need to strdup in early boot, and we
+	 * don't need to; this mangled commandline is preserved. */
+	if (slab_is_available()) {
+		kp->perm |= KPARAM_KMALLOCED;
+		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
+		if (!kp->arg)
+			return -ENOMEM;
+	} else
+		*(const char **)kp->arg = val;
+
 	return 0;
 }
 
