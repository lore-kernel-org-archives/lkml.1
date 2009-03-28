Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZC1Qka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZC1Qka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZC1QkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:40:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbZC1QkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:40:20 -0400
Date: Sat, 28 Mar 2009 09:32:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Mark Lord <lkml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CE4B99.1090006@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.00.0903280916230.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org>
 <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org>
 <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <49CE4B99.1090006@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Mar 2009, Stefan Richter wrote:
> 
> Sure.  I forgot:  Not only the frequency of I/O disruption (e.g. due to
> kernel crash) factors into system reliability; the particular impact of
> such disruption is a factor too.  (How hard is recovery?  Will at least
> old data remain available? ...)

I suspect (at least from my own anecdotal evidence) that a lot of system 
crashes are basically X hanging. If you use the system as a desktop, at 
that point it's basically dead - and the difference between an X hang and 
a kernel crash is almost totally invisible to users.

Us kernel people may walk over to another machine and ping or ssh in to 
see, but ask yourself how many normal users would do that - especially 
since DOS and Windows has taught people that they need to power-cycle 
(and, in all honesty, especially since there usually is very little else 
you can do even under Linux if X gets confused).

And then part of the problem ends up being that while in theory the kernel 
can continue to write out dirty stuff, in practice people press the power 
button long before it can do so. The 30 second thing is really too long.

And don't tell me about sysrq. I know about sysrq. It's very convenient 
for kernel people, but it's not like most people use it.

But I absolutely hear you - people seem to think that "correctness" trumps 
all, but in reality, quite often users will be happier with a faster 
system - even if they know that they may lose data. They may curse 
themselves (or, more likely, the system) when they _do_ lose data, but 
they'll make the same choice all over two months later.

Which is why I think that if the filesystem people think that the 
"data=ordered" mode is too damn fundamentally hard to make fast in the 
presense of "fsync", and all sane people (definition: me) think that the 
30-second window for either "data=writeback" or the ext4 data writeout is 
too fragile, then we should look into something in between.

Because, in the end, you do have to balance performance vs safety when it 
comes to disk writes. You absolutely have to delay things for performance, 
but it is always going to involve the risk of losing data that you do care 
about, but that you aren't willing (or able - random apps and tons of 
scripting comes to mind) to do a fsync over.

Which is why I, personally, would probably be perfectly happy with a 
"async ordered" mode, for example. At least START the data writeback when 
writing back metadata, but don't necessarily wait for it (and don't 
necessarily make it go first). Turn the "30 second window of death" into 
something much harder to hit.

			Linus
