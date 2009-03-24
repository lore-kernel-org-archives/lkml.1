Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZCXKor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZCXKor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZCXKog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:44:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbZCXKof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:44:35 -0400
Date: Tue, 24 Mar 2009 03:32:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
       linux-ext4@vger.kernel.org, Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-Id: <20090324033204.64f3da9d.akpm@linux-foundation.org>
In-Reply-To: <200903241844.22851.nickpiggin@yahoo.com.au>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	<200903200248.22623.nickpiggin@yahoo.com.au>
	<20090319164638.GB3899@duck.suse.cz>
	<200903241844.22851.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 18:44:21 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 20 March 2009 03:46:39 Jan Kara wrote:
> > On Fri 20-03-09 02:48:21, Nick Piggin wrote:
> 
> > > Holding mapping->private_lock over the __set_page_dirty should
> > > fix it, although I guess you'd want to release it before calling
> > > __mark_inode_dirty so as not to put inode_lock under there. I
> > > have a patch for this if it sounds reasonable.
> >
> >   Yes, that seems to be a bug - the function actually looked suspitious to
> > me yesterday but I somehow convinced myself that it's fine. Probably
> > because fsx-linux is single-threaded.
> 
> 
> After a whole lot of chasing my own tail in the VM and buffer layers,
> I think it is a problem in ext2 (and I haven't been able to reproduce
> with ext3 yet, which might lend weight to that, although as we have
> seen, it is very timing dependent).
> 
> That would be slightly unfortunate because we still have Jan's ext3
> problem, and also another reported problem of corruption on ext3 (on
> brd driver).
> 
> Anyway, when I have reproduced the problem with the test case, the
> "lost" writes are all reported to be holes. Unfortunately, that doesn't
> point straight to the filesystem, because ext2 allocates blocks in this
> case at writeout time, so if dirty bits are getting lost, then it would
> be normal to see holes.
> 
> I then put in a whole lot of extra infrastructure to track metadata about
> each struct page (when it was last written out, when it last had the number
> of writable ptes reach 0, when the dirty bits were last cleared etc). And
> none of the normal asertions were triggering: eg. when any page is removed
> from pagecache (except truncates), it has always had all its buffers
> written out *after* all ptes were made readonly or unmapped. Lots of other
> tests and crap like that.
> 
> So I tried what I should have done to start with and did an e2fsck after
> seeing corruption. Yes, it comes up with errors.

Do you recall what the errors were?

> Now that is unusual
> because that should be largely insulated from the vm: if a dirty bit gets
> lost, then the filesystem image should be quite happy and error-free with
> a hole or unwritten data there.
> 
> I don't know ext? locking very well, except that it looks pretty overly
> complex and crufty.
> 
> Usually, blocks are instantiated by write(2), under i_mutex, serialising
> the allocator somewhat. mmap-write blocks are instantiated at writeout
> time, unserialised. I moved truncate_mutex to cover the entire get_blocks
> function, and can no longer trigger the problem. Might be a timing issue
> though -- Ying, can you try this and see if you can still reproduce?
> 
> I close my eyes and pick something out of a hat. a686cd89. Search for XXX.
> Nice. Whether or not this cased the problem, can someone please tell me
> why it got merged in that state?
> 
> I'm leaving ext3 running for now. It looks like a nasty task to bisect
> ext2 down to that commit :( and I would be more interested in trying to
> reproduce Jan's ext3 problem, however, because I'm not too interested in
> diving into ext2 locking to work out exactly what is racing and how to
> fix it properly. I suspect it would be most productive to wire up some
> ioctls right into the block allocator/lookup and code up a userspace
> tester for it that could probably stress it a lot harder than kernel
> writeout can.
