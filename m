Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZFVPba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZFVPba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbZFVPbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:31:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbZFVPbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:31:14 -0400
Date: Mon, 22 Jun 2009 11:30:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [RFC] IO scheduler based io controller (V5)
Message-ID: <20090622153030.GA15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <20090621152116.GC3728@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090621152116.GC3728@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
> 
> > 
> > Hi All,
> > 
> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
> [snip]
> 
> > Testing
> > =======
> >
> 
> [snip]
> 
> I've not been reading through the discussions in complete detail, but
> I see no reference to async reads or aio. In the case of aio, aio
> presumes the context of the user space process. Could you elaborate on
> any testing you've done with these cases? 
> 

Hi Balbir,

So far I had not done any testing with AIO. I have done some just now.
Here are the results.

Test1 (AIO reads)
================
Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
respectively. I am using cfq scheduler. Following are some lines from my test
script.

===================================================================
fio_args="--ioengine=libaio --rw=read --size=512M"

echo 1 > /sys/block/$BLOCKDEV/queue/iosched/fairness

fio $fio_args --name=test1 --directory=/mnt/$BLOCKDEV/fio1/ --output=/mnt/$BLOCKDEV/fio1/test1.log --exec_postrun="../read-and-display-group-stats.sh $maj_dev $minor_dev" &

fio $fio_args --name=test2 --directory=/mnt/$BLOCKDEV/fio2/ --output=/mnt/$BLOCKDEV/fio2/test2.log &
===================================================================

test1 and test2 are two groups with weight 1000 and 500 respectively.
"read-and-display-group-stats.sh" is one small script which reads the
test1 and test2 cgroup files to determine how much disk time each group
got till first fio job finished.

Following are the results.

test1 statistics: time=8 16 5598   sectors=8 16 1049648 
test2 statistics: time=8 16 2908   sectors=8 16 508560

Above shows that by the time first fio (higher weight), finished, group
test1 got 5598 ms of disk time and group test2 got 2908 ms of disk time.
similarly the statistics for number of sectors transferred are also shown.

Note that disk time given to group test1 is almost double of group2 disk
time.


Test2 (AIO Wries (direct))
==========================
Set up two fio, AIO direct write jobs in two cgroup with weight 1000 and 500
respectively. I am using cfq scheduler. Following are some lines from my test
script.

===================================================================
fio_args="--ioengine=libaio --rw=write --size=512M --direct=1"

echo 1 > /sys/block/$BLOCKDEV/queue/iosched/fairness

fio $fio_args --name=test1 --directory=/mnt/$BLOCKDEV/fio1/ --output=/mnt/$BLOCKDEV/fio1/test1.log --exec_postrun="../read-and-display-group-stats.sh $maj_dev $minor_dev" &

fio $fio_args --name=test2 --directory=/mnt/$BLOCKDEV/fio2/ --output=/mnt/$BLOCKDEV/fio2/test2.log &
===================================================================

test1 and test2 are two groups with weight 1000 and 500 respectively.
"read-and-display-group-stats.sh" is one small script which reads the
test1 and test2 cgroup files to determine how much disk time each group
got till first fio job finished.

Following are the results.

test1 statistics: time=8 16 28029   sectors=8 16 1049656
test2 statistics: time=8 16 14093   sectors=8 16 512600

Above shows that by the time first fio (higher weight), finished, group
test1 got 28029 ms of disk time and group test2 got 14093 ms of disk time.
similarly the statistics for number of sectors transferred are also shown.

Note that disk time given to group test1 is almost double of group2 disk
time.

Thanks
Vivek
