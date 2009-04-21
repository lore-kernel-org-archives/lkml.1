Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZDUTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZDUTPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZDUTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:15:31 -0400
Received: from thunk.org ([69.25.196.29]:33501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZDUTPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:15:30 -0400
Date: Tue, 21 Apr 2009 15:14:01 -0400
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
Message-ID: <20090421191401.GF15541@mit.edu>
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
References: <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux> <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421181429.GO19637@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 11:44:29PM +0530, Balbir Singh wrote:
> 
> That would be true in general, but only the process writing to the
> file will dirty it. So dirty already accounts for the read/write
> split. I'd assume that the cost is only for the dirty page, since we
> do IO only on write in this case, unless I am missing something very
> obvious.

Maybe I'm missing something, but the (in development) patches I saw
seemed to use the existing infrastructure designed for RSS cost
tracking (which is also not yet in mainline, unless I'm mistaken ---
but I didn't see page_get_page_cgroup() in the mainline tree yet).

Right?  So if process A in cgroup A reads touches the file first by
reading from it, then the pages read by process A will be assigned as
being "owned" by cgroup A.   Then when the patch described at

      http://lkml.org/lkml/2008/9/9/245

... tries to charge a write done by process B in cgroup B, the code
will call page_get_page_cgroup(), see that it is "owned" by cgroup A,
and charge the dirty page to cgroup A.  If process A and all of the
other processes in cgroup A only access this file read-only, and
process B is updating this file very heavily --- and it is a large
file --- then cgroup B will get a completely free pass as far as
dirtying pages to this file, since it will be all charged 100% to
cgroup A, incorrectly.

So what am I missing?

						- Ted
