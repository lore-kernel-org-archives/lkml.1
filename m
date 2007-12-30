Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXL3Pg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXL3Pg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXL3PgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:36:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXL3PgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:36:17 -0500
Date: Sun, 30 Dec 2007 16:28:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230152835.GX16946@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230144700.78f4605c@the-village.bc.nu>
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

> For modern systems we should just use tsc delays, but we have to fix 
> all the drivers first as right now 0x80 causes posting and we have 
> some PCI users (I think probably all bogus), and we need to fix the 
> tons of locking errors that are mostly covered by the inb 0x80 being 
> an indivisible operation so not getting split by interrupts/SMP.

i dont get your last point. Firstly, we do an "outb $0x80" not an inb. 
Secondly, outb $0x80 has no PCI posting side-effects AFAICS. Thirdly, 
even assuming that it has PCI posting side-effects, how can any locking 
error be covered up by an outb 0x80 sticking together with the inb it 
does before it? The sequence we emit is:

  inbb $some_port
  outb $0x80

and i see that the likelyhood of getting such sequences from two CPUs 
'mixed up' are low, but how can this have any smp locking side-effects? 
How can this provide any workaround/coverup?

> I've been going through the drivers that use it - the biggest mess 
> appears to be in the watchdog drivers all of which copied an original 
> lack of locking from the mid 1990s caused by umm.. me. I guess my past 
> is catching up with me ;)

heh :-)

> The X server also appears to touch 0x80 in some cases but we can hope 
> only on ancient hardware.

do you have any memories about the outb_p() use of misc_32.c:

        pos = (x + cols * y) * 2;       /* Update cursor position */
        outb_p(14, vidport);
        outb_p(0xff & (pos >> 9), vidport+1);
        outb_p(15, vidport);
        outb_p(0xff & (pos >> 1), vidport+1);

was this ever needed? This is so early in the bootup that can we cannot 
do any sensible delay. Perhaps we could try a natural delay sequence via 
inb from 0x3cc:

        outb(14, vidport);
         inb(0x3cc); /* delay */
        outb(0xff & (pos >> 9), vidport+1);
         inb(0x3cc); /* delay */
        outb(15, vidport);
         inb(0x3cc); /* delay */
        outb(0xff & (pos >> 1), vidport+1);
         inb(0x3cc); /* delay */

as a dummy delay (totally untested).

Reading from the 0x3cc port does not impact the cursor position update 
sequence IIRC - i think the vidport is even ignored for the input 
direction by most hardware, there's a separate input register. The 0x3cc 
port is a well-defined VGA register which should be unused on non-VGA 
hardware. (which makes it a perfect delay register in any case)

	Ingo
