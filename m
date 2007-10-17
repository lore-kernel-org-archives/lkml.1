Return-Path: <linux-kernel-owner+w=401wt.eu-S936378AbXJQRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936378AbXJQRgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762636AbXJQRg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:36:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761733AbXJQRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:36:26 -0400
Subject: Re: [PATCH] nfs: fix nfs_writepage()
From: Peter Zijlstra <peterz@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1192638372.27435.154.camel@twins>
References: <1192628458.27435.119.camel@twins>
	 <1192634702.7573.10.camel@heimdal.trondhjem.org>
	 <1192635028.27435.137.camel@twins>
	 <1192635917.7573.24.camel@heimdal.trondhjem.org>
	 <1192636074.7573.27.camel@heimdal.trondhjem.org>
	 <1192636652.27435.147.camel@twins>
	 <1192638253.7573.38.camel@heimdal.trondhjem.org>
	 <1192638372.27435.154.camel@twins>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 19:36:24 +0200
Message-Id: <1192642584.27435.157.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 18:26 +0200, Peter Zijlstra wrote:
> On Wed, 2007-10-17 at 12:24 -0400, Trond Myklebust wrote:
> > On Wed, 2007-10-17 at 17:57 +0200, Peter Zijlstra wrote:
> > > On Wed, 2007-10-17 at 11:47 -0400, Trond Myklebust wrote:
> > > > On Wed, 2007-10-17 at 11:45 -0400, Trond Myklebust wrote:
> > > > > On Wed, 2007-10-17 at 17:30 +0200, Peter Zijlstra wrote:
> > > > > 
> > > > > > The thing is, swapper_space just calls ->writepage() and expects the
> > > > > > page to be written out. So either the a_ops usage of swapper_space is
> > > > > > deviant or NFS' is.
> > > > > 
> > > > > Could somebody please document WTF writepage() is supposed to do, and
> > > > > WTF page_mkwrite() is for?
> > > > > 
> > > > > I thought that page_mkwrite() was supposed to finally allow us to deal
> > > > > with dirty pages in a clean manner: the caller gets to tell the
> > > > > filesystem that it wants the entire page written out, and then dirties
> > > > > the page. What is the point if the VM then expects to be able to
> > > > > circumvent this?
> > > > 
> > > > Put differently:
> > > >       * _who_ is dirtying the page when the swapper is trying to write
> > > >         the page out?
> > > >       * why are they not calling either page_mkwrite() or
> > > >         commit_write()?
> > > 
> > > I'm writing anonymous pages (I'm the crazy person doing swap over NFS).
> > > And anonymous is dirty by default.
> > 
> > I'd really prefer to _know_ that these writes are coming from the
> > swapper. That makes it possible to give them a correct credential and
> > open context.
> > 
> > Could you perhaps funnel them through a new a_op->swap_out() and default
> > back to ->writepage() for those filesystems that don't define it?
> 
> Sure, will do that.

OTOH these pages will have PageSwapCache() and IS_SWAPFILE(inode) will
be true, so ->writepage() can already know. Do you still prefer
->swap_out() ?

