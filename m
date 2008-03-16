Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYCPNUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYCPNUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 09:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYCPNU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 09:20:29 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:19995 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYCPNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 09:20:28 -0400
Date: Sun, 16 Mar 2008 14:16:56 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: K8, GEODE_LX, CRUSOE, EFFICEON and CORE2 support the cmovxx instructions.
Message-ID: <20080316131656.GA29207@mailshack.com>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com> <20080315191946.GA21817@mailshack.com> <47DC2F08.9080004@zytor.com> <1205615192.29139.1242596503@webmail.messagingengine.com> <20080315211125.GB13012@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315211125.GB13012@1wt.eu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 16 Mar 2008 14:19:51 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.31; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: K8, GEODE_LX, CRUSOE, EFFICEON and CORE2 support CMOV.

Instead of summing up the cpu's that have support for the
cmov instruction, sum up the cpu's that don't.

GEODE_LX has no entry in arch/x86/Makefile_32.cpu, so it
did not get any -march or -mtune arguments at all. I quite
arbitrarily added -march=i686 -mtune=pentium-mmx. This way
gcc is allowed to use cmov instructions.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---

Willy Tarreau said:
> > > Crusoe has CMOV as well.
> 
> So does GEODE_LX BTW

> in my experience (on user-space code), optimizing for "i586" gives
> good results. However, the cache is small, so everything which can
> reduce code size (especially loop/jump/function alignment) is worth
> checking.

Thanks for letting me know.

I chose i686 with pentium-mmx scheduling. This enables cmov, while
the scheduling is still pentium-like. If i586 is really better,
GEODE_LX should be listed as not using cmov at all (because the
compiler does not generate them).

Loop/jump/function alignment is automatically turned off if you
compile the kernel with CONFIG_CC_OPTIMIZE_FOR_SIZE=y so I think
it should not be set explicitly.

Qemu does not run GEODE_LX-kernels (no 3dNow).

Greetings,
	Alexander

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 31e92fb..38af3e1 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -399,7 +399,7 @@ config X86_TSC
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	depends on !(MCYRIXIII || MGEODEGX1 || MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MK6 || M586MMX || M586TSC || M586 || M486 || M386 || X86_ELAN)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index e372b58..b5e2438 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -38,8 +38,9 @@ cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
 
-# Geode GX1 support
+# Geode GX1 and GX/LX support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
+cflags-$(CONFIG_MGEODE_LX)	+= -march=i686 $(call tune,pentium-mmx)
 
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries

