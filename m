Return-Path: <linux-kernel-owner+w=401wt.eu-S1423475AbXD3PvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423475AbXD3PvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423496AbXD3PvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:51:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51423 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423483AbXD3Pul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 02/12] i386 head.S: Remove unnecessary use of %ebx as the boot cpu flag
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 09:49:31 -0600
In-Reply-To: <m18xc96eyq.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Mon, 30 Apr 2007 09:48:13 -0600")
Message-ID: <m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently in head.S there are two ways we test to see if we
are the boot cpu.  By looking at %ebx and by looking at the
static variable ready.  When changing things around I have
found that it gets tricky to preserve %ebx.  So this
patch just switches head.S over to the more reliable
test of always using ready.

Hopefully later we can kill these tests entirely.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/head.S |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 9b10af6..aa9e28e 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -157,7 +157,6 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
-	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
  * Non-boot CPU entry point; entered from trampoline.S
@@ -228,10 +227,6 @@ ENTRY(startup_32_smp)
 	wrmsr
 
 6:
-	/* This is a secondary processor (AP) */
-	xorl %ebx,%ebx
-	incl %ebx
-
 #endif /* CONFIG_SMP */
 3:
 
@@ -257,7 +252,7 @@ ENTRY(startup_32_smp)
 	popfl
 
 #ifdef CONFIG_SMP
-	andl %ebx,%ebx
+	cmpb $0, ready
 	jz  1f				/* Initial CPU cleans BSS */
 	jmp checkCPUtype
 1:
-- 
1.5.1.1.181.g2de0

