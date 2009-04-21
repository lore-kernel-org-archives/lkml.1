Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZDUAVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZDUAVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZDUAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:21:31 -0400
Received: from THUNK.ORG ([69.25.196.29]:33981 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZDUAVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:21:30 -0400
Date: Mon, 20 Apr 2009 20:18:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
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
Message-ID: <20090421001822.GB19186@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
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
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417143903.GA30365@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 04:39:05PM +0200, Andrea Righi wrote:
> 
> Exactly, the purpose here is is to prioritize the dispatching of journal
> IO requests in the IO controller. I may have used an inappropriate flag
> or a quick&dirty solution, but without this, any cgroup/process that
> generates a lot of journal activity may be throttled and cause other
> cgroups/processes to be incorrectly blocked when they try to write to
> disk.

With ext3 and ext4, all journal I/O requests end up going through
kjournald.  So the question is what I/O control group do you put
kjournald in?  If you unrestrict it, it makes the problem go away
entirely.  On the other hand, it is doing work on behalf of other
processes, and there is no real way to separate out on whose behalf
kjournald is doing said work.  So I'm not sure fundamentally you'll be
able to do much with any filesystem journalling activity --- and ext3
makes life especially bad because of data=ordered mode. 

> > I'm assuming it's the "usual" problem with lower priority IO getting
> > access to fs exclusive data. It's quite trivial to cause problems with
> > higher IO priority tasks then getting stuck waiting for the low priority
> > process, since they also need to access that fs exclusive data.
> 
> Right. I thought about using the BIO_RW_SYNC flag instead, but as Ted
> pointed out, some cgroups/processes might be able to evade the IO
> control issuing a lot of fsync()s. We could also limit the fsync()-rate
> into the IO controller, but it sounds like a dirty workaround...

Well, if you use data=writeback or Chris Mason's proposed data=guarded
mode, then at least all of the data blocks will be written process
context of the application, and not kjournald's process context.  So
one solution that might be the best that we have for now is to treat
kjournald as special from an I/O controller point of view (i.e., give
it its own cgroup), and then use a filesystem mode which avoids data
blocks getting written in kjournald (i.e., ext3 data=wirteback or
data=guarded, ext4's delayed allocation, etc.)

One major form of leakage that you're still going to have is pdflush;
which again, is more I/O happening in somebody else's process context.
Ultimately I think trying to throttle I/O at write submission time
whether at entry into block layer or in the elevators, is going to be
highly problematic.  Suppose someone dirties a large number of pages?
That's a system resource, and delaying the writes because a particular
container has used more than its fair share will cause the entire
system to run out of memory, which is not a good thing.

Ultimately, I think you'll need to do is write throttling, and suspend
processes that are dirtying too many pages, instad of trying to
control the I/O.

					- Ted
