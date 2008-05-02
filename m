Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbYEBGMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbYEBGMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYEBGME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:12:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204AbYEBGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:12:01 -0400
Date: Thu, 1 May 2008 23:11:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, mhalcrow@us.ibm.com,
       hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_*
 updates
Message-Id: <20080501231130.c3a2409d.akpm@linux-foundation.org>
In-Reply-To: <200805020558.m425w5xN001504@agora.fsl.cs.sunysb.edu>
References: <20080501170819.bdcb9035.akpm@linux-foundation.org>
	<200805020558.m425w5xN001504@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 01:58:05 -0400 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> In message <20080501170819.bdcb9035.akpm@linux-foundation.org>, Andrew Morton writes:
> > On Thu, 1 May 2008 19:44:18 -0400
> > Erez Zadok <ezk@cs.sunysb.edu> wrote:
> [...]
> > i_size is much more important because glitches in there can result in
> > incorrect data being returned from read() and things like that.  i_blocks
> > is just a beancounting curiosity.
> > 
> > > 
> > > 2. I've rewritten your suggested code a bit to reduce stack use.  Modulo
> > >    having 32-bit spin_lock/unlock variants, do you see any problem with this
> > >    code below?  My testing of it so far on 32/64-bit SMP/UMP have all
> > >    passed.
> > > 
> > > void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
> > > {
> > > #if BITS_PER_LONG == 32
> > > 	blkcnt_t i_blocks;
> > > 
> > > 	spin_lock(&src->i_lock);
> > > 	i_blocks = src->i_blocks;
> > > 	spin_unlock(&src->i_lock);
> > > 	spin_lock(&dst->i_lock);
> > > 	dst->i_blocks = i_blocks;
> > > 	spin_unlock(&dst->i_lock);
> > > #else
> > > 	dst->i_blocks = src->i_blocks;
> > > #endif
> > > 	i_size_write(dst, i_size_read(src));
> > > }
> > 
> > That looks sane, as long as we don't care about i_size-vs-i_blocks
> > coherency.
> 
> > However I expect that approximately zero of the sites which modify i_blocks
> > are taking i_lock to do so.
> 
> If i_blocks is indeed less important than i_size, then we can live with some
> incoherency b/t i_size and i_blocks, for now.  Nevertheless, I propose
> adding this to linux/fs.h:
> 
> static inline blkcnt_t i_blocks_read(const struct inode *inode)
> {
> #if BITS_PER_LONG == 32
> 	blkcnt_t i_blocks;
> 	spin_lock(&src->i_lock);
> 	i_blocks = src->i_blocks;
> 	spin_unlock(&src->i_lock);
> 	return i_blocks;
> #else
> 	return src->i_blocks;
> #endif
> }

We actually only need the spinlocked version if blkcnt_t is 64-bit.

So #if BITS_PER_LONG == 32 && defined(CONFIG_LSF), plus explanatory comment.

The spinlocked version will be too large for inlining, I expect.

> and a matching i_blocks_write function.

You'll also need i_blocks_mod() for things like

fs/hpfs/dnode.c:        i->i_blocks += 4;

>  We can then gradually convert those
> "unsafe" users of i_blocks to use the new i_blocks_read/write helpers.
> 
> The nice thing about these two helpers is fsstack_copy_inode_size becomes a
> lot cleaner and more elegant:
> 
> void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
> {
> 	i_blocks_write(dst, i_blocks_read(src));
> 	i_size_write(dst, i_size_read(src));
> }
> 
> And, if we ever wanted to ensure coherency b/t i_blocks and i_size, we'll
> need to create helpers that merge the functionality of i_size_read/write and
> i_blocks_read/write.
> 
> What do you think?
> 


