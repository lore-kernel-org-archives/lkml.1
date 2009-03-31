Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbZCaPq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbZCaPq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbZCaPqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:46:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087AbZCaPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:46:17 -0400
Message-ID: <49D239A0.5080405@redhat.com>
Date: Tue, 31 Mar 2009 11:41:20 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
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
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 31 Mar 2009, Ric Wheeler wrote:
>> Now you are just being silly. The drive and the write cache - without barriers
>> or similar tagged operations - will almost certainly reorder all of the IO's
>> internally.
> 
> You do realize that the "drive" may not be a drive at all?
> 
> But apparently you don't. You really seem to see just your own case, and 
> have blinders on for everything else.
> 
> That "drive" may be some virtualized device. It may be some super-fancy 
> memory mapped and largely undocumented random flash thing. It might be a 
> network block device, it may be somebody's IO trace dummy layer, it may be 
> anything at all.

Of course I realize that.

Most of the SSD devices, including ones that don't speak normal S-ATA/SCSI/etc, 
they have a write cache and will combine and re-order IO's.

Some of them have non-volatile write caches and those don't need barriers 
(flush, fua, what ever) because of batteries, capacitors or other magic hardware 
people came up with.

For the ones that do have a volatile write cache and can reorder IO's, 
transactions will still need the ordering primitives to survive a power failure 
reliably.

If you don't need or want to pay the price of ordering, you can today easily 
disable this by mounting without barriers.

As Mark pointed out, most S-ATA/SAS drives will flush the write cache when they 
see a bus reset so even without barriers, the cache will be preserved (or 
flushed) after a reboot or panic.  Power outages are the problem 
barriers/flushes are meant to help with.

> 
> Your filesystem doesn't know. It damn well not even _try_ to know, because 
> it isn't the low-level driver.
> 
> The low-level driver - which you don't have a friggin clue about - may say 
> that it doesn't support barrier IO for any random reason that has 
> absolutely _nothing_ to do with any write caches or anything else. Maybe 
> the device has the same ordering semantics as an Intel CPU has: writes are 
> always seen in order on the disk, and reads are always speculated but will 
> snoop in write buffers, and ther is no way to not do that.
> 
> See? EOPNOTSUPP means just that - it means that the driver doesn't support 
> the notion of ordered IO. But that does not necessarily mean that the 
> writes aren't always in order. It may well just mean that the drive is a 
> thin shimmy layer over something else (for example, just a user level 
> pipe), and the driver has NO IDEA what the end result is, and the protocol 
> is simplistic and is just 'read' and 'write' and absolutely nothing else.
> 
> But you seem to NOT UNDERSTAND THIS.
> 
> I'm not interested in your inane drivel. Let's just say that your lack of 
> understanding just means that your input is irrelevant, and leave it at 
> that. Ok? Until you can see the bigger picture, just don't bother.
> 
> 			Linus


If the low level device returns EOPNOTSUPP on a barrier op, that is fine. 
Running a transactional file system on that storage might or might not be a good 
idea, but at least we can log that and move on.

I agree with Chris that what happens when the device does not support the 
primitives is not the core issue.

The question is really what we do when you have a storage device in your box 
with a volatile write cache that does support flush or fua or similar. Using 
barriers & ordered transactions for these types of devices will give you a more 
reliable file system - less fsck time needed and better data integrity support 
for the (few?) applications that use fsync properly.


Ric

