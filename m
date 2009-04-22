Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZDVBXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZDVBXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZDVBXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:23:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35211 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZDVBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:23:42 -0400
Date: Wed, 22 Apr 2009 10:21:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, Theodore Tso <tytso@mit.edu>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-Id: <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090417143903.GA30365@linux>
	<20090421001822.GB19186@mit.edu>
	<20090421083001.GA8441@linux>
	<20090421140631.GF19186@mit.edu>
	<20090421143130.GA22626@linux>
	<20090421163537.GI19186@mit.edu>
	<20090421172317.GM19637@balbir.in.ibm.com>
	<20090421174620.GD15541@mit.edu>
	<20090421181429.GO19637@balbir.in.ibm.com>
	<20090421191401.GF15541@mit.edu>
	<20090421204905.GA5573@linux>
	<20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 09:33:49 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:


> > And this should be probably strictly connected to the IO controller. If
> > we throttle or delay the dispatching/submission of some IO requests
> > without throttling the dirty pages rate a cgroup could completely waste
> > its own available memory with dirty (hard and slow to reclaim) pages.
> > 
> > That is in part the approach I used in io-throttle v12, adding a hook in
> > balance_dirty_pages_ratelimited_nr() to throttle the current task when
> > cgroup's IO limit are exceeded. Argh!
> > 
> > So, another proposal could be to re-add in io-throttle v14 the old hook
> > also in balance_dirty_pages_ratelimited_nr().
> > 
> > In this way io-throttle would:
> > 
> > - use page_cgroup infrastructure and page_cgroup->flags to encode the
> >   cgroup id that firstly dirtied a generic page
> > - account and opportunely throttle sync and writeback IO requests in
> >   submit_bio()
> > - at the same time throttle the tasks in
> >   balance_dirty_pages_ratelimited_nr() if the cgroup they belong has
> >   exhausted the IO BW (or quota, share, etc. in case of proportional BW
> >   limit)
> > 
> 
> IMHO, io-controller should just work as I/O subsystem as bdi. Now, per-bdi dirty_ratio
> is suppoted and it seems to work well.  
> 
> Can't we write a function like  bdi_writeout_fraction() ?;
> It will be a simple choice.
> 
One more thing, if you want dirty_ratio for throttoling I/O not for supporing page reclaim,
Something like task_dirty_limit() will be apporpriate.

Thanks,
-Kame

