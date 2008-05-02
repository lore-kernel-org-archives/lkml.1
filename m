Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbYEBAJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbYEBAJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYEBAJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:09:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992AbYEBAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:09:09 -0400
Date: Thu, 1 May 2008 17:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_*
 updates
Message-Id: <20080501170819.bdcb9035.akpm@linux-foundation.org>
In-Reply-To: <200805012344.m41NiImk013312@agora.fsl.cs.sunysb.edu>
References: <20080501122136.bc2215c9.akpm@linux-foundation.org>
	<200805012344.m41NiImk013312@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 19:44:18 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> In message <20080501122136.bc2215c9.akpm@linux-foundation.org>, Andrew Morton writes:
> > On Thu, 1 May 2008 13:18:09 -0400
> > Erez Zadok <ezk@cs.sunysb.edu> wrote:
> > 
> > > In message <20080430101704.9cbd6384.akpm@linux-foundation.org>, Andrew Morton writes:
> > > [...[
> > > > Can we avoid having to think?
> > > > 
> > > > void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> > > > {
> > > > 	blkcnt_t i_blocks;
> > > > 	loff_t i_size;
> > > > 
> > > > 	i_size = i_size_read(src);
> > > > 	spin_lock_32bit(&src->i_lock);
> > > > 	i_blocks = src->i_blocks;
> > > > 	spin_unlock_32bit(&src->i_lock);
> > > > 
> > > > 	i_size_write(dst, i_size);
> > > > 	spin_lock_32bit(&dst->i_lock)
> > > > 	dst->i_blocks = i_blocks;
> > > > 	spin_unlock_32bit(&dst->i_lock)
> > > > }
> > > 
> > > I can't find spin_[um]lock_32bit anywhere (checkd latest mmotm and linus's
> > > tree).  I therefore assume this was just your way of saying I should:
> > > 
> > > #if BITS_PER_LONG == 32
> > > 	spin_unlock(&dst->i_lock);
> > > #endif
> > 
> > Nope, it was my way of suggesting that you implement it ;)
> > include/linux/spinlock.h would be a good place.
> 
> Sure, I can implement it and submit a patch.  But I've got two questions
> first:
> 
> 1. i_size_read has a tri-state behaviour:
> 
> #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
> 	// play with seqcount
> #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
> 	// wrap in preempt_disable/enable
> #else
> 	// just return value
> #endif
> 
> Shouldn't the same be done for i_blocks, with matching i_blocks_read(),
> i_blocks_write(), and adding an inode->i_blocks_seqcount field?

I guess so, yes.  Maybe there are other things too.  We just haven't cared
enough to do all this fuss for i_blocks.  Even i_size was a bit marginal.

i_size is much more important because glitches in there can result in
incorrect data being returned from read() and things like that.  i_blocks
is just a beancounting curiosity.

> 
> 2. I've rewritten your suggested code a bit to reduce stack use.  Modulo
>    having 32-bit spin_lock/unlock variants, do you see any problem with this
>    code below?  My testing of it so far on 32/64-bit SMP/UMP have all
>    passed.
> 
> void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
> {
> #if BITS_PER_LONG == 32
> 	blkcnt_t i_blocks;
> 
> 	spin_lock(&src->i_lock);
> 	i_blocks = src->i_blocks;
> 	spin_unlock(&src->i_lock);
> 	spin_lock(&dst->i_lock);
> 	dst->i_blocks = i_blocks;
> 	spin_unlock(&dst->i_lock);
> #else
> 	dst->i_blocks = src->i_blocks;
> #endif
> 	i_size_write(dst, i_size_read(src));
> }

That looks sane, as long as we don't care about i_size-vs-i_blocks
coherency.

However I expect that approximately zero of the sites which modify i_blocks
are taking i_lock to do so.

otoh, many of them _will_ accidentally have i_mutex coverage.  On the
write() path at least.  What happened to that idea?
