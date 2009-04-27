Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZD0LM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZD0LM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZD0LMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:12:16 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:56846 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775AbZD0LMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:12:16 -0400
Date: Mon, 27 Apr 2009 20:12:14 +0900 (JST)
Message-Id: <20090427.201214.39166983.ryov@valinux.co.jp>
To: baramsori72@gmail.com
Cc: righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband
 supporting the predicable I/O bandwidth (range bandwidth)
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <2891419e0904270158n71b25271p6094feba70d0555d@mail.gmail.com>
References: <2891419e0904230210w40482535ma3fc25c1e429969d@mail.gmail.com>
	<20090424.185823.104059944.ryov@valinux.co.jp>
	<2891419e0904270158n71b25271p6094feba70d0555d@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong-Jae,

> I wonder your test configuration and environment.
> Your result  is some strange for me, because I didn't use the testing tool, fio.
> I have used xdd, bonnie++ and tiobench during the test.
> 
> So, I will try to evaluate range-bw using fio, to do that, I need to
> know your configuration and basic environment in briefly
> if it don't bother you, can you give me the information?

I used fio 1.22. The below is a script which I actually ran.

  #!/bin/sh
  dev1=/dev/sdb4 # SATA disk
  echo "0 $(sudo blockdev --getsize $dev1) ioband $dev1 share2 0 0
    cgroup range-bw 0" | sudo dmsetup create ioband1

  arg="--time_based --runtime=10 --ioengine=libaio --iodepth=50 \
       --direct=1 --norandommap"

  dmsetup message ioband1 0 attach 2
  dmsetup message ioband1 0 attach 3
  dmsetup message ioband1 0 min-bw 2:100
  dmsetup message ioband1 0 max-bw 2:100
  dmsetup message ioband1 0 min-bw 3:200
  dmsetup message ioband1 0 max-bw 3:200

  echo $$ > /cgroup/grp1/tasks
  fio $arg --rw=randread --name=grp1 --filename=/dev/mapper/ioband1 \
          --output=r2-1.log &
  echo $$ > /cgroup/grp2/tasks
  fio $arg --rw=randread --name=grp2 --filename=/dev/mapper/ioband1 \
          --output=r2-2.log &
  wait

Please feel free to ask me if you need more information.
 
> and I attached the result of basic evaluation of range-bw using xdd
> 6.5.(Test Result for range-bw_english.pdf)
> it was performed to evaluate the basic functionalities in one process per group.

Thanks.

> actually, more evaluation is need in specfic envinronment like as
> massive I/O by huge processes in each group.
> and it is going on now

I'm look forward to seeing the results.

Thanks,
Ryo Tsuruta
