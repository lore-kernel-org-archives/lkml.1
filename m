Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZDUQh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZDUQh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZDUQhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:37:12 -0400
Received: from thunk.org ([69.25.196.29]:40450 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZDUQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:37:11 -0400
Date: Tue, 21 Apr 2009 12:35:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
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
Message-ID: <20090421163537.GI19186@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrea Righi <righi.andrea@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org,
	baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421143130.GA22626@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 04:31:31PM +0200, Andrea Righi wrote:
> 
> Some months ago I posted a proposal to account, track and limit per
> cgroup dirty pages in the memory cgroup subsystem:
> 
> https://lists.linux-foundation.org/pipermail/containers/2008-September/013140.html
> 
> At the moment I'm reworking on a similar and updated version. I know
> that Kamezawa is also implementing something to account per cgroup dirty
> pages in memory cgroup.
> 
> Moreover, io-throttle v14 already uses the page_cgroup structure to
> encode into page_cgroup->flags the cgroup ID (io-throttle css_id()
> actually) that originally dirtied the page.
> 
> This should be enough to track dirty pages and charge the right cgroup.

I'm not convinced this will work that well.  Right now the associating
a page with a cgroup is done on a very rough basis --- basically,
whoever touches a page last "owns" the page.  That means if one
process first tries reading from the cgroup, it will "own" the page.
This can get quite arbitrary for shared libraries, for example.
However, while it may be the best that you can do for RSS accounting,
it gets worse for tracking dirties pages.

Now if you have processes from one cgroup that always reading from
some data file, and a process from another cgroup which is updating
said data file, the writes won't be charged to the correct cgroup.

So using the same data structures to assign page ownership for RSS
accounting and page dirtying accounting might not be such a great
idea.  On the other hand, using a completely different set of data
structures increases your overhead.

That being said, it's not obvious to me that trying to track RSS
ownership on a per-page basis makes sense.  It may not be worth the
overhead, particularly on a machine with a truly large amount of
memory.  So for example, tracking on a per vm_area_struct, and
splitting the cost across cgroups, might be a better way of tracking
RSS accounting.  But for dirty pages, where there will be much fewer
such pages, maybe using a per-page scheme makes more sense.  The
take-home here is that using different mechanisms for tracking RSS
accounting and dirty page accounting on a per-cgroup basis, with the
understanding that this will all be horribly rough and non-exact, may
make a lot of sense.

Best,

					- Ted
