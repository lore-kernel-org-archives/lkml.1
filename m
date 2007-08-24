Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbXHXOig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbXHXOig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXHXOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:38:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10497 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXHXOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:38:10 -0400
Date: Fri, 24 Aug 2007 10:36:58 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070824103658.239cb132@think.oraclecorp.com>
In-Reply-To: <387961898.15210@ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn>
	<20070821202314.335e86ec@think.oraclecorp.com>
	<387745522.02814@ustc.edu.cn>
	<20070822084201.2c4eceb6@think.oraclecorp.com>
	<387961898.15210@ustc.edu.cn>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 21:24:58 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
 
> > 2) s_dirty and s_io both become radix trees.  s_dirty is indexed by
> > a sequence number that corresponds to age.  It is treated as a big
> > circular indexed list that can wrap around over time.  Radix tree
> > tags are used both on s_dirty and s_io to flag which inodes are in
> > progress.
> 
> It's meaningless to convert s_io to radix tree. Because inodes on s_io
> will normally be sent to block layer elevators at the same time.

Not entirely, using a radix tree instead lets you tag things instead of
doing the current backflips across three lists.

> 
> Also s_dirty holds 30 seconds of inodes, while s_io only 5 seconds.
> The more inodes, the more chances of good clustering. That's the
> general rule.
> 
> s_dirty is the right place to do address-clustering.
> As for the dirty_expire_interval parameter on dirty age,
> we can apply a simple rule: do one full scan/sweep over the
> fs-address-space in every 30s, syncing all inodes encountered,
> and sparing those newly dirtied in less than 5s. With that rule,
> any inode will get synced after being dirtied for 5-35 seconds.

This gives you an O(inodes dirty) behavior instead of the current O(old
inodes).  It might not matter, but walking the radix tree is more
expensive than walking a list.

But, I look forward to your patches, we can tune from there.

-chris
