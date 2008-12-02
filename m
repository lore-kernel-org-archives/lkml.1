Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYLBPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYLBPDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYLBPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:03:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:60079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbYLBPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:03:28 -0500
Subject: Re: MAP_PRIVATE that stays private even on external write
From: Peter Zijlstra <peterz@infradead.org>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       hugh <hugh@veritas.com>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1228228452.24000.118.camel@n2o.xs4all.nl>
References: <493508b5$0$200$e4fe514c@news.xs4all.nl>
	 <1228213651.7133.12.camel@twins> <1228228452.24000.118.camel@n2o.xs4all.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2008 16:02:42 +0100
Message-Id: <1228230162.2312.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 15:34 +0100, Miquel van Smoorenburg wrote:
> On Tue, 2008-12-02 at 11:27 +0100, Peter Zijlstra wrote:
> > On Tue, 2008-12-02 at 10:06 +0000, Miquel van Smoorenburg wrote:
> > > What I am looking for is a MAP_PRIVATE type flag that, when another
> > > process modifies pages of the file (through mmap() or write())
> > > makes sure that my mapping never sees that.
> > > 
> > > There has been talk of a MAP_SNAPSHOT flag before, e.g.
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0407.1/0416.htm
> > > 
> > > Has anyone ever looked at implementing something like this ?
> > 
> > I suppose that needs a snapshot filesystem for backing, and we don't
> > have such a creature (yet). I suppose BTRFS might be able to pull that
> > off.
> 
> That is a different way of looking at it. Interesting.
> 
> It won't help me though, as the "file" I was talking about is in
> fact /dev/sdb .
> 
> But the current MAP_PRIVATE doesn't need a versioning filesystem either.
> It's just that if you write to the mapping, that never gets visible in
> other mappings of the same file, nor in the file itself.
> 
> I'd like to see something like that, but the other way around. If the
> file is modified through a different mapping or write(), modifications
> show up in the file and other shared mappings but not in my private
> mapping. A copy-on-write, but slightly different in what is copied.
> 
> Since MAP_PRIVATE|MAP_POPULATE appears to do this, I thought that
> perhaps there is enough infrastructure to do something similar without
> MAP_POPULATE, but I really don't know enough of mm/* .

Thing is, MAP_PRIVATE isolates others from your changes, not you from
other changes.

A valid implementation could map the original file RO and only COW a
page on the first modification - and this is what I thought linux did.
Which means your MAP_POPULATE would do a writable get_user_pages() on it
(and I think that issue was once raised as a bug).

Now what you want is to basically snapshot a file. There is always space
overhead from doing that, that is, new changes need to go somewhere (or
conversely the old data needs to be kept around).

I guess you could do that by force populating MAP_SNAPSHOT mappings of
the same file on writeout to that file (when no such page already
exists), but before doing the writeout. But that sounds a little icky,
esp. as you force the space overhead (which is the full mmap in the
worst case) into memory.

Relying on filesystems to be able to keep the snapshot around, pushes
that overhead into the filesystem (which is typically much larger than
memory and thus the most suited place for this), which seems like a much
better solution.

Anyway, I think both solution are feasible for implementation, the trick
would be to convince 1) us that its a good idea and will not be yet
another unused 'feature' with significant complexity and 2) someone to
do it.
