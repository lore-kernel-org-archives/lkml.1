Return-Path: <linux-kernel-owner+w=401wt.eu-S1762657AbZCaQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762657AbZCaQ2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZCaQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:28:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbZCaQ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:28:43 -0400
Date: Tue, 31 Mar 2009 09:15:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <49D239A0.5080405@redhat.com>
Message-ID: <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
 <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Ric Wheeler wrote:
> 
> The question is really what we do when you have a storage device in your box
> with a volatile write cache that does support flush or fua or similar.

Ok. Then you are talking about a different case - not EOPNOTSUPP.

[ Although it may be related in that maybe the admin can _force_ a 
  EOPNOTSUPP thing for when he wants to disable any "write barrier implies 
  flush" thing.

  IOW, we may end up with an _implementation_ detail where we overload a 
  potential QUEUE_FLUSH_EOPNOTSUPP flag with two meanings - either "the 
  driver told me a barrier isn't supported" or "the admin set that same 
  flag by hand to disable barrier-related flush commands".

  But that's just an implementation detail, of course. We could use two 
  different flags, we could do the flags at different levels, whatever. ]

> Using barriers & ordered transactions for these types of devices will 
> give you a more reliable file system - less fsck time needed and better 
> data integrity support for the (few?) applications that use fsync 
> properly.

Sure. And it still shouldn't be the filesystem that _requires_ use of it.

The user (or low-level driver) may simply know better. The user may 
know that he trusts the disk more than anything else, and prefers to 
not actually emit the "FLUSH" command. Again, that's not something that 
the filesystem should know about, or care about. If the user trusts the 
disk subsystem and wants the performance, it's the users choice.

Even the _driver_ may know better.

Knowing the kinds of firmware bugs those drives have, it could even be a 
driver that simply black-lists certain disks as having known-broken FLUSH 
commands. We have _CPU's_ that corrupt memory on cache writeback 
("wbinvl"), and those things are a lot more tested than most driver 
firmware is.

Do you realize just how buggy some of those flash drives are? Some of them 
will literally (a) report the wrong size and (b) lock up if you try to 
read from the last sector. Oops. Do you really expect such crap to 
even bother to honor some flush command? Good luck with that. They're 
designed as a floppy replacement.

Now, you can tell me that I shouldn't put a reliable filesystem on an 
el-cheapo flash drive and expect it to work, but I'm sorry, you're wrong. 
People _are_ supposed to be able to move their data around, and the 
filesystem shouldn't make judgement calls. If you want judgement calls, 
call your mom. Not your filesystem.

For another example, the driver might be a driver for a high-end 
battery-backup SCSI RAID controller. It knows that the controller _will_ 
write things out in the right order even in the case of a crash, but it 
may also know that the controller _also_ has a way to force a flush to 
actual hardware.

When do you want to force a flush? For hotplug events, for example. Maybe 
the disks won't be _connected_ any more afterwards - then the battery 
backup on the controller won't be helping, will it? So there may well be a 
flush event thing, but it's really up to the admin to decide whether it 
should be connected to a write barrier thing, or be a separate admin 
activity.

Maybe the admin is extra careful and anal, and decides that he wants to 
flush to disk platters _despite_ the battery backup. Maybe he doesn't 
trust the card. Maybe he does.  Whatever. The point is that the admin 
might want to set a driver flag that does the flush or not, adn it's 
totally not a filesystem issue.

See? The filesystem has absolutely _no_place_ deciding these kinds of 
things. The only thing it can ask for is "please serialize", but what 
_level_ of serialization is simply not a filesystem decision to make.

And that very much includes the level of serialization that says "no 
serialization what-so-ever, and please go absolutely crazy with your 
cache". Not your choice.

So no, you can't have a pony.

			Linus
