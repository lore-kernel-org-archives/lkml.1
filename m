Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZC3RI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZC3RI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZC3RIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:08:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbZC3RIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:08:17 -0400
Date: Mon, 30 Mar 2009 09:58:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
cc: Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D0F399.5010407@rtr.ca>
Message-ID: <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca> <49D0E4E8.20508@redhat.com> <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
 <49D0F399.5010407@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Mark Lord wrote:
>
> I spent an entire day recently, trying to see if I could significantly fill
> up the 32MB cache on a 750GB Hitach SATA drive here.
> 
> With deliberate/random write patterns, big and small, near and far,
> I could not fill the drive with anything approaching a full second
> of latent write-cache flush time.
> 
> Not even close.  Which is a pity, because I really wanted to do some testing
> related to a deep write cache.  But it just wouldn't happen.
> 
> I tried this again on a 16MB cache of a Seagate drive, no difference.
> 
> Bummer.  :)

Try it with laptop drives. You might get to a second, or at least hundreds 
of ms (not counting the spinup delay if it went to sleep, obviously). You 
probably tested desktop drives (that 750GB Hitachi one is not a low end 
one, and I assume the Seagate one isn't either).

You'll have a much easier time getting long latencies when seeks take tens 
of ms, and the platter rotates at some pitiful 3600rpm (ok, I guess those 
drives are hard to find these days - I guess 4200rpm is the norm even for 
1.8" laptop harddrives).

And also - this is probably obvious to you, but it might not be 
immediately obvious to everybody - make sure that you do have TCQ going, 
and at full depth. If the drive supports TCQ (and they all do, these days) 
it is quite possible that the drive firmware basically limits the write 
caching to one segment per TCQ entry (or at least to something smallish).

Why? Because that really simplifies some of the problem space for the 
firmware a _lot_ - if you have at least as many segments in your cache as 
your max TCQ depth, it means that you always have one segment free to be 
re-used without any physical IO when a new command comes in.

And if I were a disk firmware engineer, I'd try my damndest to keep my 
problem space simple, so I would do exactly that kind of "limit the number 
of dirty cache segments by the queue size" thing.

But I dunno. You may not want to touch those slow laptop drives with a 
ten-foot pole. It's certainly not my favorite pastime.

			Linus
