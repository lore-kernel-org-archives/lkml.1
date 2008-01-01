Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYAAVGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYAAVGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYAAVG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:06:27 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:38795 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYAAVG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:06:26 -0500
Date: Tue, 1 Jan 2008 22:05:50 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-pcmcia@lists.infradead.org, vbordug@ru.mvista.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/pcmcia: Add missing iounmap
Message-ID: <Pine.LNX.4.64.0801012205020.19803@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

of_iomap calls ioremap, and so should be matched with an iounmap.  At the
two error returns, the result of calling of_iomap is only stored in a local
variable, so these error paths need to call iounmap.  Furthermore, this
function ultimately stores the result of of_iomap in an array that is local
to the file.  These values should be iounmapped at some point.  I have
added a corresponding call to iounmap at the end of the function m8xx_remove.



The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = of_iomap(...);
  if (E == NULL) S
  ... when != iounmap(...,(T1)E,...)
      when != if (E != NULL) { ... iounmap(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != iounmap(...,(T2)E,...)
        when != if (E != NULL) { ... iounmap(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
diff -u -p a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
--- a/drivers/pcmcia/m8xx_pcmcia.c	2007-10-22 11:25:20.000000000 +0200
+++ b/drivers/pcmcia/m8xx_pcmcia.c	2008-01-01 14:31:36.000000000 +0100
@@ -1174,8 +1174,10 @@ static int __init m8xx_probe(struct of_d
 
 	pcmcia_schlvl = irq_of_parse_and_map(np, 0);
 	hwirq = irq_map[pcmcia_schlvl].hwirq;
-	if (pcmcia_schlvl < 0)
+	if (pcmcia_schlvl < 0) {
+		iounmap(pcmcia);
 		return -EINVAL;
+	}
 
 	m8xx_pgcrx[0] = &pcmcia->pcmc_pgcra;
 	m8xx_pgcrx[1] = &pcmcia->pcmc_pgcrb;
@@ -1189,6 +1191,7 @@ static int __init m8xx_probe(struct of_d
 			driver_name, socket)) {
 		pcmcia_error("Cannot allocate IRQ %u for SCHLVL!\n",
 			     pcmcia_schlvl);
+		iounmap(pcmcia);
 		return -1;
 	}
 
@@ -1284,6 +1287,7 @@ static int m8xx_remove(struct of_device 
 	}
 	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
 		pcmcia_unregister_socket(&socket[i].socket);
+	iounmap(pcmcia);
 
 	free_irq(pcmcia_schlvl, NULL);
 
