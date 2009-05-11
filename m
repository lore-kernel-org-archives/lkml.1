Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZEKJ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZEKJ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbZEKJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:56:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:49461 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbZEKJz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:55:59 -0400
Date: Mon, 11 May 2009 09:54:26 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lizf@cn.fujitsu.com, vegard.nossum@gmail.com,
       zhaolei@cn.fujitsu.com, yinghai@kerne.org, jeremy@goop.org,
       fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, lizf@cn.fujitsu.com, vegard.nossum@gmail.com,
       zhaolei@cn.fujitsu.com, yinghai@kerne.org, jeremy@goop.org,
       fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A026540.8060504@kernel.org>
References: <4A026540.8060504@kernel.org>
Subject: [tip:x86/urgent] x86: mtrr: Fix high_width computation when phys-addr is >= 44bit
Message-ID: <tip-917a0153621572e88aeb2d5df025ad2e81027287@git.kernel.org>
Git-Commit-ID: 917a0153621572e88aeb2d5df025ad2e81027287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:54:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  917a0153621572e88aeb2d5df025ad2e81027287
Gitweb:     http://git.kernel.org/tip/917a0153621572e88aeb2d5df025ad2e81027287
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 21:36:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:40:43 +0200

x86: mtrr: Fix high_width computation when phys-addr is >= 44bit

found one system where cpu address line is 44bits, mtrr printout
is not right:

 [    0.000000] MTRR variable ranges enabled:
 [    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
 [    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
 [    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
 [    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable

Li Zefan and Frederic pointed out the high_width could be -4 some how.

It turns out when phys_addr is 44bit, size_or_mask will be
ffffffff,00000000 so ffs(size_or_mask) will be 0.

Try to check low 32 bit, to get correct high_width.

Signed-off-by: Yinghai Lu <yinghai@kerne.org>
Also-analyzed-by: Frederic Weisbecker <fweisbec@gmail.com>
Also-analyzed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A026540.8060504@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0b776c0..d21d4fb 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -275,7 +275,11 @@ static void __init print_mtrr_state(void)
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
