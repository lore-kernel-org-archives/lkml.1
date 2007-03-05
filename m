Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXCEWkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXCEWkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932461AbXCEWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:40:15 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:7667 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbXCEWkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:40:12 -0500
Date: Mon, 5 Mar 2007 23:40:12 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] nss: disable kexec.
Message-ID: <20070305224012.GD22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] nss: disable kexec.

nss and kexec don't work together since kexec wants to write to the
read-only text section of the shared kernel image.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig                |    2 ++
 arch/s390/kernel/machine_kexec.c |    5 +++++
 2 files changed, 7 insertions(+)

diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2007-03-05 22:51:50.000000000 +0100
@@ -376,6 +376,8 @@ config SHARED_KERNEL
 	  Select this option, if you want to share the text segment of the
 	  Linux kernel between different VM guests. This reduces memory
 	  usage with lots of guests but greatly increases kernel size.
+	  Also if a kernel was IPL'ed from a shared segment the kexec system
+	  call will not work.
 	  You should only select this option if you know what you are
 	  doing and want to exploit this feature.
 
diff -urpN linux-2.6/arch/s390/kernel/machine_kexec.c linux-2.6-patched/arch/s390/kernel/machine_kexec.c
--- linux-2.6/arch/s390/kernel/machine_kexec.c	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/machine_kexec.c	2007-03-05 22:51:50.000000000 +0100
@@ -19,6 +19,7 @@
 #include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/reset.h>
+#include <asm/ipl.h>
 
 typedef void (*relocate_kernel_t)(kimage_entry_t *, unsigned long);
 
@@ -29,6 +30,10 @@ int machine_kexec_prepare(struct kimage 
 {
 	void *reboot_code_buffer;
 
+	/* Can't replace kernel image since it is read-only. */
+	if (ipl_flags & IPL_NSS_VALID)
+		return -ENOSYS;
+
 	/* We don't support anything but the default image type for now. */
 	if (image->type != KEXEC_TYPE_DEFAULT)
 		return -EINVAL;
