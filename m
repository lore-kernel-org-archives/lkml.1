Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYGVQpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYGVQpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYGVQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:44:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35253 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYGVQov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:44:51 -0400
Date: Tue, 22 Jul 2008 18:44:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] : Add local_irq_restore in error handling code
Message-ID: <Pine.LNX.4.64.0807221844250.2670@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There is a call to local_irq_restore in the normal exit case, so it would
seem that there should be one on an error return as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
expression E,E1,E2;
@@

local_irq_save(l);
... when != local_irq_restore(l)
    when != spin_unlock_irqrestore(E,l)
    when any
    when strict
(
if (...) { ... when != local_irq_restore(l)
               when != spin_unlock_irqrestore(E1,l)
+   local_irq_restore(l);
    return ...;
}
|
if (...)
+   {local_irq_restore(l);
    return ...;
+   }
|
spin_unlock_irqrestore(E2,l);
|
local_irq_restore(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/mips/mm/tlb-r3k.c        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index a782549..7d7e822 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -247,6 +247,7 @@ void __init add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 		w = read_c0_wired();
 		write_c0_wired(w + 1);
 		if (read_c0_wired() != w + 1) {
+			local_irq_restore(flags);
 			printk("[tlbwired] No WIRED reg?\n");
 			return;
 		}
