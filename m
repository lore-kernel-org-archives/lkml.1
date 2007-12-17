Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXLQNE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXLQNE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXLQNET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:04:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:57092 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXLQNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:04:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BSKs6vozDg+na1dbXNrH6CLQIJMTQJRiuDdpjbmjz/sxHVdkBgGaIVN0rvlodgTjC9zm2kiqjSckF2zNM9IRA8dzaGlZWJtXyxut+izD1H5/mdHQJlqZCJp7qhV9vj7k6qSTMItp4rBw3+J26ypow+Bm64o40L1u1iVX9U2meJU=
Message-ID: <47667366.7010405@gmail.com>
Date: Mon, 17 Dec 2007 14:02:30 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com>
In-Reply-To: <4765EE7F.80002@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 04:35, H. Peter Anvin wrote:

> Well, we probably should leave the possibility in to use 0x80 -- for one 
> thing, we need to use 0x80 on 386, and there is always the possibility 
> that the switch will have different timing properties on some or all 
> machines.
> 
> Note that this doesn't require that a machine actually implements port 
> 0xf0 for FERR/IGNNE, it just requires that they don't use it for 
> something else.
> 
> I would be rather inclined to try using port 0xf0 by default as long as 
> family > 3[*] (with fallback to port 0x80) at least experimentally (-mm).

Possible timing differences would be what worry me. 0x80 is well-known for 
its delay purposes, and frankly, I dont believe that one type of machine 
having a problem, which may very well have to be categorized a possibly BIOS 
fixable bug, is enough ground for switching everyone over to a different port

It's enough ground to look at not doing outputs at all AFAIC but that's more 
due to the outb being somewhat cheesy to start with which using a different 
port wouldn't change. But, on the other hand:

> We *might* even be able to use port 0xf0 unconditionally in the setup 
> code, since we're not using the FPU there (the only FPU instructions in 
> the setup code are there to detect the FPU.)
> 
> One thing: although I believe most actual implementations of port 0xf0 
> implement it as a strobe alone (data is ignored), all documentation I've 
> found, including "The Undocumented PC" specifically says "write 0x00 to 
> this port."  This *could* mean there are platforms which use other 
> values than 0x00 for other hacks.

The Intel PIIX/PIIX3 datasheet confirms that the data is of no consequence, 
but yes, most documentation talks about 0.

The PIIX/PIIX3 datasheet also says that both reads and writes flow through 
to the ISA bus, while for port 0x80 only writes do, and reads do not.

I do not know how universal that is, but _reading_ port 0xf0 might in fact 
be sensible then? And should even work on a 386/387 pair? (I have a 386/387 
in fact, although I'd need to dig it up).

Versus the out it has the al clobber disadvantage, but givne that we're by 
now seem to be talking about out of line switch() native_io_delays anyways, 
that's not much of a problem anymore...

> [*] The following statements are equivalent:
>     - family > 3.
>     - CR0.NE is settable.
>     - EFLAGS.AC is settable.

For the boot code, I gather (which could I suppose then also plug in the 
delay port in the zero page or somewhere for use by the kernel proper? I 
don't know how/if these bits communicate).

But, well, _reading_ port 0xf0 sounds promising across the board and low 
risk replacement _if_ teh PIIX/PIIX3 behaviour is as guaranteed as the port 
0x80 behaviour...

Rene.
