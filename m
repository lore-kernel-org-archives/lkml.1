Return-Path: <linux-kernel-owner+w=401wt.eu-S1764613AbXEYRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764613AbXEYRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761972AbXEYRwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:52:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXEYRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:52:02 -0400
Date: Fri, 25 May 2007 10:50:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Newport <crn@netunix.com>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <20070525103714.092ad631.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705251039300.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
 <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
 <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com>
 <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
 <20070525180304.2cc4dae0@the-village.bc.nu>
 <alpine.LFD.0.98.0705251012200.26602@woody.linux-foundation.org>
 <20070525103714.092ad631.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Andrew Morton wrote:
>
> > > There is an additional factor - dumps contain data which variously is -
> > > copyright third parties, protected by privacy laws, just personally
> > > private, security sensitive (eg browser history) and so on.
> > 
> > Yes. 
> 
> We're uninterested in pagecache and user memory and they should be omitted
> from the image (making it enormously smaller too).

The people who would use crash-dumps (big sensitive firms) don't trust 
you.

And they'd be right not to trust you. You end up having a _lot_ of 
sensitive data even if you avoid user memory and page cache. The network 
buffers, the dentries, and just stale data that hasn't been overwritten.

So if you end up having secure data on that machine, you should *never* 
send a dump to somebody you don't trust. For the financial companies 
(which are practically the only ones that would use dumps) there can even 
be legal reasons why they cannot do that!

> That leaves security keys and perhaps filenames, and these could probably
> be addressed.

It leaves almost every single kernel allocation, and no, it cannot be 
addressed.

How are you going to clear out the network packets that you have in 
memory? They're just kmalloc'ed. 

> > I'm sure we've had one or two crashdumps over the years that have actually 
> > clarified a bug.
> > 
> > But I seriously doubt it is more than a handful. 
> 
> We've had a few more than that, but all the ones I recall actually came
> from the kdump developers who were hitting other bugs and who just happened
> to know how to drive the thing.

Right, I don't dispute that some _developers_ might use dumping. I dispute 
that any user would practically ever use it.

And even for developers, I suspect it's _so_ far down the list of things 
you do, that it's practically zero.

> > But 99% of the time, the problem doesn't happen on a developer machine, 
> > and even if it does, 90% of the time you really just want the traceback 
> > and register info that you get out of an oops.
> 
> Often we don't even get that: "I was in X and it didn't hit the logs".

Yes. 

> You can learn a hell of a lot by really carefully picking through kernel
> memory with gdb.

.. but you can learn equally much with other methods that do *not* involve 
the pain and suffering that is a kernel dump.

Setting up netconsole or the firewire tools is much easier. The firewire 
thing in particular is nice, because it doesn't actually rely on the 
target having to even know about it (other than enabling the "remote DMA 
access" thing once on bootup).

If you've ever picked through a kernel dump after-the-fact, I just bet you 
could have done equally well with firewire, and it would have had _zero_ 
impact on your kernel image. Now, contrast that with kdump, and ask 
yourself: which one do you think is worth concentrating effort on?

 - kdump: lots of code and maintenance effort, doesn't work if the CPU 
   locks up, requires a lot of learning to go through the dump.

 - firewire: zero code, no maintenance effort, works even if the CPU locks 
   up. Still does require the same learning to go through the end result.

Which one wins? I know which one I'll push.

		Linus
