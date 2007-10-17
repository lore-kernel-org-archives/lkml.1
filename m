Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbXJQStP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbXJQStP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXJQSs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:48:59 -0400
Received: from pat.uio.no ([129.240.10.15]:54112 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbXJQSs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:48:57 -0400
Subject: Re: [PATCH] nfs: fix nfs_writepage()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1192642584.27435.157.camel@twins>
References: <1192628458.27435.119.camel@twins>
	 <1192634702.7573.10.camel@heimdal.trondhjem.org>
	 <1192635028.27435.137.camel@twins>
	 <1192635917.7573.24.camel@heimdal.trondhjem.org>
	 <1192636074.7573.27.camel@heimdal.trondhjem.org>
	 <1192636652.27435.147.camel@twins>
	 <1192638253.7573.38.camel@heimdal.trondhjem.org>
	 <1192638372.27435.154.camel@twins>  <1192642584.27435.157.camel@twins>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 14:49:26 -0400
Message-Id: <1192646966.7573.62.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.121)
X-UiO-Scanned: 6B70B8B6946E9505B3AC51AA7986815A81E253D1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 720 total 4558177 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-17 at 19:36 +0200, Peter Zijlstra wrote:
> On Wed, 2007-10-17 at 18:26 +0200, Peter Zijlstra wrote:
> > On Wed, 2007-10-17 at 12:24 -0400, Trond Myklebust wrote:
> > > On Wed, 2007-10-17 at 17:57 +0200, Peter Zijlstra wrote:
> > > > On Wed, 2007-10-17 at 11:47 -0400, Trond Myklebust wrote:
> > > > > On Wed, 2007-10-17 at 11:45 -0400, Trond Myklebust wrote:
> > > > > > On Wed, 2007-10-17 at 17:30 +0200, Peter Zijlstra wrote:
> > > > > > 
> > > > > > > The thing is, swapper_space just calls ->writepage() and expects the
> > > > > > > page to be written out. So either the a_ops usage of swapper_space is
> > > > > > > deviant or NFS' is.
> > > > > > 
> > > > > > Could somebody please document WTF writepage() is supposed to do, and
> > > > > > WTF page_mkwrite() is for?
> > > > > > 
> > > > > > I thought that page_mkwrite() was supposed to finally allow us to deal
> > > > > > with dirty pages in a clean manner: the caller gets to tell the
> > > > > > filesystem that it wants the entire page written out, and then dirties
> > > > > > the page. What is the point if the VM then expects to be able to
> > > > > > circumvent this?
> > > > > 
> > > > > Put differently:
> > > > >       * _who_ is dirtying the page when the swapper is trying to write
> > > > >         the page out?
> > > > >       * why are they not calling either page_mkwrite() or
> > > > >         commit_write()?
> > > > 
> > > > I'm writing anonymous pages (I'm the crazy person doing swap over NFS).
> > > > And anonymous is dirty by default.
> > > 
> > > I'd really prefer to _know_ that these writes are coming from the
> > > swapper. That makes it possible to give them a correct credential and
> > > open context.
> > > 
> > > Could you perhaps funnel them through a new a_op->swap_out() and default
> > > back to ->writepage() for those filesystems that don't define it?
> > 
> > Sure, will do that.
> 
> OTOH these pages will have PageSwapCache() and IS_SWAPFILE(inode) will
> be true, so ->writepage() can already know. Do you still prefer
> ->swap_out() ?

I think it is cleaner. PageSwapCache() is currently internal to the mm
layer, and doesn't need to be exported here. Then there is the issue of
overloading ->writepage(), which I don't like at all: it muddies the
semantics.

As for IS_SWAPFILE(), it would be nice to get rid of that one day...

Cheers
  Trond

