Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbXIXROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbXIXROh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbXIXRO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:14:28 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:46702 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbXIXRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:14:27 -0400
Date: Mon, 24 Sep 2007 18:14:17 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, kraxel@redhat.com, lethal@linux-sh.org,
       rgetz@blackfin.uclinux.org, vapier.adi@gmail.com
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
In-Reply-To: <20070921144523.GD20277@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64N.0709241755220.22491@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
 <20070921010349.2caee558.akpm@linux-foundation.org>
 <Pine.LNX.4.64N.0709211428300.2724@blysk.ds.pg.gda.pl>
 <20070921134331.GC20277@flint.arm.linux.org.uk>
 <Pine.LNX.4.64N.0709211454570.2724@blysk.ds.pg.gda.pl>
 <20070921144523.GD20277@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Russell King wrote:

> >  I see no problem with implementing the ->pm() call as something like:
> > 
> > void zs_pm(struct uart_port uport, unsigned int state, unsigned int oldstate)
> > {
> > 	struct zs_port *zport = to_zport(uport);
> > 
> > 	if (state < 3)
> > 		zport->regs[5] |= TxENAB;
> > 	else
> > 		zport->regs[5] &= ~TxENAB;
> > 	write_zsreg(zport, R5, zport->regs[5]);
> > }
> > 
> > itself, but it looks more like a workaround than a fix to me.  I'll have 
> > to think about it and also double-check it is safe.  The SCC is about as 
> > complicated as you can get with a serial port.
> 
> You will need the serial patch from the above mbox.

 I have got it now and tried together with the function above and some 
minor adjustments as appropriate elsewhere.  It seems to work; by 
coincidence (because of the sequence the bootstrap initialisation of the 
console and the serial core is done) it even works when the selected real 
console is other than the bootstrap one.  I do not particularly like to 
have things working by accident and I stand by what I said previously 
about this approach looking hackish to me.

 Though lacking better proposals I suppose this will have to stay.  Here 
is a change I have implemented; if no further comments are seen, I will 
submit it for inclusion.

  Maciej

patch-mips-2.6.23-rc5-20070904-zs-pm-4
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/zs.c linux-mips-2.6.23-rc5-20070904/drivers/serial/zs.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/zs.c	2007-09-04 04:55:44.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/zs.c	2007-09-22 20:25:10.000000000 +0000
@@ -787,7 +787,6 @@ static int zs_startup(struct uart_port *
 	zport->regs[1] &= ~RxINT_MASK;
 	zport->regs[1] |= RxINT_ALL | TxINT_ENAB | EXT_INT_ENAB;
 	zport->regs[3] |= RxENABLE;
-	zport->regs[5] |= TxENAB;
 	zport->regs[15] |= BRKIE;
 	write_zsreg(zport, R1, zport->regs[1]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -814,7 +813,6 @@ static void zs_shutdown(struct uart_port
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
-	zport->regs[5] &= ~TxENAB;
 	zport->regs[3] &= ~RxENABLE;
 	write_zsreg(zport, R5, zport->regs[5]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -959,6 +957,23 @@ static void zs_set_termios(struct uart_p
 	spin_unlock_irqrestore(&scc->zlock, flags);
 }
 
+/*
+ * Hack alert!
+ * Required solely so that the initial PROM-based console
+ * works undisturbed in parallel with this one.
+ */
+static void zs_pm(struct uart_port *uport, unsigned int state,
+		  unsigned int oldstate)
+{
+	struct zs_port *zport = to_zport(uport);
+
+	if (state < 3)
+		zport->regs[5] |= TxENAB;
+	else
+		zport->regs[5] &= ~TxENAB;
+	write_zsreg(zport, R5, zport->regs[5]);
+}
+
 
 static const char *zs_type(struct uart_port *uport)
 {
@@ -1041,6 +1056,7 @@ static struct uart_ops zs_ops = {
 	.startup	= zs_startup,
 	.shutdown	= zs_shutdown,
 	.set_termios	= zs_set_termios,
+	.pm		= zs_pm,
 	.type		= zs_type,
 	.release_port	= zs_release_port,
 	.request_port	= zs_request_port,
@@ -1190,6 +1206,7 @@ static int __init zs_console_setup(struc
 		return ret;
 
 	zs_reset(zport);
+	zs_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
