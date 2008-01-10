Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYAJIiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYAJIiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYAJIh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:37:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYAJIh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:37:56 -0500
Date: Thu, 10 Jan 2008 08:37:53 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110083753.GB10745@infradead.org>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101242.25671.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:42:25PM +1100, Nick Piggin wrote:
> > So how does it work? Instead of punting IO to a thread and passing it
> > through the page cache, we instead attempt to send the IO directly to the
> > filesystem block that it maps to.
> 
> You told Christoph that just using direct-IO from kernel still doesn't
> give you the required behaviour... What about queueing the IO directly
> *and* using direct-IO? I guess it still has to go through the underlying
> filesystem, but that's probably a good thing.

We defintively need to go through the filesystem for I/O submission,
and also for I/O completion.  Thinking of the async submission might be
what Peter actually implemented for his network swapping patches as
you really wouldn't want to write it out synchronously.


Peter, any chance you could chime in here?
> 
> > loop maintains a prio tree of known 
> > extents in the file (populated lazily on demand, as needed).
> 
> Just a quick question (I haven't looked closely at the code): how come
> you are using a prio tree for extents? I don't think they could be
> overlapping?

IMHO this shouldn't be done in the loop driver anyway.  Filesystems have
their own effricient extent lookup trees (well, at least xfs and btrfs
do), and we should leverage that instead of reinventing it.
