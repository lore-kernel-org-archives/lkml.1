Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZC3PoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZC3PoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZC3Pn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:43:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZC3Pn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:43:56 -0400
Date: Mon, 30 Mar 2009 08:34:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D0AA4A.6020308@redhat.com>
Message-ID: <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Ric Wheeler wrote:
> 
> People keep forgetting that storage (even on your commodity s-ata class of
> drives) has very large & volatile cache. The disk firmware can hold writes in
> that cache as long as it wants, reorder its writes into anything that makes
> sense and has no explicit ordering promises.

Well, when it comes to disk caches, it really does make sense to start 
looking at what breaks.

For example, it is obviously true that any half-way modern disk has 
megabytes of caches, and write caching is quite often enabled by default. 

BUT!

The write-caches on disk are rather different in many very fundamental 
ways from the kernel write caches.

One of the differences is that no disk I've ever heard of does write- 
caching for long times, unless it has battery back-up. Yes, yes, you can 
probably find firmware that has some odd starvation issue, and if the disk 
is constantly busy and the access patterns are _just_ right the writes can 
take a long time, but realistically we're talking delaying and re-ordering 
things by milliseconds. We're not talking seconds or tens of seconds.

And that's really quite a _big_ difference in itself. It may not be 
qualitatively all that different (re-ordering is re-ordering, delays are 
delays), but IN PRACTICE there's an absolutely huge difference between 
delaying and re-ordering writes over milliseconds and doing so over 30s.

The other (huge) difference is that the on-disk write caching generally 
fails only if the drive power fails. Yes, there's a software component to 
it (buggy firmware), but you can really approximate the whole "disk write 
caches didn't get flushed" with "powerfail".

Kernel data caches? Let's be honest. The kernel can fail for a thousand 
different reasons, including very much _any_ component failing, rather 
than just the power supply. But also obviously including bugs.

So when people bring up on-disk caching, it really is a totally different 
thing from the kernel delaying writes.

So it's entirely reasonable to say "leave the disk doing write caching, 
and don't force flushing", while still saying "the kernel should order the 
writes it does".

Thinking that this is somehow a black-and-white issue where "ordered 
writes" always has to imply "cache flush commands" is simply wrong. It is 
_not_ that black-and-white, and it should probably not even be a 
filesystem decision to make (it's a "system" decision).

This, btw, is doubly true simply because if the disk really fails, it's 
entirely possible that it fails in a really nasty way. As in "not only did 
it not write the sector, but the whole track is now totally unreadable 
because power failed while the write head was active".

Because that notion of "power" is not a digital thing - you have 
capacitors, brown-outs, and generally nasty "oops, for a few milliseconds 
the drive still had power, but it was way out of spec, and odd things 
happened".

So quite frankly, if you start worrying about disk power failures, you 
should also then worry about the disk failing in _way_ more spectacular 
ways than just the simple "wrote or wrote not - that is the question".

And when was the last time you saw a "safe" logging filesystem that was 
safe in the face of the log returning IO errors after power comes back on?

Sure, RAID is one answer. Except not so much in 99% of all desktops or 
especially laptops.

			Linus
