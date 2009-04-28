Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbZD1MIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbZD1MIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZD1MIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:08:34 -0400
Received: from THUNK.ORG ([69.25.196.29]:53572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZD1MId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:08:33 -0400
Date: Tue, 28 Apr 2009 08:08:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Message-ID: <20090428120818.GH22104@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
References: <20090428044426.GA5035@eskimo.com> <20090428143019.EBBF.A69D9226@jp.fujitsu.com> <1240904919.7620.73.camel@twins> <20090428090916.GC17038@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428090916.GC17038@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:09:16PM +0800, Wu Fengguang wrote:
> The semi-drop-behind is a great idea for the desktop - to put just
> accessed pages to end of LRU. However I'm still afraid it vastly
> changes the caching behavior and wont work well as expected in server
> workloads - shall we verify this?
> 
> Back to this big-cp-hurts-responsibility issue. Background write
> requests can easily pass the io scheduler's obstacles and fill up
> the disk queue. Now every read request will have to wait 10+ writes
> - leading to 10x slow down of major page faults.
> 
> I reach this conclusion based on recent CFQ code reviews. Will bring up
> a queue depth limiting patch for more exercises..

We can muck with the I/O scheduler, but another thing to consider is
whether the VM should be more aggressively throttling writes in this
case; it sounds like the big cp in this case may be dirtying pages so
aggressively that it's driving other (more useful) pages out of the
page cache --- if the target disk is slower than the source disk (for
example, backing up a SATA primary disk to a USB-attached backup disk)
no amount of drop-behind is going to help the situation.

So that leaves three areas for exploration:

* Write-throttling
* Drop-behind
* background writes pushing aside foreground reads

Hmm, note that although the original bug reporter is running Ubuntu
Jaunty, and hence 2.6.28, this problem is going to get *worse* with
2.6.30, since we have the ext3 data=ordered latency fixes which will
write out the any journal activity, and worse, any synchornous commits
(i.e., caused by fsync) will force out all of the dirty pages with
WRITE_SYNC priority.  So with a heavy load, I suspect this is going to
be more of a VM issue, and especially figuring out how to tune more
aggressive write-throttling may be key here.

					- Ted
