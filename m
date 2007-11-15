Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXKOGRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXKOGRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761305AbXKOGQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbXKOGQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:12 -0500
Date: Wed, 14 Nov 2007 22:14:35 -0800
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
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 04/19] MIPS: R1: Fix hazard barriers to make kernels work
	on R2 also.
Message-ID: <20071115061435.GE7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mips-r1-fix-hazard-barriers-to-make-kernels-work-on-r2-also.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ralf Baechle <ralf@linux-mips.org>

patch 572afc248c33c902760f6f24a72c180f0e4f1719 in mainline.

Tested with Malta; inflates malta_defconfig by 3932 bytes.  Ideally there
should be additional configuration to allow getting rid of this overhead
but that would be too much complexity at this stage of the release cycle.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-mips/hazards.h |   54 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

--- a/include/asm-mips/hazards.h
+++ b/include/asm-mips/hazards.h
@@ -10,11 +10,12 @@
 #ifndef _ASM_HAZARDS_H
 #define _ASM_HAZARDS_H
 
-
 #ifdef __ASSEMBLY__
 #define ASMMACRO(name, code...) .macro name; code; .endm
 #else
 
+#include <asm/cpu-features.h>
+
 #define ASMMACRO(name, code...)						\
 __asm__(".macro " #name "; " #code "; .endm");				\
 									\
@@ -86,6 +87,57 @@ do {									\
 	: "=r" (tmp));							\
 } while (0)
 
+#elif defined(CONFIG_CPU_MIPSR1)
+
+/*
+ * These are slightly complicated by the fact that we guarantee R1 kernels to
+ * run fine on R2 processors.
+ */
+ASMMACRO(mtc0_tlbw_hazard,
+	_ssnop; _ssnop; _ehb
+	)
+ASMMACRO(tlbw_use_hazard,
+	_ssnop; _ssnop; _ssnop; _ehb
+	)
+ASMMACRO(tlb_probe_hazard,
+	 _ssnop; _ssnop; _ssnop; _ehb
+	)
+ASMMACRO(irq_enable_hazard,
+	 _ssnop; _ssnop; _ssnop; _ehb
+	)
+ASMMACRO(irq_disable_hazard,
+	_ssnop; _ssnop; _ssnop; _ehb
+	)
+ASMMACRO(back_to_back_c0_hazard,
+	 _ssnop; _ssnop; _ssnop; _ehb
+	)
+/*
+ * gcc has a tradition of misscompiling the previous construct using the
+ * address of a label as argument to inline assembler.  Gas otoh has the
+ * annoying difference between la and dla which are only usable for 32-bit
+ * rsp. 64-bit code, so can't be used without conditional compilation.
+ * The alterantive is switching the assembler to 64-bit code which happens
+ * to work right even for 32-bit code ...
+ */
+#define __instruction_hazard()						\
+do {									\
+	unsigned long tmp;						\
+									\
+	__asm__ __volatile__(						\
+	"	.set	mips64r2				\n"	\
+	"	dla	%0, 1f					\n"	\
+	"	jr.hb	%0					\n"	\
+	"	.set	mips0					\n"	\
+	"1:							\n"	\
+	: "=r" (tmp));							\
+} while (0)
+
+#define instruction_hazard()						\
+do {									\
+	if (cpu_has_mips_r2)						\
+		__instruction_hazard();					\
+} while (0)
+
 #elif defined(CONFIG_CPU_R10000)
 
 /*

-- 
