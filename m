Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZIHNzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZIHNzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZIHNzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZIHNzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:55:43 -0400
Date: Tue, 8 Sep 2009 09:53:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [RFC] IO scheduler based IO controller V9
Message-ID: <20090908135352.GC15974@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA4B905.8010801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA4B905.8010801@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 03:40:53PM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> I happened to encount a bug when i test IO Controller V9.
> When there are three tasks to run concurrently in three group,
> that is, one is parent group, and other two tasks are running 
> in two different child groups respectively to read or write 
> files in some disk, say disk "hdb", The task may hang up, and 
> other tasks which access into "hdb" will also hang up.
> 
> The bug only happens when using AS io scheduler.
> The following scirpt can reproduce this bug in my box.
> 

Thanks for the testing it out Gui. I will run this test case on my machine
and see if I can reproduce this issue on my box and try to fix it.

Is your box completely hung or IO scheduler don't seem to be doing
anything. Can you try to swith the io scheduler to something else (after
it appears to be hung), and see if switch is successful and new scheduler
starts working?

Thanks
Vivek

> ===========
> #!/bin/sh
> 
> mkdir /cgroup
> mount -t cgroup -o io,blkio io  /cgroup
> 
> echo anticipatory > /sys/block/hdb/queue/scheduler
> 
> mkdir /cgroup/test1
> echo 100 > /cgroup/test1/io.weight
> 
> mkdir /cgroup/test2
> echo 400 > /cgroup/test2/io.weight
> 
> mkdir /cgroup/test2/test3
> echo 400 > /cgroup/test2/test3/io.weight
> 
> mkdir /cgroup/test2/test4
> echo 400 > /cgroup/test2/test4/io.weight
> 
> #./rwio -r -f /hdb2/2000M.3 &
> dd if=/hdb2/2000M.3 of=/dev/null &
> pid4=$!
> echo $pid4 > /cgroup/test2/test3/tasks
> echo "pid4: $pid4"
> 
> #./rwio -r -f /hdb2/2000M.1 &
> dd if=/hdb2/2000M.1 of=/dev/null &
> pid1=$!
> echo $pid1 > /cgroup/test1/tasks
> echo "pid1 $pid1"
> 
> #./rwio -r -f /hdb2/2000M.2 &
> dd if=/hdb2/2000M.2 of=/dev/null &
> pid2=$!
> echo $pid2 > /cgroup/test2/test4/tasks
> echo "pid2 $pid2"
> 
> sleep 20
> 
> for ((;1;))
> {
>         ps -p $pid1 > /dev/null 2>&1
>         if [ $? -ne 0 ]; then
>                 break
>         fi
> 
>         kill -9 $pid1 > /dev/null 2>&1
> }
> for ((;1;))
> {
>         ps -p $pid2 > /dev/null 2>&1
>         if [ $? -ne 0 ]; then
>                 break
>         fi
> 
>         kill -9 $pid2 > /dev/null 2>&1
> }
> 
> 
> kill -9 $pid4 > /dev/null 2>&1
> 
> rmdir /cgroup/test2/test3
> rmdir /cgroup/test2/test4
> rmdir /cgroup/test2
> rmdir /cgroup/test1
> 
> umount /cgroup
> rmdir /cgroup
