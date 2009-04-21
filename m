Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDURr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDURr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZDURrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:47:47 -0400
Received: from thunk.org ([69.25.196.29]:57789 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZDURrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:47:46 -0400
Date: Tue, 21 Apr 2009 13:46:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Menage <menage@google.com>,
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
Message-ID: <20090421174620.GD15541@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrea Righi <righi.andrea@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
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
References: <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux> <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421172317.GM19637@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:53:17PM +0530, Balbir Singh wrote:
> Coming to the dirty page tracking issue, the issue that is being
> brought about is the same issue that we have shared page accounting. I
> am working on estimates for shared page accounting and it should be
> possible to extend it to dirty shared page accounting. Using the
> shared ratios for decisions might be a better strategy.

It's the same issue, but again, consider the use case where the
readers and the writers are in different cgroups.  This can happen
quite often in database workloads, where you might have many readers,
and a single process doing the database update.  Or the case where you
have one process in one cgroup doing a tail -f of some log file, and
another process doing writing to the log file.

Using a shared ratio is certainly better than charging 100% of the
write to whichever unfortunate process happened to first read the
page, but it will still not be terribly accurate.  A lot really
depends on how you expect these cgroup limits will be used, and what
the requirements actually will be with respect to accuracy.  If the
requirements for accuracy are different for RSS tracking and dirty
page tracking --- which could easily be the case, since memory is
usually much cheaper than I/O bandwidth, and there is generally far
more clean memory pages than there are dirty memory pages, so a small
numberical error in dirty page accounting translates to a much larger
percentage error than read-only RSS page accounting --- it may make
sense to use different mechanisms for tracking the two, given the
different requirements and differring overhead implications.

Anyway, something for you to think about.

Regards,

						- Ted
