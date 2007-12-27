Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbXL0KkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbXL0KkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 05:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXL0Kjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 05:39:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2159 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbXL0Kjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 05:39:53 -0500
Date: Thu, 27 Dec 2007 10:39:42 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071227103941.GA5353@ucw.cz>
References: <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com> <475F23BD.3040903@reed.com> <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com> <20071212161245.3f388229@the-village.bc.nu> <20071214143328.GB10130@elte.hu> <20071216212628.GF14265@elf.ucw.cz> <20071217000301.1c280daa@the-village.bc.nu> <20071217002827.GG5692@elf.ucw.cz> <20071217144251.GB16604@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217144251.GB16604@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-17 15:42:51, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > > > ./char/epca.c 
> > > > > ./char/sonypi.c
> > > > > ./scsi/megaraid.c
> > > > > ./ide/pci/serverworks.c
> > > > > ./ide/pci/cmd640.c
> > > > > ./input/mouse/pc110pad.c
> > > 
> > > You are missing some watchdogs at least ?
> > 
> > I snipped them, I only wanted to comment that pc110pad.c looks like
> > legitimate use of outb_p().
> 
> since this code seems to run late during bootup (a mouse driver), could 
> we replace this with udelay(2), and get rid of that outb_p()? I.e. via 
> the patch below?

Yes, that should work. But I do not have pc110 to verify it.
> 
> 	Ingo
> 
> ----------------->
> Subject: x86: replace outb_p() with udelay(2) in drivers/input/mouse/pc110pad.c
> From: Ingo Molnar <mingo@elte.hu>
> 
> replace outb_p() with udelay(2). This is a real ISA device so it likely
> needs this particular delay.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

ACK.


>  	int value     = inb_p(pc110pad_io);
>  	int handshake = inb_p(pc110pad_io + 2);
>  
> -	outb_p(handshake |  1, pc110pad_io + 2);
> -	outb_p(handshake & ~1, pc110pad_io + 2);
> +	outb(handshake |  1, pc110pad_io + 2);
> +	udelay(2);
> +	outb(handshake & ~1, pc110pad_io + 2);
> +	udelay(2);
>  	inb_p(0x64);
>  
>  	pc110pad_data[pc110pad_count++] = value;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
