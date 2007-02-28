Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXB1Vkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXB1Vkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXB1Vkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:40:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:34938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbXB1Vkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nI0adQyWa4jg3H2LmFHU3rtrDuBikAhIIKOwtzw8CJi6jAef96ptM6AuZubjiBco0EycjxUyThHc1/t2/31Tz4XoTDkgJtH2311TdYpkYnExhqkdqXYutsF0PnNfBKKIrF0npxHO3dz96RlXH90lycjHHllEs9IR+IinGzGIc6U=
Date: Thu, 1 Mar 2007 00:40:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: [PATCH] x86_64: shut up vm86(2)
Message-ID: <20070228214046.GA5539@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From originally rate-limited printk, to just printk, to current version.
Everybody had enough time to learn about vm86(2) absense.
Also remove possibility of dmesg spamming.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86_64/ia32/ia32entry.S |    4 ++--
 arch/x86_64/ia32/sys_ia32.c  |   12 ------------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -512,7 +512,7 @@ #endif
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
+	.quad quiet_ni_syscall	/* vm86old */ 
 	.quad compat_sys_wait4
 	.quad sys_swapoff		/* 115 */
 	.quad compat_sys_sysinfo
@@ -565,7 +565,7 @@ #endif
 	.quad sys_mremap
 	.quad sys_setresuid16
 	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
+	.quad quiet_ni_syscall	/* vm86 */ 
 	.quad quiet_ni_syscall	/* query_module */
 	.quad sys_poll
 	.quad compat_sys_nfsservctl
--- a/arch/x86_64/ia32/sys_ia32.c
+++ b/arch/x86_64/ia32/sys_ia32.c
@@ -842,18 +842,6 @@ long sys32_fadvise64_64(int fd, __u32 of
 			       advice); 
 } 
 
-long sys32_vm86_warning(void)
-{ 
-	struct task_struct *me = current;
-	static char lastcomm[sizeof(me->comm)];
-	if (strncmp(lastcomm, me->comm, sizeof(lastcomm))) {
-		compat_printk(KERN_INFO "%s: vm86 mode not supported on 64 bit kernel\n",
-		       me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
-	} 
-	return -ENOSYS;
-} 
-
 long sys32_lookup_dcookie(u32 addr_low, u32 addr_high,
 			  char __user * buf, size_t len)
 {

