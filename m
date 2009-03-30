Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbZC3THR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbZC3THR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbZC3TG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:06:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39283 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990AbZC3TG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:06:58 -0400
Message-ID: <49D11806.80408@garzik.org>
Date: Mon, 30 Mar 2009 15:05:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: range-based cache flushing (was Re: Linux 2.6.29)
References: <20090324093245.GA22483@elte.hu>	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>	 <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>	 <20090324184549.GE32307@mit.edu>	 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>	 <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>	 <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>	 <49CA8ADA.3040709@redhat.com> <49CA9114.3040205@garzik.org>	 <49CA9324.6010407@redhat.com> <1238016170.3281.36.camel@localhost.localdomain>
In-Reply-To: <1238016170.3281.36.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-03-25 at 16:25 -0400, Ric Wheeler wrote:
>> Jeff Garzik wrote:
>>> Ric Wheeler wrote:> And, as I am sure that you do know, to add insult 
>>> to injury, FLUSH_CACHE
>>>> is per device (not file system).

>>>> When you issue an fsync() on a disk with multiple partitions, you 
>>>> will flush the data for all of its partitions from the write cache....
>>> SCSI'S SYNCHRONIZE CACHE command already accepts an (LBA, length) 
>>> pair.  We could make use of that.

>>> And I bet we could convince T13 to add FLUSH CACHE RANGE, if we could 
>>> demonstrate clear benefit.

>> How well supported is this in SCSI?  Can we try it out with a commodity 
>> SAS drive?

> What do you mean by well supported?  The way the SCSI standard is
> written, a device can do a complete cache flush when a range flush is
> requested and still be fully standards compliant.  There's no easy way
> to tell if it does a complete cache flush every time other than by
> taking the firmware apart (or asking the manufacturer).

Quite true, though wondering aloud...

How difficult would it be to pass the "lower-bound" LBA to SYNCHRONIZE 
CACHE, where "lower bound" is defined as the lowest sector in the range 
of sectors to be flushed?

That seems like a reasonable optimization -- it gives the drive an easy 
way to skip sync'ing sectors lower than the lower-bound LBA, if it is 
capable.  Otherwise, a standards-compliant firmware will behave as you 
describe, and do what our code currently expects today -- a full cache 
flush.

This seems like a good way to speed up cache flush [on SCSI], while also 
perhaps experimenting with a more fine-grained way to pass down write 
barriers to the device.

Not a high priority thing overall, but OTOH, consider the case of 
placing your journal at the end of the disk.  You could then issue a 
cache flush with a non-zero starting offset:

	SYNCHRONIZE CACHE (max sectors - JOURNAL_SIZE, ~0)

That should be trivial even for dumb disk firmwares to optimize.

	Jeff



