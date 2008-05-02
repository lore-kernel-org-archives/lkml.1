Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbYEBNS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbYEBNS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760605AbYEBNSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:18:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44578 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759813AbYEBNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:18:15 -0400
Date: Fri, 2 May 2008 14:17:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_* updates
In-Reply-To: <20080430101704.9cbd6384.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805021305330.13591@blonde.site>
References: <200804210650.m3L6ogJe019566@agora.fsl.cs.sunysb.edu>
 <20080430101704.9cbd6384.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I keep putting off a reply until I can append a patch,
but still won't get to do so today.  Comments below.

On Wed, 30 Apr 2008, Andrew Morton wrote:
> On Mon, 21 Apr 2008 02:50:42 -0400
> Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > 
> > 1. remove the 3rd arg to fsstack_copy_attr_all.  There are no users for it:
> >    ecryptfs never used the 3rd arg; unionfs stopped using it a long time
> >    ago.  Halcrow ok'ed this patch some time ago.
> > 
> > 2. add necessary locking for 32-bit smp systems in fsstack_copy_inode_size
> >    (courtesy Hugh Dickins).
> > 
> > 3. minor commenting style changes, and addition of copyrights which were
> >    missing.
> > 
> > Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
> > Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> >
> > ...
> >
> >  void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> >  {
> > -	i_size_write(dst, i_size_read((struct inode *)src));
> > +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> > +	spin_lock(&dst->i_lock);
> > +#endif
> 
> The defined(CONFIG_SMP) is wrong.  The spinlock is here to protect
> dst->i_blocks, but it can be corrupted via preemption on uniprocessor as
> well.  So a plain old
> 
> #if BITS_PER_LONG == 32
> 
> would fix that.

Some confusion here - which would have been avoided if I'd been
so good as to put much-needed comment in the code of the original
patch - sorry.  There's two separate issues, i_size and i_blocks.

i_size is what I was addressing by adding the #ifdef'ed spin_lock,
i_blocks (in the CONFIG_LSF case more precisely than the 32-bit case)
is an arguable problem that nobody noticed until you did so now.
Here's my original patch comment to Erez:

+ LTP's iogen01 doio tests hang nicely on 32-bit SMP when /tmp is a unionfs
+ mount of a tmpfs.  See the comment on i_size_write in linux/fs.h: it needs
+ to be locked, otherwise i_size_read can spin forever waiting for a lost
+ seqcount update.
+ 
+ Most filesystems are already holding i_mutex for this, but unionfs calls
+ fsstack_copy_inode_size from many places, not necessarily holding i_mutex.
+ Use the low-level i_lock within fsstack_copy_inode_size when 32-bit SMP.

So far as that goes, the CONFIG_SMP is correct, because i_size_write
does preempt_disable/preempt_enable in the 32-bit PREEMPT but not SMP
case.  The ifdef chosen reflects that in i_size_write, but I've no
objection to removing the CONFIG_SMP part of it if it ends up more
palatable that way - I imagine the cost of a double preempt_disable
where a single would do is just too minuscule to worry about.

But the new use of i_lock, together with the way I only unlock after
dealing with i_blocks (I thought, if we have to have preemption off,
let's do i_blocks too while it's still off), led you to think that I
was trying to keep the two halves of a CONFIG_LSF i_blocks together -
whereas I'd never even glanced at the typedef of i_blocks.

Personally I don't think it's worth worrying about i_blocks coherency
here.  stat's generic_fillattr doesn't worry about it.  unionfs (ah,
but here we're in general stackable filesystem territory) won't very
often be handling files where the top half of the u64 is set.  Quotas
have a strong reason for keeping i_blocks coherent, but unionfs (and
any stacking filesystem?) won't get into quotas itself.  And tmpfs
amongst non-quota others does not use i_lock to manipulate i_blocks.

In later mail, it looks like you're wondering whether it's worth
bothering about too: and perhaps you wouldn't have bothered about
it in the first place, if the patch comment provided had made it
clear what this change was for, i_size not i_blocks.

> 
> > +	i_size_write(dst, i_size_read(src));
> >  	dst->i_blocks = src->i_blocks;
> > +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> > +	spin_unlock(&dst->i_lock);
> > +#endif
> >  }
> 
> However, what about src->i_blocks?  It is protected by src->i_lock.  The
> code as you have it here could read transient values.

In some cases it's protected by src->i_lock.

> 
> Furthermore, i_lock is defined as an innermost lock, for protection of
> inode internals.  But here we're proposing "taking" inode->i_size_seqcount
> inside i_lock.  Not necessarily a problem, but it broke the old rule.
> 
> We're also doing a read_seqlock of a _different_ inode inside this inode's
> i_lock.  Again, this is not necessarily a problem (but it might be!) but it
> adds complexity and needs thought.

Good points, I didn't think of those at all (I guess I don't properly
think of the seqcount as a lock).  There's no good reason to do that
i_size_read within the i_lock, you're quite right to take it outside.

> 
> Can we avoid having to think?

Not such a good idea...

> 
> void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> {
> 	blkcnt_t i_blocks;
> 	loff_t i_size;
> 
> 	i_size = i_size_read(src);
> 	spin_lock_32bit(&src->i_lock);
> 	i_blocks = src->i_blocks;
> 	spin_unlock_32bit(&src->i_lock);
> 
> 	i_size_write(dst, i_size);
> 	spin_lock_32bit(&dst->i_lock)
> 	dst->i_blocks = i_blocks;
> 	spin_unlock_32bit(&dst->i_lock)
> }

No.  I see Erez has followed this up, and reduced it to a nice looking
	i_blocks_write(dst, i_blocks_read(src));
 	i_size_write(dst, i_size_read(src));
but I'm afraid that doesn't address the hang my patch was to fix.

My inclination is to go for something like:

 	i_size = i_size_read(src);
 	spin_lock_32bit(&dst->i_lock)
 	i_size_write(dst, i_size);
 	dst->i_blocks = src->i_blocks;
 	spin_unlock_32bit(&dst->i_lock)

with spin_(un)lock_32bit declared as inlines in the very same file,
unless you really want to embark on some i_blocks coherency cleanup.
With comments in the code as well as in the patch description.

Hugh
