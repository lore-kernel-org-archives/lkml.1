Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZCaDBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZCaDBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZCaDBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:01:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847AbZCaDBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:01:24 -0400
Date: Mon, 30 Mar 2009 19:47:04 -0700 (PDT)
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
In-Reply-To: <49D17CA2.5060105@redhat.com>
Message-ID: <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
 <49D17CA2.5060105@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Ric Wheeler wrote:
> 
> One thing the caller could do is to disable the write cache on the device.

First off, that's not the callers job. If the sysadmin enabled it, some 
random filesystem shouldn't disable it.

Secondly, this whole insane belief that "write cache" has anything to do 
with "unable to flush" is just bogus. 

> A second would be to stop using the transactions - skip the journal, 
> just go back to ext2 mode or BSD like soft updates.

f*ck me, what's so hard with understanding that EOPNOTSUPP doesn't mean 
"no ordering". It means what it says - the op isn't supported. For all you 
know, ALL WRITES MAY BE TOTALLY ORDERED, but perhaps there is no way to 
make a _single_ write totally atomic (ie the "set barrier on a command 
that actually does IO").

Besides, why the hell do you think the filesystem (again) should do 
something that the admin didn't ask it to do.

If the admin wants the thing to fall back to ext2, then he can ask to 
disable the journal.

> Basically, it lets the file system know that its data integrity building
> blocks are not really there and allows it (if it cares) to try and minimize
> the chance of data loss.

Your whole idiotic "as a filesystem designer I know better than everybody 
else" model where the filesystem is in total control is total crap.

The fact is, it's not the filesystems job to make that decision. If the 
admin wants to have write caching enabled, the filesystem should get the 
hell out of the way.

What about laptop mode? Do you expect your filesystem to always decide 
that "ok, the user wanted to spin down disks, but I know better"?

What about people who have UPS's and don't worry about that part? They 
want write caching on the disk, and simply don't want to sync? They still 
worry about OS crashing, since they run random -git development kernels?

In short, stop this IDIOTIC notion that you know better. YOU DO NOT KNOW 
BETTER. The filesystem DOES NOT KNOW BETTER. It should damn well not do 
those kinds of decisions that are simply not filesystem decisions to make!

			Linus
