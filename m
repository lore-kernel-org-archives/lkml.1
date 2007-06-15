Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXFOCX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXFOCX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXFOCXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:23:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXFOCXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:23:51 -0400
Date: Thu, 14 Jun 2007 19:23:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614192340.13d99e84.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706141855570.3571@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	<20070614143248.736312f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
	<20070614150417.c73fb6b9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
	<20070614154939.c94b097f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
	<20070614184013.1ff51d34.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141855570.3571@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 19:04:27 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > > Of course there is. The seeks are reduced since there are an factor 
> > > of 16 less metadata blocks. fsck does not read files. It just reads 
> > > metadata structures. And the larger contiguous areas the faster.
> > 
> > Some metadata is contiguous: inode tables, some directories (if they got
> > lucky), bitmap tables.  But fsck surely reads them in a single swoop
> > anyway, so there's no gain there.
> 
> The metadata needs to refer to 1/16th of the earlier pages that need to be 
> tracked. metadata is shrunk significantly.

Only if the filesystems are altered to use larger blocksizes and if the
operator then chooses to use that feature.  Then they suck for small-sized
(and even medium-sized) files.

So you're still talking about corner cases: specialised applications which
require careful setup and administrator intervention.

What can we do to optimise the common case?

> > Other metadata (indirect blocks) are 100% discontiguous, and reading those
> > with a 64k IO into 64k of memory is completely dumb.
> 
> The effect of a larger page size is that the filesystem will 
> place more meta data into a single page instead of spreading it out. 
> Reading a mass of meta data with a 64k read is an intelligent choice to 
> make in particular if there is a large series of such reads.

Again: requires larger blocksize: specialised, uninteresting for what will
remain the common case: 4k blocksize.

The alleged fsck benefit is also unrelated to variable PAGE_CACHE_SIZE. 
It's a feature of larger (unweildy?) blocksize, and xfs already has that
working (doesn't it?)

There may be some benefits to some future version of ext4.
