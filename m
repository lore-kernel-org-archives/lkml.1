Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbYLKTWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbYLKTWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYLKTSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:18 -0500
Received: from kroah.org ([198.145.64.141]:55870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756708AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joseph Myers <joseph@codesourcery.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/83] sparc64: Fix VIS emulation bugs
Message-ID: <20081211191353.GK5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-sparc64-Fix-VIS-emulation-bugs.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joseph Myers <joseph@codesourcery.com>

[ Upstream commit 726c12f57d7e3ff43693d88e13b1ff02464c75d3 ]

This patch fixes some bugs in VIS emulation that cause the GCC test
failure

FAIL: gcc.target/sparc/pdist-3.c execution test

for both 32-bit and 64-bit testing on hardware lacking these
instructions.  The emulation code for the pdist instruction uses
RS1(insn) for both source registers rs1 and rs2, which is obviously
wrong and leads to the instruction doing nothing (the observed
problem), and further inspection of the code shows that RS1 uses a
shift of 24 and RD a shift of 25, which clearly cannot both be right;
examining SPARC documentation indicates the correct shift for RS1 is
14.

This patch fixes the bug if single-stepping over the affected
instruction in the debugger, but not if the testcase is run
standalone.  For that, Wind River has another patch I hope they will
send as a followup to this patch submission.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/visemul.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc64/kernel/visemul.c
+++ b/arch/sparc64/kernel/visemul.c
@@ -131,7 +131,7 @@
 #define VIS_OPF_SHIFT	5
 #define VIS_OPF_MASK	(0x1ff << VIS_OPF_SHIFT)
 
-#define RS1(INSN)	(((INSN) >> 24) & 0x1f)
+#define RS1(INSN)	(((INSN) >> 14) & 0x1f)
 #define RS2(INSN)	(((INSN) >>  0) & 0x1f)
 #define RD(INSN)	(((INSN) >> 25) & 0x1f)
 
@@ -445,7 +445,7 @@ static void pdist(struct pt_regs *regs, 
 	unsigned long i;
 
 	rs1 = fpd_regval(f, RS1(insn));
-	rs2 = fpd_regval(f, RS1(insn));
+	rs2 = fpd_regval(f, RS2(insn));
 	rd = fpd_regaddr(f, RD(insn));
 
 	rd_val = *rd;

