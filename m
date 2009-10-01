Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZJAGlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZJAGlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZJAGla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:41:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:43431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbZJAGl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:41:28 -0400
Date: Thu, 1 Oct 2009 06:40:17 GMT
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Optimize cmpxchg64() at build-time some more
Message-ID: <tip-982d007a6eec4a0abb404d2355eeec2c041c61ea@git.kernel.org>
Git-Commit-ID: 982d007a6eec4a0abb404d2355eeec2c041c61ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 06:40:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  982d007a6eec4a0abb404d2355eeec2c041c61ea
Gitweb:     http://git.kernel.org/tip/982d007a6eec4a0abb404d2355eeec2c041c61ea
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Wed, 30 Sep 2009 17:57:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 08:01:08 +0200

x86: Optimize cmpxchg64() at build-time some more

Try to avoid the 'alternates()' code when we can statically
determine that cmpxchg8b is fine. We already have that
CONFIG_x86_CMPXCHG64 (enabled by PAE support), and we could easily
also enable it for some of the CPU cases.

Note, this patch only adds CMPXCHG8B for the obvious Intel CPU's,
not for others. (There was something really messy about cmpxchg8b
and clone CPU's, so if you enable it on other CPUs later, do it
carefully.)

If we avoid that asm-alternative thing when we can assume the
instruction exists, we'll generate less support crud, and we'll
avoid the whole issue with that extra 'nop' for padding instruction
sizes etc.

LKML-Reference: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig.cpu |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 527519b..f2824fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
@@ -412,6 +412,7 @@ config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
 	default "6" if X86_32 && X86_P6_NOP
+	default "5" if X86_32 && X86_CMPXCHG64
 	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 
