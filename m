Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXLOODV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXLOODV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 09:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXLOODP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 09:03:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:15739 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXLOODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 09:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=oKXW4XCPsvtMF8yjH6m/ZrT0eISuZsic1qL8++YZE6uuyn2mGTfe7wq+EbHOfIdsYt05zCNCTxG7dXihHZZnyEUO4TORwtO/wPZUQ6WToNS0Jv1fTcuNj2vYh0GpCrgBkc7TnxaAeGpHPMGR3joqZCuVjy6QhYBywn1FILJ+lBs=
Message-ID: <4763DE3F.405@gmail.com>
Date: Sat, 15 Dec 2007 15:01:35 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071215074358.GD12110@elte.hu> <4763891A.3010004@gmail.com> <20071215132725.GA23166@elte.hu>
In-Reply-To: <20071215132725.GA23166@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-12-07 14:27, Ingo Molnar wrote:

> * Rene Herman <rene.herman@gmail.com> wrote:
> 
>> The issue is -- how do you safely replace the outb pre-loops_per_jiffy 
>> calibration? I'm currently running with the attached hack (not 
>> submitted, only for 32-bit and discussion) the idea of which might be 
>> the best we can do?
> 
> how about doing a known-NOP chipset cycle? For example:
> 
>   inb(PIC_SLAVE_IMR)

An inb is annoying in that it clobbers register al (well, with an inline 
native_io_delay it is at least) and more importantly -- the timing of this 
is going to vary wildly. We really want a register that is effectively 
guaranteed to be unused so that it dies on ISA/LPC or we might get _much_ 
faster PCI only decodes. Even reading port 0x80 itself varies wildly:

http://lkml.org/lkml/2007/12/12/309

> ? I.e. instead of trying to find an unused port, lets try to find a 
> known-used platform register that has no side-effects if read. Use it 
> unconditionally during early bootup and change it to an udelay after 
> calibration. (or use it after early bootup too if a boot parameter has 
> been specified) Or something like this.

It's really going to have to be a known _un_used register and (the write 
direction of) port 0x80 is used exactly for that reason. Port 0xed is a 
known "alternate diagnostic port" used by Phoenix BIOSes at least but Peter 
Anvin reported trouble with that one -- probably for the outb direction but 
assuming that means something was in fact responding, we'd have the same 
timing problem.

I believe we have two "good" options:

1) port 0xed was tested by the current reporter and found to be safe (and 
provide slow enough timing). If DMI  based quirk hacks are available soon 
enough we can switch 0x80 to 0xed based on it. Are they?

2) the thing I posted in the message replied to where immediately after 
tsc_init() (which is before the PIT init) we switch to udelay() if we have a 
TSC which is ofcourse anything modern.

Rene.
