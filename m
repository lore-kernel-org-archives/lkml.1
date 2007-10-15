Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXJOFk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXJOFk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXJOFkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:40:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:45084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXJOFkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dGhfFyqYHWXLH15kAZgFVpXRTrMAStT+WSWvZhxOs9CfyGSpHYJwbI1QDDk43G3vJHgkjS+1U69+i9bKk67SitilLbKfrcx2GXGBQDn6TXMXYNv24z9WnvBf8H4VzZ97mlyo+lZ72nNUkx6Bv/cqDeakl/CZo1gQyEWoPfFr7sE=
Date: Mon, 15 Oct 2007 13:39:32 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][resend] param_sysfs_builtin memchr argument fix
Message-ID: <20071015053932.GA3277@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If memchr argument is longer than strlen(kp->name), there will be some weird result.

It will casuse duplicate filenames in sysfs for the "nousb". kernel
warning messages are as bellow:

sysfs: duplicate filename 'usbcore' can not be created
WARNING: at fs/sysfs/dir.c:416 sysfs_add_one()
 [<c01c4750>] sysfs_add_one+0xa0/0xe0
 [<c01c4ab8>] create_dir+0x48/0xb0
 [<c01c4b69>] sysfs_create_dir+0x29/0x50
 [<c024e0fb>] create_dir+0x1b/0x50
 [<c024e3b6>] kobject_add+0x46/0x150
 [<c024e2da>] kobject_init+0x3a/0x80
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
kobject_add failed for usbcore with -EEXIST, don't try to register things with the same name in the same directory.
 [<c024e466>] kobject_add+0xf6/0x150
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
Module 'usbcore' failed to be added to sysfs, error number -17
The system will be unstable now.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
kernel/params.c |    8 +++++++-
1 file changed, 7 insertions(+), 1 deletion(-)

diff -upr linux/kernel/params.c linux.new/kernel/params.c
--- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
+++ linux.new/kernel/params.c	2007-10-09 09:16:55.000000000 +0800
@@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;
