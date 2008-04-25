Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYDYLOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYDYLOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYDYLOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:14:45 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:18310 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYDYLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:14:44 -0400
Date: Fri, 25 Apr 2008 13:12:53 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, bitops: select the generic bitmap search functions
Message-ID: <20080425111253.GA12086@mailshack.com>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 25 Apr 2008 13:14:15 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.10; VDF: 7.0.3.212; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce GENERIC_FIND_FIRST_BIT and GENERIC_FIND_NEXT_BIT in
lib/Kconfig, defaulting to off. An arch that wants to use the
generic implementation now only has to use a select statement
to include them.

I added an always-y option (X86_CPU) to arch/x86/Kconfig.cpu
and used that to select the generic search functions. This
way ARCH=um SUBARCH=i386 automatically picks up the change
too, and arch/um/Kconfig.i386 can therefore be simplified a
bit. ARCH=um SUBARCH=x86_64 does things differently, but
still compiles fine. It seems that a "def_bool y" always
wins over a "def_bool n"?

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

 arch/um/Kconfig.i386 |    8 --------
 arch/x86/Kconfig     |    6 ------
 arch/x86/Kconfig.cpu |    5 +++++
 lib/Kconfig          |    6 ++++++
 4 files changed, 11 insertions(+), 14 deletions(-)

Hello Linus,

I think this is close to what you had in mind?

The patch applies on top of:

git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-generic-bitops.git for-linus

Compile tested um/i386, um/x86_64. Boot-tested using
qemu for i386 and x86_64.

Greetings,
	Alexander

diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 49990ea..e09edfa 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -39,14 +39,6 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
 	bool
 	default y
 
-config GENERIC_FIND_FIRST_BIT
-	bool
-	default y
-
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 004aad8..4d350b5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -77,12 +77,6 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG
 
-config GENERIC_FIND_FIRST_BIT
-	def_bool y
-
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index b9368f5..b94b04e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -278,6 +278,11 @@ config GENERIC_CPU
 
 endchoice
 
+config X86_CPU
+	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
+
 config X86_GENERIC
 	bool "Generic x86 support"
 	depends on X86_32
diff --git a/lib/Kconfig b/lib/Kconfig
index 2d53dc0..8cc8e87 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -7,6 +7,12 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config GENERIC_FIND_FIRST_BIT
+	def_bool n
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool n
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
