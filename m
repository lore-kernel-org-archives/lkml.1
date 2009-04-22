Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZDVN0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZDVN0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZDVN0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:26:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZDVN0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:26:22 -0400
Date: Wed, 22 Apr 2009 09:23:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
Message-ID: <20090422132307.GA23098@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49DF1256.7080403@cn.fujitsu.com> <20090413130958.GB18007@redhat.com> <49EE895A.1060101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE895A.1060101@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 11:04:58AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Fri, Apr 10, 2009 at 05:33:10PM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> Hi All,
> >>>
> >>> Here is another posting for IO controller patches. Last time I had posted
> >>> RFC patches for an IO controller which did bio control per cgroup.
> >>   Hi Vivek,
> >>
> >>   I got the following OOPS when testing, can't reproduce again :(
> >>
> > 
> > Hi Gui,
> > 
> > Thanks for the report. Will look into it and see if I can reproduce it.
> 
>   Hi Vivek,
> 
>   The following script can reproduce the bug in my box.
> 
> #!/bin/sh
> 
> mkdir /cgroup
> mount -t cgroup -o io io /cgroup
> mkdir /cgroup/test1
> mkdir /cgroup/test2
> 
> echo cfq > /sys/block/sda/queue/scheduler
> echo 7 > /cgroup/test1/io.ioprio
> echo 1 > /cgroup/test2/io.ioprio
> echo 1 > /proc/sys/vm/drop_caches
> dd if=1000M.1 of=/dev/null &
> pid1=$!
> echo $pid1
> echo $pid1 > /cgroup/test1/tasks
> dd if=1000M.2 of=/dev/null
> pid2=$!
> echo $pid2
> echo $pid2 > /cgroup/test2/tasks
> 
> 
> rmdir /cgroup/test1
> rmdir /cgroup/test2
> umount /cgroup
> rmdir /cgroup

Thanks Gui. We have got races with task movement and cgroup deletion. In
the original bfq patch, Fabio had implemented the logic to migrate the
task queue synchronously. It found the logic to be little complicated so I
changed it to delayed movement of queue from old cgroup to new cgroup.
Fabio later mentioned that it introduces a race where old cgroup is
deleted before task queue has actually moved to new cgroup.

Nauman is currently implementing reference counting for io groups and that
will solve this problem at the same time some other problems like movement
of queue to root group during cgroup deletion and which can potentially 
result in unfair share for some time to that queue etc.

Thanks
Vivek
