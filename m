Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbYAYIrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbYAYIrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763077AbYAYIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:34:26 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30752 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758307AbYAYIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:34:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JbA48iZDRDMJLnIvEKCbLdQeR9VcLJEc9U9yuNWErpQ0EsoNld7kdJIcweqrF0SrabtOWhqScowLLlRdo85acZKgWnOqGi64/56qJFhxbzLSn5iK99Aqayx7pULynsL/YqqygXYxm2yQzIRJiT1oCcrv0DBUf0msaEBMm1Bbsss=  ;
X-YMail-OSG: HSNvi6oVM1lW8Epo3jRpiraexkz9Ij7wXXP.S2kowHEBxyuWpwy2e2LelvRVCd_KuZmpf9wBuQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Date: Fri, 25 Jan 2008 19:34:07 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20080122171025.GB4485@duck.suse.cz> <200801240205.17005.nickpiggin@yahoo.com.au> <20080123154818.GD10144@duck.suse.cz>
In-Reply-To: <20080123154818.GD10144@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251934.08160.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 02:48, Jan Kara wrote:
> On Thu 24-01-08 02:05:16, Nick Piggin wrote:
> > On Thursday 24 January 2008 00:30, Jan Kara wrote:
> > > On Wed 23-01-08 12:00:02, Nick Piggin wrote:
> > > > On Wednesday 23 January 2008 04:10, Jan Kara wrote:
> > > > >   Hi,
> > > > >
> > > > >   as I got no answer for a week, I'm resending this fix for races
> > > > > in private_list handling. Andrew, do you like them more than the
> > > > > previous version?
> > > >
> > > > FWIW, I reviewed this, and it looks OK although I think some comments
> > > > would be in order.
> > >
> > >   Thanks.
> > >
> > > > What would be really nice is to avoid the use of b_assoc_buffers
> > > > completely in this function like I've attempted (untested). I don't
> > > > know if you'd actually call that an improvement...?
> > >
> > >   I thought about this solution as well. But main issue I had with this
> > > solution is that currently, you nicely submit all the metadata buffers
> > > at once, so that block layer can sort them and write them in nice
> > > order. With the array you submit buffers by 16 (or any other fixed
> > > amount) and in mostly random order... So IMHO fsync would become
> > > measurably slower.
> >
> > Oh, I don't know the filesystems very well... which ones would
> > attach a large number of metadata buffers to the inode?
>
>   This logic is actually used only by a few filesystems - ext2 and UDF are
> probably the most common ones. For example for ext2, the indirect blocks
> are on the list if the file is freshly written, so that is roughly around
> 1MB of metadata per 1GB of data (for 4KB blocks, with 1KB blocks it is 4MB
> per 1GB). Because seeks are expensive, you could really end up with the
> write being 16 times slower when you do it in 16 passes instead of one...

Yeah, that's fair enough I suppose. I wasn't thinking you'd have a
huge newly dirtied file, but it could happen. I don't want to cause
regressions.


> > With that in mind, doesn't your first patch suffer from a race due to
> > exactly this unlocked list_empty check when you are removing clean
> > buffers from the queue?
> >
> >                              if (!buffer_dirty(bh) && !buffer_locked(bh))
> > mark_buffer_dirty()
> > if (list_empty(&bh->b_assoc_buffers))
> >      /* add */
> >                                  __remove_assoc_queue(bh);
> >
> > Which results in the buffer being dirty but not on the ->private_list,
> > doesn't it?
>
>   Hmm, I'm not sure about which patch you speak. Logic with removing clean
> buffers has been in the first version (but there mark_buffer_dirty_inode()
> was written differently).

Ah, yes I see I missed that. I like that a lot better.


> In the current version, we readd buffer to 
> private_list if it is found dirty in the second while loop of
> fsync_buffers() and that should be enough.

Sure, I think there is still a data race though, but if there is one
it's already been there for a long time and nobody cares too much about
those anyway.


> > But let's see... there must be a memory ordering problem here in existing
> > code anyway, because I don't see any barriers. Between b_assoc_buffers
> > and b_state (via buffer_dirty); fsync_buffers_list vs
> > mark_buffer_dirty_inode, right?
>
>   I'm not sure. What exactly to you mean? BTW: spin_lock is a memory
> barrier, isn't it?

In existing code:

mark_buffer_dirty_inode():              fsync_buffers_list():
 test_set_buffer_dirty(bh);              list_del_init(&bh->b_assoc_buffers);
 if (list_empty(&bh->b_assoc_buffers))   if (buffer_dirty(bh)) {
     ...                                   list_add(&bh->b_assoc_buffers, );

These two code sequences can run concurrently because only fsync_buffers_list
takes the lock.

So fsync_buffers_list can speculatively load bh->b_state before
its stores to clear b_assoc_buffers propagate to the CPU running
mark_buffer_dirty_inode.

So if there is a !dirty buffer on the list, then fsync_buffers_list will
remove it from the list, but mark_buffer_dirty_inode won't see it has been
removed from the list and won't re-add it. I think.

This is actually even possible to hit on x86 because they reorder loads
past stores. It needs a smp_mb() before if (buffer_dirty(bh) {}.

Actually I very much dislike testing list entries locklessly, because they
are not trivially atomic operations like single stores... which is another
reason why I like your first patch.
