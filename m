Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZDVAff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZDVAff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZDVAfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:35:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDVAfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:35:24 -0400
Date: Wed, 22 Apr 2009 09:33:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-Id: <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090421204905.GA5573@linux>
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
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 22:49:06 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:
> yep! right. Anyway, it's not completely wrong to account dirty pages in
> this way. The dirty pages actually belong to cgroup A and providing per
> cgroup upper limits of dirty pages could help to equally distribute
> dirty pages, that are hard/slow to reclaim, among cgroups.
> 
> But this is definitely another problem.
> 
Hmm, my motivation for dirty accounting in memcg is for supporting dirty_ratio
to do smooth page reclaiming and to kick background-write-out.


> And it doesn't help for the problem described by Ted, expecially for the
> IO controller. The only way I see to correctly handle that case is to
> limit the rate of dirty pages per cgroup, accounting the dirty activity
> to the cgroup that firstly touched the page (and not the owner as
> intended by the memory controller).
> 
Owner of the page should know dirty ratio, too.

> And this should be probably strictly connected to the IO controller. If
> we throttle or delay the dispatching/submission of some IO requests
> without throttling the dirty pages rate a cgroup could completely waste
> its own available memory with dirty (hard and slow to reclaim) pages.
> 
> That is in part the approach I used in io-throttle v12, adding a hook in
> balance_dirty_pages_ratelimited_nr() to throttle the current task when
> cgroup's IO limit are exceeded. Argh!
> 
> So, another proposal could be to re-add in io-throttle v14 the old hook
> also in balance_dirty_pages_ratelimited_nr().
> 
> In this way io-throttle would:
> 
> - use page_cgroup infrastructure and page_cgroup->flags to encode the
>   cgroup id that firstly dirtied a generic page
> - account and opportunely throttle sync and writeback IO requests in
>   submit_bio()
> - at the same time throttle the tasks in
>   balance_dirty_pages_ratelimited_nr() if the cgroup they belong has
>   exhausted the IO BW (or quota, share, etc. in case of proportional BW
>   limit)
> 

IMHO, io-controller should just work as I/O subsystem as bdi. Now, per-bdi dirty_ratio
is suppoted and it seems to work well.  

Can't we write a function like  bdi_writeout_fraction() ?;
It will be a simple choice.

Thanks,
-Kame

