Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYFDPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYFDPdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYFDPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:33:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbYFDPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:33:04 -0400
Date: Wed, 4 Jun 2008 08:31:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, benh@kernel.crashing.org,
       Matthew Wilcox <matthew@wil.cx>, David Miller <davem@davemloft.net>,
       linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <20080602101102.0d8979c5@hskinnemo-gx745.norway.atmel.com>
Message-ID: <alpine.LFD.1.10.0806040811350.3473@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net> <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
 <1211922621.3286.80.camel@pasglop> <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org> <1211924335.3286.89.camel@pasglop> <20080527214241.GA22636@parisc-linux.org> <1211926636.3286.100.camel@pasglop> <20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
 <1212110003.15633.0.camel@pasglop> <20080530080700.773a82cc@siona.local> <1212132267.15633.69.camel@pasglop> <20080530102706.56fca248@siona.local> <Pine.LNX.4.64.0805301120510.26332@anakin> <20080602101102.0d8979c5@hskinnemo-gx745.norway.atmel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jun 2008, Haavard Skinnemoen wrote:
> 
> > So what happened to the old idea of putting the accessor function pointers
> > in the device/bus structure?
> 
> Don't know. I think it sounds like overkill to replace a simple load or
> store with an indirect function call.

Indeed. *Especially* as the driver in practice tends to always know which 
one it is statically.

Yes, sometimes the same RTL may end up being used behind two differnt 
buses, and with some broken byte-conversion hardware in the middle, but 
that's pretty damn rare in the end. It happens, but it happens mostly with 
the odd broken kind of embedded setups where somebody took a standard part 
and then did something _strange_ to it - and in the process they may well 
have introduced other issues as well.

I suspect you find this kind of thing mostly with things like stupid 
integrated IDE controllers, and things like byte order tends to be the 
_least_ of the issues (specialized register accesses with odd offsets etc 
will happen).

So most of the time the byte order is simply decided by the hardware 
itself (and LE is the common one, due to ISA/PCI). Sometimes you can set 
it dynamically (at which point it's irrelevant - just pick the one you 
want).

So I definitely argue against complex IO accessor functions with things 
like dynamic support for byte order depending on bus. 99.9% of all 
hardware simply do not need them, and the small percentage that might need 
it will need special drivers anyway, so they might as well do the 
complexity on their own rather than make everybody else care.

See for example the input driver for the i8042 chip: not only do those 
things sometimes need native order (probably exactly because it's 
integrated on a chip over some special "native bus", or just wired up to 
be big-endian on a BE platform by some moron), but you'll also find that 
they just need odd accesses anyway exactly because it's oddly wired up 
(eg it's some special serial protocol that emulates ISA accesses).

So having some "byte-order correcting function" still wouldn't make any 
sense, because it's not just about byte order.

Will that mean that you might occasionally have a "normal" driver and an 
"odd" driver that actually drives what is basically the same HW block, 
just wired up differently? Sure. But that's still a smaller price to pay 
than it would be to try to make everything be "generic" when there is no 
point to it.

			Linus
