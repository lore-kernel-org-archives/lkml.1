Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYEBGCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYEBGCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYEBGCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:02:01 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41444 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYEBGCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:02:00 -0400
Date: Fri, 2 May 2008 01:58:05 -0400
Message-Id: <200805020558.m425w5xN001504@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_* updates 
In-reply-to: Your message of "Thu, 01 May 2008 17:08:19 PDT."
             <20080501170819.bdcb9035.akpm@linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080501170819.bdcb9035.akpm@linux-foundation.org>, Andrew Morton writes:
> On Thu, 1 May 2008 19:44:18 -0400
> Erez Zadok <ezk@cs.sunysb.edu> wrote:
[...]
> i_size is much more important because glitches in there can result in
> incorrect data being returned from read() and things like that.  i_blocks
> is just a beancounting curiosity.
> 
> > 
> > 2. I've rewritten your suggested code a bit to reduce stack use.  Modulo
> >    having 32-bit spin_lock/unlock variants, do you see any problem with this
> >    code below?  My testing of it so far on 32/64-bit SMP/UMP have all
> >    passed.
> > 
> > void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
> > {
> > #if BITS_PER_LONG == 32
> > 	blkcnt_t i_blocks;
> > 
> > 	spin_lock(&src->i_lock);
> > 	i_blocks = src->i_blocks;
> > 	spin_unlock(&src->i_lock);
> > 	spin_lock(&dst->i_lock);
> > 	dst->i_blocks = i_blocks;
> > 	spin_unlock(&dst->i_lock);
> > #else
> > 	dst->i_blocks = src->i_blocks;
> > #endif
> > 	i_size_write(dst, i_size_read(src));
> > }
> 
> That looks sane, as long as we don't care about i_size-vs-i_blocks
> coherency.

> However I expect that approximately zero of the sites which modify i_blocks
> are taking i_lock to do so.

If i_blocks is indeed less important than i_size, then we can live with some
incoherency b/t i_size and i_blocks, for now.  Nevertheless, I propose
adding this to linux/fs.h:

static inline blkcnt_t i_blocks_read(const struct inode *inode)
{
#if BITS_PER_LONG == 32
	blkcnt_t i_blocks;
	spin_lock(&src->i_lock);
	i_blocks = src->i_blocks;
	spin_unlock(&src->i_lock);
	return i_blocks;
#else
	return src->i_blocks;
#endif
}

and a matching i_blocks_write function.  We can then gradually convert those
"unsafe" users of i_blocks to use the new i_blocks_read/write helpers.

The nice thing about these two helpers is fsstack_copy_inode_size becomes a
lot cleaner and more elegant:

void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
{
	i_blocks_write(dst, i_blocks_read(src));
	i_size_write(dst, i_size_read(src));
}

And, if we ever wanted to ensure coherency b/t i_blocks and i_size, we'll
need to create helpers that merge the functionality of i_size_read/write and
i_blocks_read/write.

What do you think?

Erez.
