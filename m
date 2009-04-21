Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZDUSPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZDUSPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZDUSPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:15:23 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44005 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZDUSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:15:22 -0400
Date: Tue, 21 Apr 2009 23:44:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Andrea Righi <righi.andrea@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
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
Message-ID: <20090421181429.GO19637@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux> <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090421174620.GD15541@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Tso <tytso@mit.edu> [2009-04-21 13:46:20]:

> On Tue, Apr 21, 2009 at 10:53:17PM +0530, Balbir Singh wrote:
> > Coming to the dirty page tracking issue, the issue that is being
> > brought about is the same issue that we have shared page accounting. I
> > am working on estimates for shared page accounting and it should be
> > possible to extend it to dirty shared page accounting. Using the
> > shared ratios for decisions might be a better strategy.
> 
> It's the same issue, but again, consider the use case where the
> readers and the writers are in different cgroups.  This can happen
> quite often in database workloads, where you might have many readers,
> and a single process doing the database update.  Or the case where you
> have one process in one cgroup doing a tail -f of some log file, and
> another process doing writing to the log file.
> 

That would be true in general, but only the process writing to the
file will dirty it. So dirty already accounts for the read/write
split. I'd assume that the cost is only for the dirty page, since we
do IO only on write in this case, unless I am missing something very
obvious.

> Using a shared ratio is certainly better than charging 100% of the
> write to whichever unfortunate process happened to first read the
> page, but it will still not be terribly accurate.  A lot really
> depends on how you expect these cgroup limits will be used, and what
> the requirements actually will be with respect to accuracy.  If the
> requirements for accuracy are different for RSS tracking and dirty
> page tracking --- which could easily be the case, since memory is
> usually much cheaper than I/O bandwidth, and there is generally far
> more clean memory pages than there are dirty memory pages, so a small
> numberical error in dirty page accounting translates to a much larger
> percentage error than read-only RSS page accounting --- it may make
> sense to use different mechanisms for tracking the two, given the
> different requirements and differring overhead implications.
>
> Anyway, something for you to think about.

Yep, but I would recommend using the controller we have, if the
overheads span out to be too large for IO, we think about
alternatives.

-- 
	Balbir
