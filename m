Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbXEYDdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbXEYDdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXEYDdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:33:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbXEYDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:33:37 -0400
Date: Thu, 24 May 2007 20:31:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <1180062040.3997.112.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost> 
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost>  <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
  <20070524200435.GA9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
  <20070524220017.GC9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
  <20070524221743.GD9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
  <20070524231852.GG9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
  <1180058123.3997.91.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> 
 <1180059605.3997.100.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
 <1180062040.3997.112.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Nigel Cunningham wrote:
> > 
> > That said, I think freezing is crap even for snapshotting/suspend-to-disk, 
> > but the point of the above rant is to show how insane it is to think that 
> > problems and complexity in one area should translate into problems and 
> > complexity in another area.
> 
> Does that imply that you'd prefer to see filesystem checkpointing code,
> that you think freezing can be done better, or do you have some other
> solution that hasn't occurred to me?

I actually don't think that processes should be frozen really at all.

I agree that filesystems have to be frozen (and I think that checkpointing 
of the filesystem or block device is "too clever"), but I just don't think 
that has anything to do with freezing processes.

So I'd actually much prefer to freeze at the VFS (and socket layers, etc), 
and make sure that anybody who tries to write or do something else that we 
cannot do until resuming, will just be blocked (or perhaps just buffered)!

See? I actually think that this process-based thing is barking up the 
wrong tree. After all, it's really not the case that we need to stop 
processes, and stopping processes really does have some problems. It's 
simpler in some ways, but I think a more directed solution would actually 
be better.

>bviously we _do_ want to actually try to quiesce normal user processes. 
>But by "normal user", I'd be willing to limit it to non-uid-zero things, 
>for example. Exactly because it does turn out that the kernel kind of 
>depends on user-land things for stuff like network filesystem connection 
>setup etc (ie we tend to do things like the mount encryption stuff in 
>userland!).

But I really don't care that deeply per se, exactly because I don't use it 
myself. I think people are going down the wrong rabbit-hole, but it 
wouldn't _irritate_ me that much except for the fact that it now also 
impacts suspend-to-RAM.

			Linus
