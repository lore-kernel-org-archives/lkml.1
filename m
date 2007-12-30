Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbXL3Q5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbXL3Q5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXL3Q5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:57:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55262 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbXL3Q5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:57:41 -0500
Date: Sun, 30 Dec 2007 16:48:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230164828.039916c8@the-village.bc.nu>
In-Reply-To: <20071230160132.GA14311@elte.hu>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<20071230153818.1a554a7e@the-village.bc.nu>
	<20071230160132.GA14311@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok. Is it more of a "gets flushed due to timing out", or a 
> specified-for-sure POST flushing property of all out 0x80 cycles going 
> to the PCI bridge? I thought PCI posting policy is up to the CPU, it can 
> delay PCI space writes arbitrarily (within reasonable timeouts) as long 
> as no read is done from the _same_ IO space address. Note that the port 
> 0x80 cycle is neither a read, nor for the same address.

Its what appears to happen reliably on real computers.

> i'm wondering, how safe would it be to just dumbly replace outb_p() 
> with:
> 
> 	out(port);
> 	in(port);

Catastrophic I imagine. If the delay is for timing access then you've just
broken the timing, if the port has side effects you've just broken the
driver.

> in these drivers. Side-effects of inb() would not be unheard of for the 
> ancient IO ports, but for even relatively old SCSI hardware, would that 
> really be a problem?

The specific drivers need reviewing. There are very few uses in PCI space
so it's a minor job.

> ah, i understand. So i guess a stupid udelay_serialized() which takes a 
> global spinlock would solve these sort of races? But i guess making them 
> more likely to trigger would lead to a better kernel in the end ...

Better to just fix the drivers. I don't think that will take too many
days after everyone is back working.

> doing it - but we'll do the plunge in v2.6.25 and make io_delay=udelay 
> the default, hm? Thomas has a real 386DX system, if that doesnt break 

For processors with TSC I think we should aim for 2.6.25 to do this and
to have the major other _p fixups done. I pity whoever does stuff like
the scc drivers but most of the rest isn't too bad.

Alan
