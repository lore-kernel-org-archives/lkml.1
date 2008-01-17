Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbYAQLWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbYAQLWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYAQLWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:22:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYAQLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:22:07 -0500
Subject: Re: 2.6.24-rc7: memory leak?
From: Peter Zijlstra <peterz@infradead.org>
To: CaT <cat@zip.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080117063410.GQ3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 12:22:03 +0100
Message-Id: <1200568923.28661.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 17:34 +1100, CaT wrote:
> Not sure where to begin so here goes anway. Today I did an rsync backup
> of a server with 2million+ files. Before doing so the used memory on the
> server this was initiated from was under 200meg (excluding buffers and
> cache). During the rsync the memory used grew to just shy of 1.6gig and
> now, about 2 hours after the rsync has well and truly finished, the used
> memory is at 1.23gig. This is what free reports:
> 
>              total       used       free     shared    buffers cached
> Mem:       2058128    1994468      63660          0     688604 11432
> -/+ buffers/cache:    1294432     763696
> Swap:      1048568          0    1048568
> 
> There are 75 processes on the box of which almost 47 are kernel
> processes + init. Of the rest, the top 3 have an RSS of 9.4meg, 6.2meg
> and 4.8meg, 7 are at around 2meg and the rest are below 2meg with the
> majority below 1. So unless I'm misunderstanding something, processess
> alone do not account for the amount of used memory.
> 
> The destination of the rsync was an ext3 filesystem over raid5 over ahci
> sata.
> 
> I've included /proc/meminfo, /proc/slabinfo and config.gz. If there's
> anything else please shout.

How much memory does:

  echo 3 > /proc/sys/vm/drop_caches

gain you?


> ext3_inode_cache  1235577 1240565    768    5    1 : tunables   54   27    8 : slabdata 248113 248113      0
> dentry            703661 749797    200   19    1 : tunables  120   60    8 : slabdata  39463  39463      0
> buffer_head       174535 209087    104   37    1 : tunables  120   60    8 : slabdata   5651   5651      0

would get freed by doing that.

this one:

> size-64           537590 850249     64   59    1 : tunables  120   60    8 : slabdata  14411  14411      0

I'm unsure about, if that one sticks around that'd be something to worry
about. See if you can monitor this value and try to determine:

 - if it ever drops
 - what makes it grow (fastest)

I guess we could stick some instrumentation in there to track that
bucket.

