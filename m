Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXLQDhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXLQDhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 22:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXLQDg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 22:36:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXLQDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 22:36:57 -0500
Message-ID: <4765EE7F.80002@zytor.com>
Date: Sun, 16 Dec 2007 19:35:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com>
In-Reply-To: <4765DCB0.8030901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 17-12-07 03:05, H. Peter Anvin wrote:
> 
>> Incidentally, I had the thought earlier today that port 0xf0 might be 
>> a suitable delay port.  It is used only by the 387-emulating-a-287 
>> hack for IRQ 13, which Linux doesn't use on 486+.
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> rene@7ixe4:~/src/port80$ su -c ./portf0
> cycles: out 2400, in 2400
> 
> (Duron 1300)
> 
> I suppose you mean using it instead of port 0x80 always and not just as 
> an alternate port? For the latter 0xed is alright I guess...
> 

Well, we probably should leave the possibility in to use 0x80 -- for one 
thing, we need to use 0x80 on 386, and there is always the possibility 
that the switch will have different timing properties on some or all 
machines.

Note that this doesn't require that a machine actually implements port 
0xf0 for FERR/IGNNE, it just requires that they don't use it for 
something else.

I would be rather inclined to try using port 0xf0 by default as long as 
family > 3[*] (with fallback to port 0x80) at least experimentally (-mm).

We *might* even be able to use port 0xf0 unconditionally in the setup 
code, since we're not using the FPU there (the only FPU instructions in 
the setup code are there to detect the FPU.)

One thing: although I believe most actual implementations of port 0xf0 
implement it as a strobe alone (data is ignored), all documentation I've 
found, including "The Undocumented PC" specifically says "write 0x00 to 
this port."  This *could* mean there are platforms which use other 
values than 0x00 for other hacks.

	-hpa


[*] The following statements are equivalent:
     - family > 3.
     - CR0.NE is settable.
     - EFLAGS.AC is settable.

