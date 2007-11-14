Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXKNWZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXKNWZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXKNWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:24:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:47817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXKNWYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:24:50 -0500
Date: Wed, 14 Nov 2007 23:24:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 3/3] nfs: use ->mmap_prepare() to avoid an AB-BA deadlock
Message-ID: <20071114222448.GE31048@wotan.suse.de>
References: <20071114200136.009242000@chello.nl> <20071114201528.514434000@chello.nl> <20071114212246.GA31048@wotan.suse.de> <1195075905.22457.3.camel@lappy> <1195076485.7584.66.camel@heimdal.trondhjem.org> <1195077034.22457.6.camel@lappy> <1195078730.7584.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195078730.7584.86.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 05:18:50PM -0500, Trond Myklebust wrote:
> 
> On Wed, 2007-11-14 at 22:50 +0100, Peter Zijlstra wrote:
> > Right, but I guess what Nick asked is, if pages could be stale to start
> > with, how is that avoided in the future.
> > 
> > The way I understand it, this re-validate is just a best effort at
> > getting a coherent image.
> 
> The normal convention for NFS is to use a close-to-open cache
> consistency model. In that model, applications must agree never to open
> the file for reading or writing if an application on a different NFS
> client already holds it open for writing.
> 
> However there is no standard locking model for _enforcing_ such an
> agreement, so some setups do violate it. One obvious model that we try
> to support is that where the applications are using POSIX locking in
> order to ensure exclusive access to the data when requires.
> 
> Another model is to rely rather on synchronous writes and heavy
> attribute revalidation to detect when a competing application has
> written to the file (the 'noac' mount option). While such a model is
> obviously deficient in that it can never guarantee cache coherency, we
> do attempt to ensure that it works on a per-operation basis (IOW: we
> check cache coherency before each call to read(), to mmap(), etc) since
> it is by far the easiest model to apply if you have applications that
> cannot be rewritten and that satisfy the requirement that they rarely
> conflict.

mmap()s can be different from read in that the syscall may have little
relation to when the data gets used. But I guess it's still a best
effort thing. Fair enough.

Thanks,
Nick
