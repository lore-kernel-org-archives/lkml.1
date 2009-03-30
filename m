Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZC3OV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZC3OV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZC3OVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:21:49 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:40507 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZC3OVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:21:48 -0400
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
From: Chris Mason <chris.mason@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
In-Reply-To: <20090330140427.GG13356@mit.edu>
References: <20090325212923.GA5620@havoc.gtf.org>
	 <20090326032445.GA16999@havoc.gtf.org>
	 <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org>
	 <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp>
	 <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
	 <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp>
	 <20090330140427.GG13356@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Mar 2009 10:15:51 -0400
Message-Id: <1238422551.30488.47.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49D0D42D.0074:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 10:04 -0400, Theodore Tso wrote:
> On Mon, Mar 30, 2009 at 09:11:58PM +0900, Fernando Luis Vázquez Cao wrote:
> > To ensure that bits are truly on-disk after an fsync or fdatasync, we
> > should force a disk flush explicitly when there is dirty data/metadata
> > and the journal didn't emit a write barrier (either because metadata is
> > not being synched or barriers are disabled).
> 
> NACK.
> 
> As Eric commented on linux-ext4 (and I think it was Chris Mason
> deserves the credit for originally pointing this out), we don't need
> to call blkdev_issue_flush() after calling sync_inode().  That's
> because sync_inode() eventually (after going through a very deep call
> tree inside fs/fs-writeback.c) __sync_single_inode(), which calls
> write_inode(), which calls the filesystem-specific ->write_inode()
> function, which for both ext3 and ext4, ends up calling
> ext[34]_force_commit.  Which, if barriers are enabled, will end up
> issuing a barrier after writing the commit block.
> 
> In the code paths that don't end up calling sync_inode() or
> ext4_force_commit(), (i.e., in the fdatasync() case) calling
> block_flush_device is appropriate.  But as it stands, this patch (and
> the related one for ext4) will result in multiple unnecessary barrier
> requests being sent to the block layer.
> 

I'm not sure we want to stick Fernando with changing how barriers are
done in individual filesystems, his patch is just changing the existing
call points.

The ext34 code is especially tricky because there's no way to tell if a
commit was actually done by sync_inode, so there's no way to know if an
extra flush is really required.

I think we'll be better off if he keeps the existing logic and a
different patch set is made for tuning the ext3 and ext4 code.

-chris


