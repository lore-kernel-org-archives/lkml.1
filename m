Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXLNOeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXLNOeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXLNOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:33:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXLNOdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:33:55 -0500
Date: Fri, 14 Dec 2007 15:33:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: unlisted-recipients: no@elvis.elte.hu, To-header@elvis.elte.hu,
       on@elvis.elte.hu, "input <"@elvis.elte.hu,
       ";
	Rene Herman" <rene.herman@keyaccess.nl>,
       Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	;Rene Herman <rene.herman@keyaccess.nl>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071214143328.GB10130@elte.hu>
References: <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com> <475F23BD.3040903@reed.com> <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com> <20071212161245.3f388229@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212161245.3f388229@the-village.bc.nu>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> There is another reason we can't just do a dumb changeover - two 
> actually
> 
> #1: Some drivers are using inb_p/outb_p in PCI cases which are going 
> #to cause PCI posting changes. Most are probably just wrong in the 
> #first place but they need hand checking

hm, any intelligent way to force PCI posting? I guess not.

here's a list of candidate drivers (match the out*_p() pattern and do 
pci)

./char/epca.c 
./char/sonypi.c
./scsi/megaraid.c
./ide/pci/serverworks.c
./ide/pci/cmd640.c
./input/mouse/pc110pad.c
./i2c/busses/i2c-amd756.c
./i2c/busses/i2c-ali15x3.c
./i2c/busses/i2c-ali1563.c
./i2c/busses/i2c-ali1535.c
./i2c/busses/i2c-viapro.c
./i2c/busses/i2c-nforce2.c
./i2c/busses/i2c-i801.c
./i2c/busses/i2c-piix4.c
./hwmon/vt8231.c
./hwmon/via686a.c
./hwmon/sis5595.c
./telephony/ixj.c
./net/irda/donauboe.c
./watchdog/pcwd_pci.c
./watchdog/wdt_pci.c

> #2: We've got SMP cases that only 'work' because the odds of splitting
> the outb and the following port 0x80 cycle, which locks the bus, are tiny.
> 
> That is we've got
> 
> 		CPU1			CPU2
> 		main path		irq path
> 		outb
> 					outb
> 
> 		inb 0x80
> 					inb 0x80
> 
> races in one or two spots.

which seems to suggest we are better off not doing the port 0x80 trick 
at all.

	Ingo
