Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXC3VUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXC3VUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXC3VLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:11:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51464 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXC3VK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:56 -0400
Date: Fri, 30 Mar 2007 14:04:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Mikael Pettersson <mikpe@it.uu.se>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/37] SPARC: Fix sparc builds with gcc-4.2.x
Message-ID: <20070330210459.GT29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-fix-sparc-builds-with-gcc-4.2.x.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikael Pettersson <mikpe@it.uu.se>

[SPARC]: sparc64 gcc-4.2.0 20070317 -Werror failure

Compiling 2.6.21-rc5 with gcc-4.2.0 20070317 (prerelease)
for sparc64 fails as follows:

  gcc -Wp,-MD,arch/sparc64/kernel/.time.o.d  -nostdinc -isystem /home/mikpe/pkgs/linux-sparc64/gcc-4.2.0/lib/gcc/sparc64-unknown-linux-gnu/4.2.0/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare -Wa,--undeclared-regs -fomit-frame-pointer  -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign -Werror   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(time)"  -D"KBUILD_MODNAME=KBUILD_STR(time)" -c -o arch/sparc64/kernel/time.o arch/sparc64/kernel/time.c
cc1: warnings being treated as errors
arch/sparc64/kernel/time.c: In function 'kick_start_clock':
arch/sparc64/kernel/time.c:559: warning: overflow in implicit constant conversion
make[1]: *** [arch/sparc64/kernel/time.o] Error 1
make: *** [arch/sparc64/kernel] Error 2

gcc gets unhappy when the MSTK_SET macro's u8 __val variable
is updated with &= ~0xff (MSTK_YEAR_MASK). Making the constant
unsigned fixes the problem.

[ I fixed up the sparc32 side as well -DaveM ]

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-sparc/mostek.h   |    2 +-
 include/asm-sparc64/mostek.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-sparc/mostek.h
+++ b/include/asm-sparc/mostek.h
@@ -87,7 +87,7 @@ extern void __iomem *mstk48t02_regs;
 #define	MSTK_DOW_MASK	0x07
 #define	MSTK_DOM_MASK	0x3f
 #define	MSTK_MONTH_MASK	0x1f
-#define	MSTK_YEAR_MASK	0xff
+#define	MSTK_YEAR_MASK	0xffU
 
 /* Binary coded decimal conversion macros. */
 #define MSTK_REGVAL_TO_DECIMAL(x)  (((x) & 0x0F) + 0x0A * ((x) >> 0x04))
--- a/include/asm-sparc64/mostek.h
+++ b/include/asm-sparc64/mostek.h
@@ -89,7 +89,7 @@ extern void __iomem *mstk48t02_regs;
 #define	MSTK_DOW_MASK	0x07
 #define	MSTK_DOM_MASK	0x3f
 #define	MSTK_MONTH_MASK	0x1f
-#define	MSTK_YEAR_MASK	0xff
+#define	MSTK_YEAR_MASK	0xffU
 
 /* Binary coded decimal conversion macros. */
 #define MSTK_REGVAL_TO_DECIMAL(x)  (((x) & 0x0F) + 0x0A * ((x) >> 0x04))

-- 
