Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbYFDPLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbYFDPLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYFDPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:10:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:58640 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754779AbYFDPK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:10:56 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18hCDt19Xgh2Dme8AtQnaqkR0gc339+4eQTZwg7Tx
	PiOkqbmoXHoT6s
Date: Wed, 4 Jun 2008 17:11:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: dbrownell@users.sourceforge.net
Subject: [PATCH] spi: two bug-fixes
Message-ID: <Pine.LNX.4.64.0806041705430.32657@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two SPI-related fixes: unsigned int cannot be less than zero, and the list
search success check is wrong: for example, it didn't recognise failure for me
when I requested port 0.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

It might be a good idea to get it in for 2.6.26. As a side note I was 
surprised, that the compiler didn't generate a warning for "if (t<0)" for 
unsigned t, whereas it does generate one for unsigned char with the same 
flags (-Wall). I asked on gcc, there was one reply from Segher 
Boessenkool, it is unclear if this is going to be recognised as a bug or 
not: http://gcc.gnu.org/ml/gcc/2008-06/threads.html#00044

 arch/arm/mach-pxa/ssp.c |    2 +-
 drivers/gpio/mcp23s08.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/gpio/mcp23s08.c
===================================================================
--- linux-2.6.orig/drivers/gpio/mcp23s08.c	2008-06-04 12:11:26.000000000 +0200
+++ linux-2.6/drivers/gpio/mcp23s08.c	2008-06-04 12:11:50.000000000 +0200
@@ -178,7 +178,7 @@
 
 	mutex_lock(&mcp->lock);
 	t = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
-	if (t < 0) {
+	if ((int)t < 0) {
 		seq_printf(s, " I/O ERROR %d\n", t);
 		goto done;
 	}
Index: linux-2.6/arch/arm/mach-pxa/ssp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:26.000000000 +0200
+++ linux-2.6/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:50.000000000 +0200
@@ -330,7 +330,7 @@
 
 	mutex_unlock(&ssp_lock);
 
-	if (ssp->port_id != port)
+	if (&ssp->node == &ssp_list)
 		return NULL;
 
 	return ssp;

