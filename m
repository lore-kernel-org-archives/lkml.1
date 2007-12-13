Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbXLMPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbXLMPYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXLMPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:24:40 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49284 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXLMPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:24:38 -0500
Date: Thu, 13 Dec 2007 10:24:17 -0500
Message-Id: <200712131524.lBDFOHBv024206@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, hch@infradead.org, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 36/42] VFS: export drop_pagecache_sb 
In-reply-to: Your message of "Wed, 12 Dec 2007 16:38:34 +1100."
             <200712121638.35167.nickpiggin@yahoo.com.au> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200712121638.35167.nickpiggin@yahoo.com.au>, Nick Piggin writes:
> On Monday 10 December 2007 13:42, Erez Zadok wrote:
> > Needed to maintain cache coherency after branch management.
> >
> 
> Hmm, I'd much prefer to be able to sleep in invalidate_mapping_pages
> before this function gets exported.
> 
> As it is, it can cause massive latencies on preemption and the inode_lock
> so it is pretty much debug-only IMO. I'd rather it didn't escape into the
> wild as is.
> 
> Either that or rework your cache coherency somehow.

Nick, thanks for the advice.

We use a generation number after each successful branch configuration
command, so that ->d_revalidate later on can discover that change, and
rebuild the union of objects.  At ->remount time, I figured it'd be nice to
"encourage" that revalidation to happen sooner, by invalidating as many
upper pages as possible, thus causing ->d_revalidate/->readpage to take
place sooner.  So we used to call drop_pagecache_sb from our remount code:
it was the only caller of drop_pagecache_sb.  It wasn't too much of an
latency issue to call drop_pagecache_sb there: the VFS remount code path is
already pretty slow (dropping temporarily to readonly mode, and dropping
other caches), and remount isn't an operation used often, so a little bit
more latency would probably not have been noticed by users.

Nevertheless, it was not strictly necessary to call drop_pagecache_sb in
unionfs_remount, because the objects in question will have gotten
revalidated sooner or later anyway; the call to drop_pagecache_sb was just
an optimization (one which I wasn't 100% sure about anyway, as per my long
"XXX" comment above that call in unionfs_remount).

So I agree with you: if this symbol can be abused by modules and cause
problems, then exporting it to modules is too risky.  I've reworked my code
to avoid calling drop_pagecache_sb and I'll [sic] drop that patch.

Cheers,
Erez.
