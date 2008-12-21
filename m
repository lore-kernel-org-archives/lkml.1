Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYLUUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYLUUzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYLUUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:54:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34292 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYLUUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:54:47 -0500
Date: Sun, 21 Dec 2008 21:54:45 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] arch/powerpc/platforms/85xx: Add local_irq_restore in
 error handling code
Message-ID: <Pine.LNX.4.64.0812212154240.3635@ask.diku.dk>
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
 arch/powerpc/platforms/85xx/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff -u -p a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -58,6 +58,7 @@ smp_85xx_kick_cpu(int nr)
 
 	if (cpu_rel_addr == NULL) {
 		printk(KERN_ERR "No cpu-release-addr for cpu %d\n", nr);
+		local_irq_restore(flags);
 		return;
 	}
 
