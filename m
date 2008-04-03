Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYDCTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYDCTH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbYDCTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:07:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45097 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbYDCTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:07:12 -0400
Date: Thu, 3 Apr 2008 15:07:00 -0400
Message-Id: <200804031907.m33J70fQ025437@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking to copy_inode_size 
In-reply-to: Your message of "Thu, 03 Apr 2008 14:20:01 EDT."
             <20080403182001.GB30189@josefsipek.net> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080403182001.GB30189@josefsipek.net>, "Josef 'Jeff' Sipek" writes:
> On Wed, Apr 02, 2008 at 09:49:11PM -0400, Erez Zadok wrote:
> ...
> > +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> > +	spin_lock(&dst->i_lock);
> > +#endif
> 
> I think you need to check CONFIG_PREEMPT as well.
> 
> Josef 'Jeff' Sipek.

I'm not sure if it's needed in case of CONFIG_PREEMPT.  Anyone?  The code
for i_size_write (below), and the comment at the top of the function,
suggest that the spinlock is needed only to prevent the lots seqcount.

/*
 * NOTE: unlike i_size_read(), i_size_write() does need locking around it
 * (normally i_mutex), otherwise on 32bit/SMP an update of i_size_seqcount
 * can be lost, resulting in subsequent i_size_read() calls spinning forever.
 */
static inline void i_size_write(struct inode *inode, loff_t i_size)
{
#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
	write_seqcount_begin(&inode->i_size_seqcount);
	inode->i_size = i_size;
	write_seqcount_end(&inode->i_size_seqcount);
#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
	preempt_disable();
	inode->i_size = i_size;
	preempt_enable();
#else
	inode->i_size = i_size;
#endif
}


BTW, some time ago I reviewed all callers of i_size_write.  I did so again
just now, and the results were the same:

- a LOT of callers of i_size_write don't take any lock
- some take another spinlock in a different data structure
- those that do take the spinlock, do so unconditionally
- only unionfs and fs/stack.c wrap the spinlock in

	#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)

Erez.
