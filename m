Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbXKOGSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbXKOGSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761703AbXKOGQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51006 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761384AbXKOGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:18 -0500
Date: Wed, 14 Nov 2007 22:14:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 05/19] POWERPC: Fix handling of stfiwx math emulation
Message-ID: <20071115061438.GF7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-handling-of-stfiwx-math-emulation.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kumar Gala <galak@kernel.crashing.org>

patch ba02946a903015840ef672ccc9dc8620a7e83de6 in mainline

Its legal for the stfiwx instruction to have RA = 0 as part of its
effective address calculation.  This is illegal for all other XE
form instructions.

Add code to compute the proper effective address for stfiwx if
RA = 0 rather than treating it as illegal.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/math-emu/math.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/powerpc/math-emu/math.c
+++ b/arch/powerpc/math-emu/math.c
@@ -407,11 +407,16 @@ do_mathemu(struct pt_regs *regs)
 
 	case XE:
 		idx = (insn >> 16) & 0x1f;
-		if (!idx)
-			goto illegal;
-
 		op0 = (void *)&current->thread.fpr[(insn >> 21) & 0x1f];
-		op1 = (void *)(regs->gpr[idx] + regs->gpr[(insn >> 11) & 0x1f]);
+		if (!idx) {
+			if (((insn >> 1) & 0x3ff) == STFIWX)
+				op1 = (void *)(regs->gpr[(insn >> 11) & 0x1f]);
+			else
+				goto illegal;
+		} else {
+			op1 = (void *)(regs->gpr[idx] + regs->gpr[(insn >> 11) & 0x1f]);
+		}
+
 		break;
 
 	case XEU:

-- 
