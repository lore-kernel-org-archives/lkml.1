Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbXLOQTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbXLOQTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 11:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXLOQTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 11:19:24 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:57432 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbXLOQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:19:23 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18z5KMR9wikBT4l+iPUm1Q3
Message-ID: <4763FE7A.4000105@reed.com>
Date: Sat, 15 Dec 2007 11:19:06 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071215074358.GD12110@elte.hu>	<4763891A.3010004@gmail.com>	<20071215132725.GA23166@elte.hu> <20071215142929.5462b329@the-village.bc.nu>
In-Reply-To: <20071215142929.5462b329@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand the risks of such a fundamental change, and it may be only 
a minor concern, but I did also point out that using an unused port 
causes the bus to be tied up for a microsecond or two, which matters on 
a fast SMP machine.

Of course all the other concerns you guys are worrying about are really 
important.  I don't want to break anybody's running systems...  I'd like 
to see my machine run smoothly, and all the other machines that may or 
may not have this problem (google "hwclock freeze" to see that I'm far 
from alone - I just have persevered in "bisecting" this problem with 
kernel tweaks for months, whereas the others did not or did not know how).

By the way, this laptop is really nice for Linux in lots of ways.  Dual 
drives, so I set it up with software RAID for reliability, dual 64-bit 
processors, fast 3D graphics, etc.  Great battery life.  Just one last 
kernel issue.

I also note that curent machines like the problem machine have ACPI, and 
maybe those would be the ones that vendors might start to define port 80 
to mean something. As I noted, it /seems/ to be only when ACPI is turned 
on that this problem happens on my machine - that's when the OS starts 
to be involved in servicing various things, so it suggests that maybe 
things change about port 80's unknown function on these machines when 
ACPI is servicing the system management code (that's not something I 
have been able to verify).

My belief is that my machine has some device that is responding to port 
80 by doing something.  And that something requires some other program 
to "service" port 80 in some way.  But it sure would be nice to know.   
I can't personally sand off the top of the chipset to put probes into it 
- so my normal approach of putting a logic analyzer on the bus doesn't work.

PS: If I have time, I may try to build Rene's port 80 test for Windows 
and run it under WinXP on this machine (I still have a crappy little 
partition that boots it).   If it freezes the same way, it's almost 
certain a design "feature", and if it doesn't freeze, we might suspect 
that there is compensating logic in either Windows ACPI code or some way 
that windows "sets up" the machine.

Alan Cox wrote:
> On Sat, 15 Dec 2007 14:27:25 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Rene Herman <rene.herman@gmail.com> wrote:
>>
>>     
>>> The issue is -- how do you safely replace the outb pre-loops_per_jiffy 
>>> calibration? I'm currently running with the attached hack (not 
>>> submitted, only for 32-bit and discussion) the idea of which might be 
>>> the best we can do?
>>>       
>> how about doing a known-NOP chipset cycle? For example:
>>
>>   inb(PIC_SLAVE_IMR)
>>     
>
> It needs tobe a different chip to the main one (or macrocell anyway) - so
> PIC for PIT and vice versa. However since we know 0x80 works for
> everything on the planet but this one specifies of laptop which seems to
> need a firmware update its a very high risk approach.
>
> Alan
>
>   
