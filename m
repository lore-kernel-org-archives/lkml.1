Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbXLLU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbXLLU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXLLU4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:56:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45814 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXLLU4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:56:07 -0500
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file
	writes.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Rubin <mrubin@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-Reply-To: <20071211020255.CFFB21080E@localhost>
References: <20071211020255.CFFB21080E@localhost>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 21:55:54 +0100
Message-Id: <1197492954.6353.64.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-10 at 18:02 -0800, Michael Rubin wrote:
> From: Michael Rubin <mrubin@google.com>
> 
> Fixing a bug where writing to large files while concurrently writing to
> smaller ones creates a situation where writeback cannot keep up with the
> traffic and memory baloons until the we hit the threshold watermark. This
> can result in surprising latency spikes when syncing. This latency
> can take minutes on large memory systems. Upon request I can provide
> a test to reproduce this situation.

The part I miss here is the rationale on _how_ you solve the problem.

The patch itself is simple enough, but I've been staring at this code
for a while now, and I'm just not getting it.

> The only concern I have is that this makes the wb_kupdate slightly more
> agressive. I am not sure it is enough to cause any problems. I think
> there is enough checks to throttle the background activity.
> 
> Feng also the one line change that you recommended here 
> http://marc.info/?l=linux-kernel&m=119629655402153&w=2 had no effect.
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>
> ---
> Index: 2624rc3_feng/fs/fs-writeback.c
> ===================================================================
> --- 2624rc3_feng.orig/fs/fs-writeback.c	2007-11-29 14:44:24.000000000 -0800
> +++ 2624rc3_feng/fs/fs-writeback.c	2007-12-10 17:21:45.000000000 -0800
> @@ -408,8 +408,7 @@ sync_sb_inodes(struct super_block *sb, s
>  {
>  	const unsigned long start = jiffies;	/* livelock avoidance */
>  
> -	if (!wbc->for_kupdate || list_empty(&sb->s_io))
> -		queue_io(sb, wbc->older_than_this);
> +	queue_io(sb, wbc->older_than_this);
>  
>  	while (!list_empty(&sb->s_io)) {
>  		struct inode *inode = list_entry(sb->s_io.prev,
> Index: 2624rc3_feng/mm/page-writeback.c
> ===================================================================
> --- 2624rc3_feng.orig/mm/page-writeback.c	2007-11-16 21:16:36.000000000 -0800
> +++ 2624rc3_feng/mm/page-writeback.c	2007-12-10 17:37:17.000000000 -0800
> @@ -638,7 +638,7 @@ static void wb_kupdate(unsigned long arg
>  		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
>  		writeback_inodes(&wbc);
>  		if (wbc.nr_to_write > 0) {
> -			if (wbc.encountered_congestion || wbc.more_io)
> +			if (wbc.encountered_congestion)
>  				congestion_wait(WRITE, HZ/10);
>  			else
>  				break;	/* All the old data is written */

