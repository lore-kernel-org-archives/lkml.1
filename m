Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbZEAOBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbZEAOBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZEAOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:01:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:17125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZEAOBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ewMdCSczHlgvKVcscy5Jz+wsGeuPAubh53YKxqUgkho1RkuTxk7Kv8pAM3p/swhCfd
         P1ItJ/iwvaklhpu7ajw31XfQhl/HEZVxBR245H0anBA0OOPAcYJsD9Rra/n8f3rBcY4T
         Up44QWPvyNSbCf8Lz94e84IhRVhGdqyoZ3aM0=
Date: Fri, 1 May 2009 16:01:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/6] kill-the-BKL/reiserfs: release write lock on
	fs_changed()
Message-ID: <20090501140136.GI6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-2-git-send-email-fweisbec@gmail.com> <878wlhpc5r.fsf@basil.nowhere.org> <20090501132825.GE6011@nowhere> <1241185456.13084.28.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241185456.13084.28.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:44:16AM -0400, Chris Mason wrote:
> On Fri, 2009-05-01 at 15:28 +0200, Frederic Weisbecker wrote:
> > On Fri, May 01, 2009 at 08:31:12AM +0200, Andi Kleen wrote:
> > > Frederic Weisbecker <fweisbec@gmail.com> writes:
> > > >
> > > > diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
> > > > index 6587b4e..397d281 100644
> > > > --- a/include/linux/reiserfs_fs.h
> > > > +++ b/include/linux/reiserfs_fs.h
> > > > @@ -1302,7 +1302,13 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
> > > >  #define get_generation(s) atomic_read (&fs_generation(s))
> > > >  #define FILESYSTEM_CHANGED_TB(tb)  (get_generation((tb)->tb_sb) != (tb)->fs_gen)
> > > >  #define __fs_changed(gen,s) (gen != get_generation (s))
> > > > -#define fs_changed(gen,s) ({cond_resched(); __fs_changed(gen, s);})
> > > > +#define fs_changed(gen,s)		\
> > > > +({					\
> > > > +	reiserfs_write_unlock(s);	\
> > > > +	cond_resched();			\
> > > > +	reiserfs_write_lock(s);		\
> > > 
> > > Did you try writing that 
> > > 
> > >     if (need_resched()) {               \
> > > 	reiserfs_write_unlock(s);	\
> > > 	cond_resched();			\  (or schedule(), but cond_resched does a loop)
> > > 	reiserfs_write_lock(s);		\
> > >     }				
> > > 
> > > ? That might give better performance under load because users will be better
> > > batched and you don't release the lock unnecessarily in the unloaded case.
> > 
> > 
> > 
> > Good catch!
> > And I guess this pattern matches most of the cond_resched()
> > all over the code (the only condition is that we must already hold
> > the write lock).
> > 
> > I will merge your idea and Ingo's one, write a
> > reiserfs_cond_resched() to have a helper which
> > factorizes this pattern.
> 
> The pattern you'll find goes like this:
> 
> lock_kernel()
> do some work
> do something that might schedule
> run fs_changed(), fixup as required.
> 
> In your setup it is translating to:
> 
> reiserfs_write_lock(s)
> do some work
> reiserfs_write_unlock(s)
> 
> do something that might schedule
> 
> reiserfs_write_lock(s)
> if (need_resched()) {
>     reiserfs_write_unlock(s)
>     cond_resched()
>     reiserfs_write_lock(s)
> }
> 
> if (__fs_changed()) fixup as required
> 
> You'll also find that item_moved is similar to __fs_changed() but more
> fine grained.
> 
> One easy optimization is to make an fs_changed_relock()
> 
> static inline int fs_changed_relock(gen, s) {
> 	cond_resched();
> 	reiserfs_write_lock(s)
> 	return __fs_changed(gen, s)
> }



Nice idea!
Does it means I can also replace the item_moved() calls to __fs_changed()?

They seem to not work the same way, I guess I should provide two different
helpers, depending on the check.


> 
> Another cause of scheduling is going to be reiserfs_prepare_for_journal.
> This function gets called before we modify a metadata buffer and it
> waits for IO to finish.
> 
> Not sure if your patch series already found it, but if you change this:
> 
> int reiserfs_prepare_for_journal(struct super_block *sb,
>                                  struct buffer_head *bh, int wait)
> {
>         PROC_INFO_INC(sb, journal.prepare);
> 
>         if (!trylock_buffer(bh)) {
>                 if (!wait)
>                         return 0;
>                 lock_buffer(bh);
>         }
> 
> Into:
> 
> 	if (!trylock_buffer(bh)) {
> 		if (!wait)
> 			return 0;
> 		reiserfs_write_unlock(s);
> 		wait_on_buffer(bh);
> 		reiserfs_write_lock(s);
> 		lock_buffer(bh);
> 	}
> 
> You'll catch a big cause of waiting for the disk with the lock held.


Again, good catch. I will try that.

I should also check the different other lock_buffer() which
indeed might sleep.

Thanks!


> -chris
> 
> 

