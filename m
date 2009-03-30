Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZC3OGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZC3OGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZC3OGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:06:02 -0400
Received: from THUNK.ORG ([69.25.196.29]:46877 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZC3OGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:06:00 -0400
Date: Mon, 30 Mar 2009 10:04:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
Message-ID: <20090330140427.GG13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jeff Garzik <jeff@garzik.org>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, David Rees <drees76@gmail.com>,
	Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
References: <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D0B70E.8060506@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 09:11:58PM +0900, Fernando Luis Vázquez Cao wrote:
> To ensure that bits are truly on-disk after an fsync or fdatasync, we
> should force a disk flush explicitly when there is dirty data/metadata
> and the journal didn't emit a write barrier (either because metadata is
> not being synched or barriers are disabled).

NACK.

As Eric commented on linux-ext4 (and I think it was Chris Mason
deserves the credit for originally pointing this out), we don't need
to call blkdev_issue_flush() after calling sync_inode().  That's
because sync_inode() eventually (after going through a very deep call
tree inside fs/fs-writeback.c) __sync_single_inode(), which calls
write_inode(), which calls the filesystem-specific ->write_inode()
function, which for both ext3 and ext4, ends up calling
ext[34]_force_commit.  Which, if barriers are enabled, will end up
issuing a barrier after writing the commit block.

In the code paths that don't end up calling sync_inode() or
ext4_force_commit(), (i.e., in the fdatasync() case) calling
block_flush_device is appropriate.  But as it stands, this patch (and
the related one for ext4) will result in multiple unnecessary barrier
requests being sent to the block layer.

So two out of the three places where this patch adds
block_flush_device() are not necessary; as far as I can tell, only
this one is one we should add.

> -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> -		goto out;
> +	if (datasync && !(i_state & I_DIRTY_DATASYNC)) {
> +		if (i_state & I_DIRTY_PAGES)
> +			ret = block_flush_device(inode->i_sb->s_bdev);
> +		return ret;
> +	}

A similar fixup is needed for the ext4 patch.

(And can we please start a new thread for these patches?  Thanks!!)

Regards,

     	    	   	       	      	  	- Ted

