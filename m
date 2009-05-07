Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbZEGEiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbZEGEiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZEGEhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:37:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:46791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZEGEhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:37:52 -0400
Message-ID: <4A026540.8060504@kernel.org>
Date: Wed, 06 May 2009 21:36:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix compute high_width with phys-addr is 44bit and more
References: <4A0136F4.4010504@kernel.org> <20090506071839.GA14412@elte.hu> <4A014A9D.8000903@cn.fujitsu.com> <20090506161116.GA5997@nowhere>
In-Reply-To: <20090506161116.GA5997@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found one system that cpu address line is 44bits, mtrr printout is not right.

[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
[    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
[    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
[    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable

Li Zefan and Frederic pointed out the high_width could be -4 some how.

it turns out when phys_addr is 44bit, size_or_mask will be ffffffff,00000000
so ffs(size_or_mask) will be 0.

try to check low 32 bit, to get correct high_width.

Signed-off-by: Yinghai Lu <yinghai@kerne.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -275,7 +275,11 @@ static void __init print_mtrr_state(void
 	}
 	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
 	       mtrr_state.enabled & 2 ? "en" : "dis");
-	high_width = ((size_or_mask ? ffs(size_or_mask) - 1 : 32) - (32 - PAGE_SHIFT) + 3) / 4;
+	if (size_or_mask & 0xffffffffUL)
+		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
+	else
+		high_width = ffs(size_or_mask>>32) + 32 - 1;
+	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
 			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
