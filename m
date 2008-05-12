Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYELLNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYELLNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYELLNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:13:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYELLNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:13:34 -0400
Subject: sparc: Fix mremap VA span checking.
From: Jan Lieskovsky <jlieskov@redhat.com>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Content-Type: multipart/mixed; boundary="=-gj8IV+9h0opo72YHMYDo"
Organization: Red Hat Inc.
Date: Mon, 12 May 2008 13:15:12 +0200
Message-Id: <1210590913.10883.9.camel@dhcp-lab-164.englab.brq.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gj8IV+9h0opo72YHMYDo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello guys,

  sorry for bothering you if wrong, but based on DaveM's 
patch: <cite>

sparc: Fix mmap VA span checking.
David S. Miller [Wed, 7 May 2008 09:24:28 +0000 (02:24 -0700)]
[ Upstream commit: 5816339310b2d9623cf413d33e538b45e815da5d ]
We should not conditionalize VA range checks on MAP_FIXED.
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

</cite>

 I have investigated the code for MREMAP_FIXED in
sparc_mremap in arch/sparc/kernel/sys_sparc.c, for sys64_mremap
in arch/sparc64/kernel/sys_sparc.c and 
for sys32_mremap in arch/sparc64/kernel/sys_sparc32.c
and there are similar conditional range checks ->
attaching the patches against 2.6.25.3.

Kind regards
Jan iankko Lieskovsky


--=-gj8IV+9h0opo72YHMYDo
Content-Disposition: attachment; filename=sparc_sys_sparc.diff
Content-Type: text/x-patch; name=sparc_sys_sparc.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.25.3.old/arch/sparc/kernel/sys_sparc.c	2008-05-12 11:43:17.000000000 +0200
+++ linux-2.6.25.3/arch/sparc/kernel/sys_sparc.c	2008-05-12 12:20:32.000000000 +0200
@@ -308,14 +308,13 @@
 	    new_len > TASK_SIZE - PAGE_SIZE)
 		goto out;
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (ARCH_SUN4C_SUN4 &&
-		    new_addr < 0xe0000000 &&
-		    new_addr + new_len > 0x20000000)
-			goto out_sem;
-		if (new_addr + new_len > TASK_SIZE - PAGE_SIZE)
-			goto out_sem;
-	} else if ((ARCH_SUN4C_SUN4 && addr < 0xe0000000 &&
+	if (ARCH_SUN4C_SUN4 &&
+	    new_addr < 0xe0000000 &&
+	    new_addr + new_len > 0x20000000)
+	    goto out_sem;
+	if (new_addr + new_len > TASK_SIZE - PAGE_SIZE)
+	    goto out_sem;
+	else if ((ARCH_SUN4C_SUN4 && addr < 0xe0000000 &&
 		    addr + new_len > 0x20000000) ||
 		   addr + new_len > TASK_SIZE - PAGE_SIZE) {
 		unsigned long map_flags = 0;

--=-gj8IV+9h0opo72YHMYDo
Content-Disposition: attachment; filename=sparc64_sys_sparc.diff
Content-Type: text/x-patch; name=sparc64_sys_sparc.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.25.3.old/arch/sparc64/kernel/sys_sparc.c	2008-05-12 11:43:17.000000000 +0200
+++ linux-2.6.25.3/arch/sparc64/kernel/sys_sparc.c	2008-05-12 12:18:58.000000000 +0200
@@ -620,10 +620,9 @@
 		goto out;
 
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (invalid_64bit_range(new_addr, new_len))
-			goto out_sem;
-	} else if (invalid_64bit_range(addr, new_len)) {
+        if (invalid_64bit_range(new_addr, new_len))
+		goto out_sem;
+        else if (invalid_64bit_range(addr, new_len)) {
 		unsigned long map_flags = 0;
 		struct file *file = NULL;
 

--=-gj8IV+9h0opo72YHMYDo
Content-Disposition: attachment; filename=sparc64_sys_sparc32.diff
Content-Type: text/x-patch; name=sparc64_sys_sparc32.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.25.3.old/arch/sparc64/kernel/sys_sparc32.c	2008-05-12 11:43:17.000000000 +0200
+++ linux-2.6.25.3/arch/sparc64/kernel/sys_sparc32.c	2008-05-12 12:19:43.000000000 +0200
@@ -915,10 +915,9 @@
 	if (addr > STACK_TOP32 - old_len)
 		goto out;
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (new_addr > STACK_TOP32 - new_len)
-			goto out_sem;
-	} else if (addr > STACK_TOP32 - new_len) {
+	if (new_addr > STACK_TOP32 - new_len)
+		goto out_sem;
+	else if (addr > STACK_TOP32 - new_len) {
 		unsigned long map_flags = 0;
 		struct file *file = NULL;
 

--=-gj8IV+9h0opo72YHMYDo--

