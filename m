Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZCZLhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZCZLhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZCZLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZCZLhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:37:41 -0400
Date: Thu, 26 Mar 2009 12:37:34 +0100
From: Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090326113733.GA23044@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz> <200903250130.02485.nickpiggin@yahoo.com.au> <20090324144709.GF23439@duck.suse.cz> <1237906563.24918.184.camel@twins> <20090324152959.GG23439@duck.suse.cz> <20090326084723.GB8207@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326084723.GB8207@skywalker>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 26-03-09 14:17:23, Aneesh Kumar K.V wrote:
> On Tue, Mar 24, 2009 at 04:29:59PM +0100, Jan Kara wrote:
> > On Tue 24-03-09 15:56:03, Peter Zijlstra wrote:
> > > On Tue, 2009-03-24 at 15:47 +0100, Jan Kara wrote:
> > > > 
> > > > Or we could implement ext3_mkwrite() to allocate buffers already when we
> > > > make page writeable. But it costs some performace (we have to write page
> > > > full of zeros when allocating those buffers, where previously we didn't
> > > > have to do anything) and it's not trivial to make it work if pagesize >
> > > > blocksize (we should not allocate buffers outside of i_size so if i_size
> > > > = 1024, we create just one block in ext3_mkwrite() but then we need to
> > > > allocate more when we extend the file).
> > > 
> > > I think this is the best option, failing with SIGBUS when we fail to
> > > allocate blocks seems consistent with other filesystems as well.
> >   I agree this looks attractive at the first sight. But there are drawbacks
> > as I wrote - the problem with blocksize < pagesize, slight performance
> > decrease due to additional write,
> 
> It should not cause an additional write. Can you let me why it would
> result in additional write ?
  Because if you have a new page, at the time mkwrite() or set_page_dirty()
is called, it is just full of zeros. So we attach buffers full of zeros to
the running transaction to stand to data=ordered mode requirements. Then
these get written out on transaction commit (or they can already contain some
data user has written via mmap) but we're going to write them again when
writepage() is called on the page.
  Umm, but yes, thinking more about the details, we clear buffer dirty bits
at commit time so if by that time user has copied in all the data,
subsequent writepage will find out all the buffers are clean and will not
send them to disk. So in this case overhead is going to be just
journal_start() + journal_stop(). OTOH mm usually decides to write the page
only after some time so if user writes to the page often then we really do
one more write. But in this case one additional write is going to be
probably lost in the number of total writes of the page. So yes, this is
not such a big issue as I though originally.

> >page faults doing allocation can take a
> > *long* time 
> 
> That is true
> 
> >and overall fragmentation is going to be higher (previously
> > writepage wrote pages for us in the right order, now we are going to
> > allocate in the first-accessed order). So I'm not sure we really want to
> > go this way.
> 
> 
> block allocator should be improved to fix that. For example ext4
> mballoc also look at the logical file block number when doing block
> allocation. So if we does enough reservation it should handle the 
> the first-accessed order and sequential order allocation properly.
  Well, we could definitely improve ext3 allocator. But do we really want
to backport mballoc to ext3? IMO It is easier to essentialy perform delayed
allocation at the time of mkwrite() and the do the real allocation at the
time of writepage(). So I'd rather vote for a mechanism I write about
below.

> Another reason why I think we would need ext3_page_mkwrite is, if we
> really are out of space how do we handle it ? Currently the patch you
> posted does redirty_page_for_writepage, which would imply we can't
> reclaim the page and since get_block get ENOSPC we can't allocate
> blocks.
  I definitely agree we should somehow solve this problem but the mechanism
below seems to be an easier way to me.

> >   Hmm, maybe we could play a trick ala delayed allocation - i.e., reserve
> > some space in mkwrite() but don't actually allocate it. That would be done
> > in writepage(). This would solve all the problems I describe above. We could
> > use PG_Checked flag to track that the page has a reservation and behave
> > accordingly in writepage() / invalidatepage(). ext3 in data=journal mode
> > already uses the flag but the use seems to be compatible with what I want
> > to do now... So it may actually work.
> >   BTW: Note that there's a plenty of filesystems that don't implement
> > mkwrite() (e.g. ext2, UDF, VFAT...) and thus have the same problem with
> > ENOSPC. So I'd not speak too much about consistency ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
