Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYFPUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYFPUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYFPUzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:55:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYFPUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:55:09 -0400
Date: Mon, 16 Jun 2008 16:53:51 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080616165351.1b2ff397@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0806021319250.16157@blonde.site>
References: <20080530102619.GA2468@elf.ucw.cz>
	<Pine.LNX.4.64.0805301451020.19914@blonde.site>
	<20080530204307.GA4978@ucw.cz>
	<Pine.LNX.4.64.0805311925190.27293@blonde.site>
	<20080531173950.c4f04028.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806010752510.24919@blonde.site>
	<20080601011501.199af80c.akpm@linux-foundation.org>
	<20080601114008.GC16843@elf.ucw.cz>
	<20080601133727.4e62ae55.akpm@linux-foundation.org>
	<20080602114319.GI5757@kernel.dk>
	<Pine.LNX.4.64.0806021319250.16157@blonde.site>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 13:40:28 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:
> On Mon, 2 Jun 2008, Jens Axboe wrote:
> > On Sun, Jun 01 2008, Andrew Morton wrote:
> > > 
> > > Well if you're asking the syscall to shove more data into the block
> > > layer than it can concurrently handle, sure, the block layer will
> > > block.  It's tunable...
> > 
> > Ehm, lets get the history right, please :-)
> > 
> > The block layer pretty much doesn't care about how large the queue
> > size is, it's largely at 128 to prevent the vm from shitting itself
> > like it has done in the past (and continues to do I guess, though
> > your reply leaves me wondering).
> > 
> > So you think the vm will be fine with a huge number of requests?
> > It wont go nuts scanning and reclaiming, wasting oodles of CPU
> > cycles?
> 
> Interesting.  I wonder.  I may be quite wrong (Cc'ed Rik and Lee
> who I think are currently most in touch with what goes on there),
> but my impression is that whereas vmscan.c takes pages off LRU
> while it's doing writeback on them, and arranges for them to go
> back to the reclaimable tail of the LRU

The problem with lots of CFQ requests is simpler.

If you look at balance_dirty_pages() you will see that it only
takes dirty and NFS unstable pages into account when checking
the dirty limit.  The pages that are in flight (under IO) are
not counted at all.

If you have 8192 CFQ requests and large streaming IO, most of
the IOs will be mergeable and it is possible to pin all of
memory in in-flight (PG_writeback - and other?) pages.

I suspect that balance_dirty_pages() will have to take the
writeback pages into account, though that may cause problems
with FUSE.  Maybe it should at least wait for some IO to
complete?

-- 
All rights reversed.
