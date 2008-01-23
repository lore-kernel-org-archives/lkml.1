Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYAWPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYAWPFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYAWPFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:05:30 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:42305 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751536AbYAWPF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:05:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Oa/qH7/hu+OwocYlgXln1/raDVXgsHSWi6A+PQdsFpgHv0ngCewhzr4XSUUlu1dBq2PcmCY17L99VKVq1+GcgQPnyv6jSHxOzR0l7IUDjXMjTAQExWVwc/pb5u5fCjG+GiIWA3KiALmESz6cphK7H2BKN7JpOA4apOh6LKMCsoE=  ;
X-YMail-OSG: gqZ1hVEVM1mUJ4VhY5I6nDsG4VrJSPbfLeNMPWnjA3jHVUu5CKaXgsWCe7XVEsNqoxwNIcUOFg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Date: Thu, 24 Jan 2008 02:05:16 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20080122171025.GB4485@duck.suse.cz> <200801231200.03016.nickpiggin@yahoo.com.au> <20080123133045.GC10144@duck.suse.cz>
In-Reply-To: <20080123133045.GC10144@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801240205.17005.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 00:30, Jan Kara wrote:
> On Wed 23-01-08 12:00:02, Nick Piggin wrote:
> > On Wednesday 23 January 2008 04:10, Jan Kara wrote:
> > >   Hi,
> > >
> > >   as I got no answer for a week, I'm resending this fix for races in
> > > private_list handling. Andrew, do you like them more than the previous
> > > version?
> >
> > FWIW, I reviewed this, and it looks OK although I think some comments
> > would be in order.
>
>   Thanks.
>
> > What would be really nice is to avoid the use of b_assoc_buffers
> > completely in this function like I've attempted (untested). I don't
> > know if you'd actually call that an improvement...?
>
>   I thought about this solution as well. But main issue I had with this
> solution is that currently, you nicely submit all the metadata buffers at
> once, so that block layer can sort them and write them in nice order. With
> the array you submit buffers by 16 (or any other fixed amount) and in
> mostly random order... So IMHO fsync would become measurably slower.

Oh, I don't know the filesystems very well... which ones would
attach a large number of metadata buffers to the inode?


> > Couple of things I noticed while looking at this code.
> >
> > - What is osync_buffers_list supposed to do? I couldn't actually
> >   work it out. Why do we care about waiting for these buffers on
> >   here that were added while waiting for writeout of other buffers
> >   to finish? Can we just remove it completely? I must be missing
> >   something.
>
>   The problem here is that mark_buffer_dirty_inode() can move the buffer
> from 'tmp' list back to private_list while we are waiting for another
> buffer...

Hmm, no not while we're waiting for another buffer because b_assoc_buffers
will not be empty. However it is possible between removing from the inode
list and insertion onto the temp list I think, because

  if (list_empty(&bh->b_assoc_buffers)) {

check in mark_buffer_dirty_inode is done without private_lock held. Nice.

With that in mind, doesn't your first patch suffer from a race due to
exactly this unlocked list_empty check when you are removing clean buffers
from the queue?

                             if (!buffer_dirty(bh) && !buffer_locked(bh))
mark_buffer_dirty()
if (list_empty(&bh->b_assoc_buffers))
     /* add */
                                 __remove_assoc_queue(bh);

Which results in the buffer being dirty but not on the ->private_list,
doesn't it?

But let's see... there must be a memory ordering problem here in existing
code anyway, because I don't see any barriers. Between b_assoc_buffers and
b_state (via buffer_dirty); fsync_buffers_list vs mark_buffer_dirty_inode,
right?


> > - What are the get_bh(bh) things supposed to do? Protect the lifetime
> >   of a given bh while "lock" is dropped? That's nice, ignoring the
> >   fact that we brelse(bh) *before* taking the lock again... but isn't
> >   every single other buffer that we _have't_ elevated its reference
> >   exposed to exactly the same lifetime problem? IOW, either it is not
> >   required at all, or it is required for _all_ buffers? (my patch
> >   should fix this).
>
>   I think this get_bh() should stop try_to_free_buffers() from removing the
> buffer. brelse() before taking the private_lock is fine, because the loop
> actually checks for while (!list_empty(tmp)) so we really don't care what
> happens with the buffer after we are done with it. So I think that logic is
> actually fine.

Oh, of course. I overlooked the important fact that the tmp list is
also actually subject to modification via other threads exactly the
same as private_list...
