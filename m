Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZC3Ofd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZC3Ofd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZC3OfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:35:21 -0400
Received: from THUNK.ORG ([69.25.196.29]:35876 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZC3OfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:35:20 -0400
Date: Mon, 30 Mar 2009 10:33:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
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
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
Message-ID: <20090330143343.GJ13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
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
	david@fromorbit.com, tj@kernel.org
References: <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238422551.30488.47.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:15:51AM -0400, Chris Mason wrote:
> 
> I'm not sure we want to stick Fernando with changing how barriers are
> done in individual filesystems, his patch is just changing the existing
> call points.

Well, his patch actually added some calls to block_issue_flush().  But
yes, it's probably better if he just changes the existing call points,
and we can have the relevant filesystem maintainers double check to
make sure that there aren't any new call points which are needed.

> The ext34 code is especially tricky because there's no way to tell if a
> commit was actually done by sync_inode, so there's no way to know if an
> extra flush is really required.

Yes, good point.  What we need to do is to save inode->i_state
*before* the call to sync_inode(), and issue the flush if the original
value of (inode->i_state & I_DIRTY) == I_DIRTY_PAGES.  But yeah,
that's tricky.

> I think we'll be better off if he keeps the existing logic and a
> different patch set is made for tuning the ext3 and ext4 code.

Agreed.

						- Ted
