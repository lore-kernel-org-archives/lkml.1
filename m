Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXDUKkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXDUKkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXDUKkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:40:22 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34807 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030632AbXDUKkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:40:21 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
In-reply-to: <20070421025532.916b1e2e.akpm@linux-foundation.org> (message from
	Andrew Morton on Sat, 21 Apr 2007 02:55:32 -0700)
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
References: <20070420155154.898600123@chello.nl>
	<20070420155503.608300342@chello.nl> <20070421025532.916b1e2e.akpm@linux-foundation.org>
Message-Id: <E1HfCzN-0002dZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 12:38:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 20 Apr 2007 17:52:04 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Scale writeback cache per backing device, proportional to its writeout speed.
> > 
> > By decoupling the BDI dirty thresholds a number of problems we currently have
> > will go away, namely:
> > 
> >  - mutual interference starvation (for any number of BDIs);
> >  - deadlocks with stacked BDIs (loop, FUSE and local NFS mounts).
> > 
> > It might be that all dirty pages are for a single BDI while other BDIs are
> > idling. By giving each BDI a 'fair' share of the dirty limit, each one can have
> > dirty pages outstanding and make progress.
> > 
> > A global threshold also creates a deadlock for stacked BDIs; when A writes to
> > B, and A generates enough dirty pages to get throttled, B will never start
> > writeback until the dirty pages go away. Again, by giving each BDI its own
> > 'independent' dirty limit, this problem is avoided.
> > 
> > So the problem is to determine how to distribute the total dirty limit across
> > the BDIs fairly and efficiently. A DBI that has a large dirty limit but does
> > not have any dirty pages outstanding is a waste.
> > 
> > What is done is to keep a floating proportion between the DBIs based on
> > writeback completions. This way faster/more active devices get a larger share
> > than slower/idle devices.
> 
> This is a pretty major improvement to various nasty corner-cases, if it
> works.
> 
> Does it work?  Please describe the testing you did, and the results.
> 
> Has this been confirmed to fix Miklos's FUSE and loopback problems?

I haven't yet tested it (will do), but I'm sure it does solve the
deadlock in balance_dirty_pages(), if for no other reason, that when
the queue is idle (no dirty or writeback pages), then it allowes the
caller to dirty some more pages.

The other deadlock, in throttle_vm_writeout() is still to be solved.

Miklos
