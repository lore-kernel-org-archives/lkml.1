Return-Path: <linux-kernel-owner+w=401wt.eu-S1946344AbXD3QTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946344AbXD3QTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423548AbXD3QQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:16:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39559 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946181AbXD3QKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:10:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 06/12] i386: Minimum cpu detection cleanups.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 10:09:11 -0600
In-Reply-To: <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 10:03:27 -0600")
Message-ID: <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch modifies verify_cpu to check for a 486 even when
REQUIRED_MASK1 == 0 

This patch modifies REQUIRED_MASK1 to require  PAE when CONFIG_X86_PAE
is set not when HIGHMEM64G is set, not that there is a functional
difference but it seems an obvious fix.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/verify_cpu.S        |    7 ++-----
 include/asm-i386/required-features.h |    2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kernel/verify_cpu.S b/arch/i386/kernel/verify_cpu.S
index ba9e03e..e51a869 100644
--- a/arch/i386/kernel/verify_cpu.S
+++ b/arch/i386/kernel/verify_cpu.S
@@ -4,10 +4,6 @@
 #include <asm/cpufeature.h>
 
 verify_cpu:
-#if REQUIRED_MASK1 == 0
-	xorl %eax,%eax
-	ret
-#endif
 	pushfl				# Save caller passed flags
 	pushl	$0			# Kill any dangerous flags
 	popfl
@@ -21,7 +17,7 @@ verify_cpu:
 	testl	$(1<<18),%eax
 	jz	bad
 #endif
-
+#if REQUIRED_MASK1 != 0
 	pushfl				# standard way to check for cpuid
 	popl	%eax
 	movl	%eax,%ebx
@@ -57,6 +53,7 @@ verify_cpu:
 	andl	$REQUIRED_MASK1,%edx
 	xorl	$REQUIRED_MASK1,%edx
 	jnz	bad
+#endif /* REQUIRED_MASK1 */
 
 	popfl
 	xor	%eax,%eax
diff --git a/include/asm-i386/required-features.h b/include/asm-i386/required-features.h
index 062407e..9db866c 100644
--- a/include/asm-i386/required-features.h
+++ b/include/asm-i386/required-features.h
@@ -11,7 +11,7 @@
    The real information is in arch/i386/Kconfig.cpu, this just converts
    the CONFIGs into a bitmask */
 
-#ifdef CONFIG_HIGHMEM64G
+#ifdef CONFIG_X86_PAE
 #define NEED_PAE	(1<<X86_FEATURE_PAE)
 #else
 #define NEED_PAE	0
-- 
1.5.1.1.181.g2de0

