Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbYCSUeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbYCSUeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYCSTjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858AbYCSThf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:35 -0400
Date: Tue, 18 Mar 2008 20:28:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <200803190424.30971.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0803182013090.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803190221.58968.bzolnier@gmail.com> <alpine.LFD.1.00.0803181814170.3020@woody.linux-foundation.org> <200803190424.30971.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Please take a closer look - my "real fix" _only_ affects WIN_SMART command
> and _not_ vendor special ones (no, there are none vendor special commands
> using the same opcode).

Oh, trust me, I understand your fix.

But the point is that your fix

 - doesn't fix any other commands (and there are tons of other commands 
   people may be using)

 - and is totally pointless and isn't *needed* if we just fix this 
   properly (ie we've never cared before, so why should we start caring 
   now?).

See?

Fixing this properly is exactly what my patch did - it made the whole core 
engine not really even care. Just like it used to.

> Call taskfile crap all you want [ ... ]

You're totally not listening or understanding.

I'm not calling taskfile crap as a concept.

I'm calling fragile code that fails unnecessarily crap.

See the difference?

The old "drive_cmd_intr()" code (that you deleted) was fundamentally more 
robust than the taskfile code you replaced it with. 

And that's not just an opinion. It's a *fact*. It's why this bug showed up 
in the first place. Code that used to work because it didn't even care all 
that deeply about every single detail being set up just the way it wanted 
got replaced by code that was fragile.

Do you see the difference?

If we have a choice between robust code that just "does the right thing" 
even in the face of problems, and code that "stops working when you look 
at it wrong", which one should we choose? Which one is the better code? 
Which one is crap, and which one isn't?

The fact is, the old "drive_cmd_intr()" code was simply more robust.

So this is why I feel so strongly about this. Robust code is just about 
the most important thing we can have in the kernel. Bugs will always 
happen, but when they happen, we shouldn't just fall over dead. And that's 
exactly what code robustness is all about.

So we should make the DRQ/ERR status bit handling robust in the face of 
hardware and software that does odd things. Because we definitely have 
seen cases of both. Sometimes it is hw that doesn't work the way the spec 
requires, sometimes it's software that doesn't follow the spec 100%. It 
doesn't matter.

And once the status bit handling is robust (like it _used_ to be!), only 
*then* should we even ask ourself if we even care about having some random 
tfargs.data_phase value for specific SMART command sub-cases.

My personal opinion is obviously that we simply shouldn't even care (since 
we should now know that the driver doesn't care one way or the other), but 
if you want to apply your patch despite it having absolutely no meaning, 
that's your choice.

But the absolute first thing we should do is to make the code at least as 
robust as it used to be, and preferably aim _higher_ in robustness rather 
than lower!

		Linus
