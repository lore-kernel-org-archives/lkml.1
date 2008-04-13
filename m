Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYDMOo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYDMOo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYDMOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:44:25 -0400
Received: from mail4.zarcrom.net ([209.236.236.162]:37898 "EHLO
	mail4.zarcrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418AbYDMOoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:44:24 -0400
Subject: Re: [RFC][PATCH] HPET: register additional counter-only char device
From: Dimitri Gorokhovik <dimitri.gorokhovik@leacom.fr>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47FF8A74.4000002@ladisch.de>
References: <1207904307.13216.15.camel@laphroaig>
	 <47FF658E.2040808@ladisch.de> <1207922810.26014.33.camel@laphroaig>
	 <47FF8A74.4000002@ladisch.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sun, 13 Apr 2008 16:40:53 +0200
Message-Id: <1208097653.8038.36.camel@laphroaig>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Originating-IP: 83.206.44.221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 17:57 +0200, Clemens Ladisch wrote: 
> Dimitri Gorokhovik wrote:
> > 
> > -- to me, /dev/hpet is primarily a timer, not just a counter. It seems
> > wrong to me if it, once opened, would mostly fail to its primary
> > function (but this of course is all subjective matter).
> 
> There are at least as many available timers as before the change -- a
> program that tries to use a timer will still get a timer, and now this
> will succeed even if there are other programs that use only the counter.
> 
> Even now, for most programs using /dev/hpet, it actually is just a
> counter.

The problem with the implementation of this approach is the multiple hw
instrances of HPET, which is currently supported. Unless one can rip it
all off and hardwire '/dev/hpet' to a single HPET hardware block (can
one ?), I can't seem to figure out how to implement the proposed
modification.

An example:

-- an application opens '/dev/hpet'. ﻿There are several HPET hw blocks
in the system -- physical address of some of them is used -- success is
returned. ﻿A hw timer slot is not allocated at this point.

-- the app 'mmap's the opened device (the phys address selected in the
'open' is used).

-- some time later, the app issues an 'ioctl' call -- it wants the
interrupt enabled and so a hw timer slot has to be allocated.

It appears that there are no timers available on the hw block whose phys
addr has been used for open/mmap, but there are free timers on the
other(s) HPET hw blocks.

Our choice:
a) 'ioctl' should fail;
b) 'ioctl' may return a timer from another hw block.

I think b) is fundamentally broken. a) risks to return too many failures
with timer slots still available, unless some strategy is devised for
distribution of 'open's across the hw blocks.

Now imagine HPET hw blocks are not created equal in the system (most
likely, clocking frequency is different). What would be such a strategy
in this case ?

All this yields a complex implementation without a real reason (many
(most?) systems with only one HPET hw block), and still a problematic
user interface (how does one chooses the HPET block he or she wants?),
only in the name of the compatibility with the existing interface.

The clean interface would be to have:

/dev/hpet0/counter
          /timer0
          /timer1
          /timer2
	  /...

[/dev/hpet1/...]

'counter' device allowing 'mmap' and 'ioctl(HPET_INFO)', and timer
devices allowing rest of IOCTLs and other fops except mmap. Choosing a
suitable HPET hw is a policy belonging in the app -- right now it is in
the kernel, even thought it is as simple as walking a list.

But then again, such implementation would break the existing interface.

Regards,

Dimitri
  

