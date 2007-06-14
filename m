Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXFNXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXFNXmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXFNXmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:42:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbXFNXmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:42:04 -0400
Date: Thu, 14 Jun 2007 16:41:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614164118.cbd48e53.akpm@linux-foundation.org>
In-Reply-To: <20070614233002.GG86004887@sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	<20070614143248.736312f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
	<20070614150417.c73fb6b9.akpm@linux-foundation.org>
	<20070614233002.GG86004887@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 15 Jun 2007 09:30:02 +1000 David Chinner <dgc@sgi.com> wrote:
> On Thu, Jun 14, 2007 at 03:04:17PM -0700, Andrew Morton wrote:
> > fsck is single-threaded (hence no locking issues) and operates against the
> > blockdev pagecache and does a _lot_ of small reads (indirect blocks,
> > especially).
> 
> Commenting purely about the above statement (and not on large pages
> or block sizes), xfs-repair has had multithreaded capability for some
> time now. E.g. from the xfs_repair man page:
> 
>        -M    Disable  multi-threaded  mode. Normally, xfs_repair runs with
> 	     twice the number of threads as processors.
> 
> 
> We have the second generation multithreading code out for review
> right now. e.g:
> 
> http://oss.sgi.com/archives/xfs/2007-06/msg00069.html
> 
> xfs_repair also uses direct I/O and does it's own userspace block
> caching and so avoids the problems involved with low memory, context
> unaware cache reclaim and blockdev cache thrashing.

umm, that sounds like a mistake to me.  fscks tend to get run when there's
no swap online.  A small system with a large disk risks going oom and can
no longer be booted.  Whereas if the fsck relies upon kernel caching it'll
run slower but will complete.

> And to top it all off, some of the prefetch smarts we added result
> in reading multiple sparse metadata blocks in a single, larger I/O,
> so repair is now often bandwidth bound rather than seek bound...
> 
> All I'm trying to say here is that you shouldn't assume that the
> problems a particular filesystem fsck has is common to all the
> rest....

Yup.  I was of course referring to fsck.extN.
