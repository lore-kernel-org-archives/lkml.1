Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXLQOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXLQOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXLQOng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:43:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbXLQOnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:43:35 -0500
Date: Mon, 17 Dec 2007 15:42:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       unlisted-recipients:
	no@elvis.elte.hu, To-header@elvis.elte.hu,
       on@elvis.elte.hu, "input <"@elvis.elte.hu,
       "; Rene Herman" <rene.herman@keyaccess.nl>,
       Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071217144251.GB16604@elte.hu>
References: <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com> <475F23BD.3040903@reed.com> <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com> <20071212161245.3f388229@the-village.bc.nu> <20071214143328.GB10130@elte.hu> <20071216212628.GF14265@elf.ucw.cz> <20071217000301.1c280daa@the-village.bc.nu> <20071217002827.GG5692@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217002827.GG5692@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > > > ./char/epca.c 
> > > > ./char/sonypi.c
> > > > ./scsi/megaraid.c
> > > > ./ide/pci/serverworks.c
> > > > ./ide/pci/cmd640.c
> > > > ./input/mouse/pc110pad.c
> > 
> > You are missing some watchdogs at least ?
> 
> I snipped them, I only wanted to comment that pc110pad.c looks like
> legitimate use of outb_p().

since this code seems to run late during bootup (a mouse driver), could 
we replace this with udelay(2), and get rid of that outb_p()? I.e. via 
the patch below?

	Ingo

----------------->
Subject: x86: replace outb_p() with udelay(2) in drivers/input/mouse/pc110pad.c
From: Ingo Molnar <mingo@elte.hu>

replace outb_p() with udelay(2). This is a real ISA device so it likely
needs this particular delay.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/input/mouse/pc110pad.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-x86.q/drivers/input/mouse/pc110pad.c
===================================================================
--- linux-x86.q.orig/drivers/input/mouse/pc110pad.c
+++ linux-x86.q/drivers/input/mouse/pc110pad.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -62,8 +63,10 @@ static irqreturn_t pc110pad_interrupt(in
 	int value     = inb_p(pc110pad_io);
 	int handshake = inb_p(pc110pad_io + 2);
 
-	outb_p(handshake |  1, pc110pad_io + 2);
-	outb_p(handshake & ~1, pc110pad_io + 2);
+	outb(handshake |  1, pc110pad_io + 2);
+	udelay(2);
+	outb(handshake & ~1, pc110pad_io + 2);
+	udelay(2);
 	inb_p(0x64);
 
 	pc110pad_data[pc110pad_count++] = value;
