Return-Path: <linux-kernel-owner+w=401wt.eu-S1766015AbYD3V0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766015AbYD3V0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYD3V0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:26:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbYD3V0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:26:23 -0400
Date: Wed, 30 Apr 2008 14:25:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_*
 updates
Message-Id: <20080430142543.ca3d5317.akpm@linux-foundation.org>
In-Reply-To: <200804302109.m3UL9FBj031457@agora.fsl.cs.sunysb.edu>
References: <20080430101704.9cbd6384.akpm@linux-foundation.org>
	<200804302109.m3UL9FBj031457@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 17:09:15 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> In message <20080430101704.9cbd6384.akpm@linux-foundation.org>, Andrew Morton writes:
> > On Mon, 21 Apr 2008 02:50:42 -0400
> > Erez Zadok <ezk@cs.sunysb.edu> wrote:
> [...]
> > Can we avoid having to think?
> > 
> > void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> > {
> > 	blkcnt_t i_blocks;
> > 	loff_t i_size;
> > 
> > 	i_size = i_size_read(src);
> > 	spin_lock_32bit(&src->i_lock);
> > 	i_blocks = src->i_blocks;
> > 	spin_unlock_32bit(&src->i_lock);
> > 
> > 	i_size_write(dst, i_size);
> > 	spin_lock_32bit(&dst->i_lock)
> > 	dst->i_blocks = i_blocks;
> > 	spin_unlock_32bit(&dst->i_lock)
> > }
> 
> Thanks.  I can't say that I'm an expert in these SMP issues.  But I'll run
> your rewritten function through my 32 and 64-bit SMP and non-SMP systems,
> and see how it behaves.
> 

The obvious risk here is that there's no synchronisation between the
copying of i_size and i_blocks.  If that's a problem, I _expect_ that
i_mutex wold give pretty good coverage (but insufficient for
mmap-write-over-a-hole, I guess).

And someone needs to write spin_lock_32bit() ;)
