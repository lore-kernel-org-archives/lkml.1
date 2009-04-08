Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbZDHAoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbZDHAoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbZDHAop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:44:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:31899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbZDHAoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:44:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,340,1235980800"; 
   d="scan'208";a="129032348"
Date: Wed, 8 Apr 2009 08:44:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jos Houtman <jos@hyves.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads
Message-ID: <20090408004410.GA18679@localhost>
References: <C60129DA.EB0F%jos@hyves.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C60129DA.EB0F%jos@hyves.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC Jens]

On Tue, Apr 07, 2009 at 10:03:38PM +0800, Jos Houtman wrote:
> 
> I tried the write-back branch from the 2.6-block tree.
> 
> And I can atleast confirm that it works, atleast in relation to the
> writeback not keeping up when the device was congested before it wrote a
> 1024 pages. 
> 
> See: http://lkml.org/lkml/2009/3/22/83  for a bit more information.

Hi Jos, you said that this simple patch solved the problem, however you
mentioned somehow suboptimal performance. Can you elaborate that?  So
that I can push or improve it.

Thanks,
Fengguang
---
 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/fs/fs-writeback.c
+++ mm/fs/fs-writeback.c
@@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
+				if (wbc->nr_to_write <= 0 ||
+				    wbc->encountered_congestion) {
 					/*
 					 * slice used up: queue for next turn
 					 */

> But the second problem seen in that thread, a write-starve-read problem does
> not seem to solved. In this problem the writes of the writeback algorithm
> starve the ongoing reads, no matter what io-scheduler is picked.
> 
> For good measure I also applied the blk-latency patches on top of the
> writeback branch, this did not improve anything. Nor did lowering
> max_sectors_kb, as linus suggested in the IO latency thread.
> 
> 
> As for a reproducible test-case: the simplest I could come up with was
> modifying the fsync-tester not to fsync, but letting the normal writeback
> handle it. And starting a separate process that tries to sequentially read a
> file from the same device. The read performance drops to a bare minimum as
> soon as the writeback algorithm kicks in.
> 
> 
> Jos
> 
> 
> 
> 
