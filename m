Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXLHTZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXLHTZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXLHTZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:25:10 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:64682 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbXLHTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:25:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19v0Ig1I6mywik+BQUhKIdu
Message-ID: <475AEF8E.5040906@reed.com>
Date: Sat, 08 Dec 2007 14:25:02 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu>
In-Reply-To: <20071207160439.71b7f46a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox wrote:
>
> 0x80 should be fine for anything PC compatible anyway, its specifically
> reserved as a debug port and supported for *exactly* that purpose by
> many chipsets.
>
>   
Disagree. The definitions of PC compatible are quite problematic.   I 
have the advantage over some of you young guys, in that I actually wrote 
code on one of the first 5 breadboard IBM PCs on the planet at Software 
Arts, Inc. and I was directly involved in hardware spec projects with 
the original IBM and Compaq engineers.  No one actually defined the port 
numbered 80h as a "standard" for anything.  You won't find it documented 
in any early manual for an IBM machine.

The ISA bus supported unterminated transactions safely.   That allowed 
some clever folks to design BIOS diagnostic tools that optionally 
plugged into the bus.

In any case, my machine does not have an ISA bus.  Why should it?  It's 
a laptop!

Now the interesting thing is that I have been scanning the source code 
of Linux, and I find gazillions of inb_p outb_p and so forth 
instructions where they have NO value.   It's as if some hacker who half 
understood hardware threw in the _p "just to be safe".  Well, it's 
neither safe, nor is it economical of code or data.  It hangs up the bus 
on an MP machine, for example, even when it works, to do the delay by 
"outb al,80h"

Worse, the actual requirements of the gazillions of inb_p instructions 
for delays are not documented in the code!  This is interesting, because 
the number of devices likely to need a delay after providing data on an 
"in" instruction is very likely to be near zero.  After all, the device 
has already serviced the bus and delivered data!  Why put many 
microseconds into the bus, locking out other ISA transactions (and PCI 
maybe too) with an out to port 80?

Some of the code in linux is really nice, really clean, really 
well-thought out.  Some is ... well, I'm not trolling for a fight.



