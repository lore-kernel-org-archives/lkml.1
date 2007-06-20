Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbXFTKZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbXFTKZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbXFTKXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:36157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [2/10] x86_64: Fix readahead/sync_file_range/fadvise64 compat calls
Message-Id: <20070620102330.A249114AD5@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Correctly convert the u64 arguments from 32bit to 64bit.

Pointed out by Heiko Carstens.

I guess this proves Linus' theory that nobody uses the more exotic Linux 
specific syscalls.  It wasn't discovered by a user.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/ia32entry.S |    6 +++---
 arch/x86_64/ia32/sys_ia32.c  |   19 +++++++++++++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -620,7 +620,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall		/* tux */
 	.quad quiet_ni_syscall    	/* security */
 	.quad sys_gettid	
-	.quad sys_readahead	/* 225 */
+	.quad sys32_readahead	/* 225 */
 	.quad sys_setxattr
 	.quad sys_lsetxattr
 	.quad sys_fsetxattr
@@ -645,7 +645,7 @@ ia32_sys_call_table:
 	.quad compat_sys_io_getevents
 	.quad compat_sys_io_submit
 	.quad sys_io_cancel
-	.quad sys_fadvise64		/* 250 */
+	.quad sys32_fadvise64		/* 250 */
 	.quad quiet_ni_syscall 	/* free_huge_pages */
 	.quad sys_exit_group
 	.quad sys32_lookup_dcookie
@@ -709,7 +709,7 @@ ia32_sys_call_table:
 	.quad compat_sys_set_robust_list
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
-	.quad sys_sync_file_range
+	.quad sys32_sync_file_range
 	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
Index: linux/arch/x86_64/ia32/sys_ia32.c
===================================================================
--- linux.orig/arch/x86_64/ia32/sys_ia32.c
+++ linux/arch/x86_64/ia32/sys_ia32.c
@@ -860,3 +860,22 @@ long sys32_lookup_dcookie(u32 addr_low, 
 	return sys_lookup_dcookie(((u64)addr_high << 32) | addr_low, buf, len);
 }
 
+asmlinkage ssize_t sys32_readahead(int fd, unsigned off_lo, unsigned off_hi, size_t count)
+{
+	return sys_readahead(fd, ((u64)off_hi << 32) | off_lo, count);
+}
+
+asmlinkage long sys32_sync_file_range(int fd, unsigned off_low, unsigned off_hi,
+			   unsigned n_low, unsigned n_hi,  int flags)
+{
+	return sys_sync_file_range(fd,
+				   ((u64)off_hi << 32) | off_low,
+				   ((u64)n_hi << 32) | n_low, flags);
+}
+
+asmlinkage long sys32_fadvise64(int fd, unsigned offset_lo, unsigned offset_hi, size_t len,
+		     int advice)
+{
+	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
+				len, advice);
+}
