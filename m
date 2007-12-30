Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbXL3ORw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbXL3ORw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXL3ORo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:17:44 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44292 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXL3ORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:17:43 -0500
Message-ID: <4777A7B8.5080205@keyaccess.nl>
Date: Sun, 30 Dec 2007 15:14:16 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: dpreed@reed.com, Islam Amer <pharon@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 10:30, Linus Torvalds wrote:

> On Sun, 30 Dec 2007, Rene Herman wrote:

>> This fixes "hwclock" triggered boottime hangs for a few HP/Compaq laptops
>> and might as such be applicable to 2.6.24 still.
> 
> It's not a regression as far as I can see (ie we've always done that port 
> 80 access for slow-down), and quite frankly, I think the code is horribly 
> ugly.

It is indeed not a regression. Submitted it as a stop-gap measure for those 
specific afflicted machines but I guess they'll mostly be able to google up 
the problem and patch by now as well..

> Using a DMI quirk for something like this is just not maintainable. Are we 
> going to live with doing new quirks forever? I'd rather just remove the 
> slowdown entirely (obviously that is not for 2.6.24 either, though!), and 
> drivers that then are shown to really need it could use their *own* ports.

And yes, "elegant" it is neither. It's a bit of a pesky problem though. Port 
0x80 is a decidedly non-random port selection in so far that it's just about 
the only available port with guaranteed (in a PC sense) effects -- various 
chipsets make specific efforts to forward port 0x80 writes onto ISA due to 
its use as a POST port by the PC BIOS meaning the outb outside its bus-level 
effects also has fairly well defined timing characteristics. In practice, a 
udelay(2) is going to satisfy the delay property though -- but doesn't do 
anything for the other things the outb() does.

The legacy PIT, PIC and DMA and KB controllers have been mentioned in this 
and previous incarnations of this same thread as hardware that in some 
implementations need the outb to function properly but ofcourse, no _sane_ 
implementations do. With an arch that purports to support just about 
anything though there's some fairly justified fear, uncertainty, doubt that 
the ones to break aren't going to be found and reported quickly/easily. In 
itself, that could mean it's also not something to be overly worried about, 
but still not nice.

With the various races in (legacy) drivers additionally an early suggestion 
by Andi Kleen to leave the outb in place for a DMI year < X (or no DMI 
available) and just do nothing for > X might in fact be justified.

Rene.

