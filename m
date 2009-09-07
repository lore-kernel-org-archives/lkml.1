Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbZIGHm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbZIGHm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZIGHm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:42:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbZIGHm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:42:28 -0400
Message-ID: <4AA4B905.8010801@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 15:40:53 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
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
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I happened to encount a bug when i test IO Controller V9.
When there are three tasks to run concurrently in three group,
that is, one is parent group, and other two tasks are running 
in two different child groups respectively to read or write 
files in some disk, say disk "hdb", The task may hang up, and 
other tasks which access into "hdb" will also hang up.

The bug only happens when using AS io scheduler.
The following scirpt can reproduce this bug in my box.

===========
#!/bin/sh

mkdir /cgroup
mount -t cgroup -o io,blkio io  /cgroup

echo anticipatory > /sys/block/hdb/queue/scheduler

mkdir /cgroup/test1
echo 100 > /cgroup/test1/io.weight

mkdir /cgroup/test2
echo 400 > /cgroup/test2/io.weight

mkdir /cgroup/test2/test3
echo 400 > /cgroup/test2/test3/io.weight

mkdir /cgroup/test2/test4
echo 400 > /cgroup/test2/test4/io.weight

#./rwio -r -f /hdb2/2000M.3 &
dd if=/hdb2/2000M.3 of=/dev/null &
pid4=$!
echo $pid4 > /cgroup/test2/test3/tasks
echo "pid4: $pid4"

#./rwio -r -f /hdb2/2000M.1 &
dd if=/hdb2/2000M.1 of=/dev/null &
pid1=$!
echo $pid1 > /cgroup/test1/tasks
echo "pid1 $pid1"

#./rwio -r -f /hdb2/2000M.2 &
dd if=/hdb2/2000M.2 of=/dev/null &
pid2=$!
echo $pid2 > /cgroup/test2/test4/tasks
echo "pid2 $pid2"

sleep 20

for ((;1;))
{
        ps -p $pid1 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
                break
        fi

        kill -9 $pid1 > /dev/null 2>&1
}
for ((;1;))
{
        ps -p $pid2 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
                break
        fi

        kill -9 $pid2 > /dev/null 2>&1
}


kill -9 $pid4 > /dev/null 2>&1

rmdir /cgroup/test2/test3
rmdir /cgroup/test2/test4
rmdir /cgroup/test2
rmdir /cgroup/test1

umount /cgroup
rmdir /cgroup

