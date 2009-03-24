Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbZCXOac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbZCXOac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZCXOaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:30:17 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:22021 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757083AbZCXOaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:30:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vrqWlyyNOvKVo8dcakd3ohL5Rhf6SLK2+xUAMitxN0SfYYYSWsVeJTbD1YW7YtNEBEXGN747+1lY2BRFCYFdI4pQUtC1A/kB/FesJhEvJUxQgfTcXu+yMu6SZv1KbH9sfAUF0V4JpAHalptzaQsdKw6waWIIOltqGlggXy9REuE=  ;
X-YMail-OSG: 0WSPC.EVM1kawX1gLqh6Emw.GWY47vThPFqKdwN214cxj_hvbYqAj6YYGxWH1hZqU1eabPt_qVFz8pRE_8IwDsm0RBSD3BavvbEuHBu3t7LLWnnk1j6fDQNb0OZEj7aPq7HwL9F_L_8AMzTxPELrs0WGjxW6P8geo9RMRAdSQUQDBKBQGAPMxA755QxKMQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Wed, 25 Mar 2009 01:30:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz>
In-Reply-To: <20090324132637.GA14607@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903250130.02485.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 00:26:37 Jan Kara wrote:
> On Tue 24-03-09 13:55:10, Jan Kara wrote:
> > On Tue 24-03-09 13:39:36, Jan Kara wrote:
> > >   Hi,
> > >
> > > On Tue 24-03-09 18:44:21, Nick Piggin wrote:
> > > > On Friday 20 March 2009 03:46:39 Jan Kara wrote:
> > > > > On Fri 20-03-09 02:48:21, Nick Piggin wrote:
> > > > > > Holding mapping->private_lock over the __set_page_dirty should
> > > > > > fix it, although I guess you'd want to release it before calling
> > > > > > __mark_inode_dirty so as not to put inode_lock under there. I
> > > > > > have a patch for this if it sounds reasonable.
> > > > >
> > > > >   Yes, that seems to be a bug - the function actually looked
> > > > > suspitious to me yesterday but I somehow convinced myself that it's
> > > > > fine. Probably because fsx-linux is single-threaded.
> > > >
> > > > After a whole lot of chasing my own tail in the VM and buffer layers,
> > > > I think it is a problem in ext2 (and I haven't been able to reproduce
> > > > with ext3 yet, which might lend weight to that, although as we have
> > > > seen, it is very timing dependent).
> > > >
> > > > That would be slightly unfortunate because we still have Jan's ext3
> > > > problem, and also another reported problem of corruption on ext3 (on
> > > > brd driver).
> > > >
> > > > Anyway, when I have reproduced the problem with the test case, the
> > > > "lost" writes are all reported to be holes. Unfortunately, that
> > > > doesn't point straight to the filesystem, because ext2 allocates
> > > > blocks in this case at writeout time, so if dirty bits are getting
> > > > lost, then it would be normal to see holes.
> > > >
> > > > I then put in a whole lot of extra infrastructure to track metadata
> > > > about each struct page (when it was last written out, when it last
> > > > had the number of writable ptes reach 0, when the dirty bits were
> > > > last cleared etc). And none of the normal asertions were triggering:
> > > > eg. when any page is removed from pagecache (except truncates), it
> > > > has always had all its buffers written out *after* all ptes were made
> > > > readonly or unmapped. Lots of other tests and crap like that.
> > >
> > >   I see we're going the same way ;)
> > >
> > > > So I tried what I should have done to start with and did an e2fsck
> > > > after seeing corruption. Yes, it comes up with errors. Now that is
> > > > unusual because that should be largely insulated from the vm: if a
> > > > dirty bit gets lost, then the filesystem image should be quite happy
> > > > and error-free with a hole or unwritten data there.
> > >
> > >   This is different for me. I see no corruption on the filesystem with
> > > ext3. Anyway, errors from fsck would be useful to see what kind of
> > > corruption you saw.
> > >
> > > > I don't know ext? locking very well, except that it looks pretty
> > > > overly complex and crufty.
> > > >
> > > > Usually, blocks are instantiated by write(2), under i_mutex,
> > > > serialising the allocator somewhat. mmap-write blocks are
> > > > instantiated at writeout time, unserialised. I moved truncate_mutex
> > > > to cover the entire get_blocks function, and can no longer trigger
> > > > the problem. Might be a timing issue though -- Ying, can you try this
> > > > and see if you can still reproduce?
> > > >
> > > > I close my eyes and pick something out of a hat. a686cd89. Search for
> > > > XXX. Nice. Whether or not this cased the problem, can someone please
> > > > tell me why it got merged in that state?
> > >
> > >   Maybe, I see it did some changes to ext2_get_blocks() which could be
> > > where the problem was introduced...
> > >
> > > > I'm leaving ext3 running for now. It looks like a nasty task to
> > > > bisect ext2 down to that commit :( and I would be more interested in
> > > > trying to reproduce Jan's ext3 problem, however, because I'm not too
> > > > interested in diving into ext2 locking to work out exactly what is
> > > > racing and how to fix it properly. I suspect it would be most
> > > > productive to wire up some ioctls right into the block
> > > > allocator/lookup and code up a userspace tester for it that could
> > > > probably stress it a lot harder than kernel writeout can.
> > >
> > >   Yes, what I observed with ext3 so far is that data is properly copied
> > > and page marked dirty when the data is copied in. But then at some
> > > point dirty bit is cleared via block_write_full_page() but we don't get
> > > to submitting at least one buffer in that page. I'm now debugging which
> > > path we take so that this happens...
> >
> >   And one more interesting thing I don't yet fully understand - I see
> > pages having PageError() set when they are removed from page cache (and
> > they have been faulted in before). It's probably some interaction with
> > pagecache readahead...
>
>   Argh... So the problem seems to be that get_block() occasionally returns
> ENOSPC and we then discard the dirty data (hmm, we could give at least a
> warning for that). I'm not yet sure why getblock behaves like this because
> the filesystem seems to have enough space but anyway this seems to be some
> strange fs trouble as well.

Ah good find.

I don't think it is a very good idea for block_write_full_page recovery
to do clear_buffer_dirty for !mapped buffers. I think that should rather
be a redirty_page_for_writepage in the case that the buffer is dirty.

Perhaps not the cleanest way to solve the problem if it is just due to
transient shortage of space in ext3, but generic code shouldn't be
allowed to throw away dirty data even if it can't be written back due
to some software or hardware error.

