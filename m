Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbYBGA0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbYBGA0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbYBFX7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:33078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590AbYBFX7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:47 -0500
Date: Wed, 6 Feb 2008 15:54:13 -0800
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
       Tony Luck <tony.luck@intel.com>
Subject: [patch 62/73] ia64: Fix unaligned handler for floating point
	instructions with base update
Message-ID: <20080206235413.GK13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ia64-fix-unaligned-handler-for-floating-point-instructions-with-base-update.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Luck, Tony <tony.luck@intel.com>

commit 1a499150e4ec1299232e24389f648d059ce5617a in mainline.

[IA64] Fix unaligned handler for floating point instructions with base update

The compiler team did the hard work for this distilling a problem in
large fortran application which showed up when applied to a 290MB input
data set down to this instruction:

	ldfd f34=[r17],-8

Which they noticed incremented r17 by 0x10 rather than decrementing it
by 8 when the value in r17 caused an unaligned data fault.  I tracked
it down to some bad instruction decoding in unaligned.c. The code
assumes that the 'x' bit can determine whether the instruction is
an "ldf" or "ldfp" ... which it is for opcode=6 (see table 4-29 on
page 3:302 of the SDM).  But for opcode=7 the 'x' bit is irrelevent,
all variants are "ldf" instructions (see table 4-36 on page 3:306).

Note also that interpreting the instruction as "ldfp" means that the
"paired" floating point register (f35 in the example here) will also
be corrupted.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/unaligned.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/unaligned.c
+++ b/arch/ia64/kernel/unaligned.c
@@ -1487,16 +1487,19 @@ ia64_handle_unaligned (unsigned long ifa
 	      case LDFA_OP:
 	      case LDFCCLR_OP:
 	      case LDFCNC_OP:
-	      case LDF_IMM_OP:
-	      case LDFA_IMM_OP:
-	      case LDFCCLR_IMM_OP:
-	      case LDFCNC_IMM_OP:
 		if (u.insn.x)
 			ret = emulate_load_floatpair(ifa, u.insn, regs);
 		else
 			ret = emulate_load_float(ifa, u.insn, regs);
 		break;
 
+	      case LDF_IMM_OP:
+	      case LDFA_IMM_OP:
+	      case LDFCCLR_IMM_OP:
+	      case LDFCNC_IMM_OP:
+		ret = emulate_load_float(ifa, u.insn, regs);
+		break;
+
 	      case STF_OP:
 	      case STF_IMM_OP:
 		ret = emulate_store_float(ifa, u.insn, regs);

-- 
