Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYFBMmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYFBMmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYFBMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:41:55 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58753 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbYFBMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:41:54 -0400
Date: Mon, 2 Jun 2008 13:40:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <20080602114319.GI5757@kernel.dk>
Message-ID: <Pine.LNX.4.64.0806021319250.16157@blonde.site>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site>
 <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site>
 <20080531173950.c4f04028.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org>
 <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org>
 <20080602114319.GI5757@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Jens Axboe wrote:
> On Sun, Jun 01 2008, Andrew Morton wrote:
> > 
> > Well if you're asking the syscall to shove more data into the block
> > layer than it can concurrently handle, sure, the block layer will
> > block.  It's tunable...
> 
> Ehm, lets get the history right, please :-)
> 
> The block layer pretty much doesn't care about how large the queue
> size is, it's largely at 128 to prevent the vm from shitting itself
> like it has done in the past (and continues to do I guess, though
> your reply leaves me wondering).
> 
> So you think the vm will be fine with a huge number of requests?
> It wont go nuts scanning and reclaiming, wasting oodles of CPU
> cycles?

Interesting.  I wonder.  I may be quite wrong (Cc'ed Rik and Lee
who I think are currently most in touch with what goes on there),
but my impression is that whereas vmscan.c takes pages off LRU
while it's doing writeback on them, and arranges for them to go
back to the reclaimable tail of the LRU once writeback completes
(the rotate reclaimable business), pages under writeback which
it did not itself initiate will get put back on LRU at the head
(with write completion still pending).

If unbounded queues turn out to be viable in other respects
(which would be very attractive for SYNC_PAGE_RANGE_WRITE), even
if not, then maybe shrink_page_list needs to be able to take pages
already under Writeback off the LRU and set them Reclaimable.

Hugh
