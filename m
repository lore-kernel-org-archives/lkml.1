Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYAARlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYAARlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYAARlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:41:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56575 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753639AbYAARlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:41:36 -0500
Date: Tue, 1 Jan 2008 17:32:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101173212.1bba4939@the-village.bc.nu>
In-Reply-To: <20080101164338.GA901@elte.hu>
References: <4765D43E.1010800@gmail.com>
	<4765D95C.4010404@zytor.com>
	<4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
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

> there strong counter-arguments against doing the clean thing and adding 
> an udelay(2) (or udelay(1)) to replace those _p() uses in ISA drivers? 

#1 udelay has to be for the worst case bus clock (6MHz) while the device
may be at 10Mhz or even 12MHz ISA. So it slows it down stuff
unneccessarily- and stuff that really really is slow enough as is.

#2 Most of the ancient wind up relics with ISA bus don't have a tsc so
their udelay value is kind of iffy.

#3 Not changing it is the lowest risk for a lot of the old ISA code that
never occurs on newer boxes

If we have an isa_inb_p() as a specific statement of "I am doing an ISA
bus dependant delay on ancient crap hardware" then we can avoid the risk
of breakage. We wouldn't use it for non ISA, and certainly not for stuff
like chipset logic which requires a more thorough fix as it occurs on all
kinds of boxes.

> _will_ change a bit, no matter what we do. Alignments change, the 
> compiler output will change (old compilers get deprecated so a new 
> compiler might have to be picked), cache effects change - and this is 
> inevitable. The important thing is to not eliminate the delays - but we 
> sure dont have to keep them cycle accurate (we couldnt even if we wanted 
> to). The only way to get the _exact same_ behavior is to not change the 
> kernel at all.

ISA bus cycles are *slow*, the subtle processor cache and gcc triggered
timing changes are lost in the noise.

Alan
