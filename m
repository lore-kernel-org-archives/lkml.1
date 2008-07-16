Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYGPMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYGPMDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYGPMDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:03:04 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:57004
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYGPMDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:03:03 -0400
Date: Wed, 16 Jul 2008 13:02:24 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-stable@linux-mips.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: MIPS toolchain
Message-ID: <20080716120224.GA6061@linux-mips.org>
References: <487DA40C.6010405@movial.fi> <20080716104533.GA7198@linux-mips.org> <487DD559.3020802@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487DD559.3020802@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crosscompiling on a Fedora 9 machine running gcc 4.3.0 as its host compiler
and gcc 3.4.6 for the mips-linux target results in the following build
error:

$ make malta_defconfig
$ make
cc1: error: unrecognized command line option "-fno-stack-protector"
scripts/kconfig/conf -s arch/mips/Kconfig
cc1: error: unrecognized command line option "-fno-stack-protector"

The arch Makefile is included too late so the host compiler is feature
tested, not the crosscompiler as intended and thus the Makefile applies
adds -fno-stack-protector to crosscompiler's flags which fails for gcc
3.4.6.  The bug was introduced by e06b8b98da071f7dd78fb7822991694288047df0
in 2.6.25; 35bb5b1e0e84cfa1a8906f7e6a77f391ff315791 did add more flags
testing before the arch Makefile inclusion.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/Makefile b/Makefile
index bfde079..312fcaa 100644
--- a/Makefile
+++ b/Makefile
@@ -509,6 +509,8 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
 ifneq (CONFIG_FRAME_WARN,0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
@@ -517,8 +519,6 @@ endif
 # Arch Makefiles may override this setting
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
