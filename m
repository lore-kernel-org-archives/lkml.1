Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYFQEzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYFQEzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 00:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYFQEzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 00:55:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYFQEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 00:55:44 -0400
Date: Mon, 16 Jun 2008 21:54:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-Id: <20080616215406.8f09e519.akpm@linux-foundation.org>
In-Reply-To: <20080616165351.1b2ff397@bree.surriel.com>
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
	<20080616165351.1b2ff397@bree.surriel.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 16:53:51 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Mon, 2 Jun 2008 13:40:28 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> > On Mon, 2 Jun 2008, Jens Axboe wrote:
> > > On Sun, Jun 01 2008, Andrew Morton wrote:
> > > > 
> > > > Well if you're asking the syscall to shove more data into the block
> > > > layer than it can concurrently handle, sure, the block layer will
> > > > block.  It's tunable...
> > > 
> > > Ehm, lets get the history right, please :-)
> > > 
> > > The block layer pretty much doesn't care about how large the queue
> > > size is, it's largely at 128 to prevent the vm from shitting itself
> > > like it has done in the past (and continues to do I guess, though
> > > your reply leaves me wondering).
> > > 
> > > So you think the vm will be fine with a huge number of requests?
> > > It wont go nuts scanning and reclaiming, wasting oodles of CPU
> > > cycles?
> > 
> > Interesting.  I wonder.  I may be quite wrong (Cc'ed Rik and Lee
> > who I think are currently most in touch with what goes on there),
> > but my impression is that whereas vmscan.c takes pages off LRU
> > while it's doing writeback on them, and arranges for them to go
> > back to the reclaimable tail of the LRU
> 
> The problem with lots of CFQ requests is simpler.
> 
> If you look at balance_dirty_pages() you will see that it only
> takes dirty and NFS unstable pages into account when checking
> the dirty limit.  The pages that are in flight (under IO) are
> not counted at all.

That would be totally busted.  All that nr_writeback logic in there is very
much supposed to handle under-writeback pages?

> If you have 8192 CFQ requests and large streaming IO, most of
> the IOs will be mergeable and it is possible to pin all of
> memory in in-flight (PG_writeback - and other?) pages.
> 
> I suspect that balance_dirty_pages() will have to take the
> writeback pages into account, though that may cause problems
> with FUSE.  Maybe it should at least wait for some IO to
> complete?

Worried.  One of us is missing something here.
