Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYIXKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYIXKMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYIXKMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:12:36 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37349 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbYIXKMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:12:35 -0400
Date: Wed, 24 Sep 2008 19:12:34 +0900 (JST)
Message-Id: <20080924.191234.104048747.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
Subject: [PATCH 3/8] bio-cgroup: Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080924.191204.71103350.ryov@valinux.co.jp>
References: <20080924.191059.193698894.ryov@valinux.co.jp>
	<20080924.191135.226787109.ryov@valinux.co.jp>
	<20080924.191204.71103350.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this series of bio-cgruop patches, you can determine the owners of any
type of I/Os and it makes dm-ioband -- I/O bandwidth controller --
be able to control the Block I/O bandwidths even when it accepts
delayed write requests.
Dm-ioband can find the owner cgroup of each request.
It is also possible that the other people who work on the I/O
bandwidth throttling use this functionality to control asynchronous
I/Os with a little enhancement.

You have to apply the patch dm-ioband v1.6.0 before applying this series
of patches.

And you have to select the following config options when compiling kernel:
  CONFIG_CGROUPS=y
  CONFIG_CGROUP_BIO=y
And I recommend you should also select the options for cgroup memory
subsystem, because it makes it possible to give some I/O bandwidth
and some memory to a certain cgroup to control delayed write requests
and the processes in the cgroup will be able to make pages dirty only
inside the cgroup even when the given bandwidth is narrow.
  CONFIG_RESOURCE_COUNTERS=y
  CONFIG_CGROUP_MEM_RES_CTLR=y

This code is based on some part of the memory subsystem of cgroup
and I don't think the accuracy and overhead of the subsystem can be ignored
at this time, so we need to keep tuning it up.

 --------------------------------------------------------

The following shows how to use dm-ioband with cgroups.
Please assume that you want make two cgroups, which we call "bio cgroup"
here, to track down block I/Os and assign them to ioband device "ioband1".

First, mount the bio cgroup filesystem.

 # mount -t cgroup -o bio none /cgroup/bio

Then, make new bio cgroups and put some processes in them.

 # mkdir /cgroup/bio/bgroup1
 # mkdir /cgroup/bio/bgroup2
 # echo 1234 > /cgroup/bio/bgroup1/tasks
 # echo 5678 > /cgroup/bio/bgroup1/tasks

Now, check the ID of each bio cgroup which is just created.

 # cat /cgroup/bio/bgroup1/bio.id
   1
 # cat /cgroup/bio/bgroup2/bio.id
   2

Finally, attach the cgroups to "ioband1" and assign them weights.

 # dmsetup message ioband1 0 type cgroup
 # dmsetup message ioband1 0 attach 1
 # dmsetup message ioband1 0 attach 2
 # dmsetup message ioband1 0 weight 1:30
 # dmsetup message ioband1 0 weight 2:60

You can also make use of the dm-ioband administration tool if you want.
The tool will be found here:
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/manual.html
You can set up the device with the tool as follows.
In this case, you don't need to know the IDs of the cgroups.

 # iobandctl.py group /dev/mapper/ioband1 cgroup /cgroup/bio/bgroup1:30 /cgroup/bio/bgroup2:60
