Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXBTATN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXBTATN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXBTASi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:18:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:60557 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965595AbXBTAS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:18:26 -0500
Date: Mon, 19 Feb 2007 19:16:20 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: dirty balancing deadlock
Message-ID: <20070220001620.GK6133@think.oraclecorp.com>
References: <20070218125307.4103c04a.akpm@linux-foundation.org> <E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu> <20070218145929.547c21c7.akpm@linux-foundation.org> <E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu> <20070219004537.GB9289@think.oraclecorp.com> <E1HIwnX-0005Sr-00@dorka.pomaz.szeredi.hu> <20070219010102.GC9289@think.oraclecorp.com> <E1HIx6d-0005V4-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HIx6d-0005V4-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 02:14:15AM +0100, Miklos Szeredi wrote:
> > > > In general, writepage is supposed to do work without blocking on
> > > > expensive locks that will get pdflush and dirty reclaim stuck in this
> > > > fashion.  You'll probably have to take the same approach reiserfs does
> > > > in data=journal mode, which is leaving the page dirty if fuse_get_req_wp
> > > > is going to block without making progress.
> > > 
> > > Pdflush, and dirty reclaim set wbc->nonblocking to true.
> > > balance_dirty_pages and fsync don't.  The problem here is that
> > > Andrew's patch is wrong to let balance_dirty_pages() try to write back
> > > pages from a different queue.
> > 
> > async or sync, writepage is supposed to either make progress or bail.
> > loopback aside, if the fuse call is blocking long term, you're going to
> > run into problems.
> 
> Hmm, like what?

Something a little different from what you're seeing.  Basically if the
PF_MEMALLOC paths end up waiting on a filesystem transaction, and that
transaction is waiting for more ram, the system will eventually grind to
a halt.  data=journal is the easiest way to hit it, since writepage
always logs at least 4k.

WB_SYNC_NONE and wbc->nonblocking aren't a great test, in reiser I
resorted to testing PF_MEMALLOC.

-chris

