Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZDPM2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZDPM2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZDPM2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:28:41 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:45751 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756284AbZDPM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:28:40 -0400
Date: Thu, 16 Apr 2009 21:28:36 +0900 (JST)
Message-Id: <20090416.212836.226792104.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 1/5] bio-cgroup: Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a new release of bio-cgroup which provides an IO tracking
mechanism. The patches can be applied to the kernel 2.6.30-rc1 and you
can also download them from the following site.
http://people.valinux.co.jp/~ryov/bio-cgroup/

What's bio-cgroup all about?
============================

With this feature, you can determine the owners of any type of
I/Os. This makes dm-ioband_--_I/O_bandwidth_controller_-- be able to
control the Block I/O bandwidths even when it accepts delayed write
requests. Dm-ioband can find the owner cgroup of each request. It is
also possible that the other people who work on the i/o bandwidth
throttling use this functionality to control asynchronous I/Os with a
little enhancement.

Setting up bio-cgroup
=====================

You have to apply the patch dm-ioband_v1.9.0 before applying this
series of bio-cgroup patches.
And you have to select the following config options when compiling
kernel.

      CONFIG_CGROUPS=y
      CONFIG_CGROUP_BIO=y

And I recommend you should also select the options for cgroup memory
subsystem, because it makes it possible to give some I/O bandwidth and
some memory to a certain cgroup to control delayed write requests and
the processes in the cgroup will be able to make pages dirty only
inside the cgroup even when the given bandwidth is narrow.

      CONFIG_RESOURCE_COUNTERS=y
      CONFIG_CGROUP_MEM_RES_CTLR=y

Using bio-cgroup
================

The following shows how to use dm-ioband with cgroups. Please assume
that you want make two cgroups, which we call "bio cgroup" here, to
track down block I/Os and assign them to ioband device "ioband1".

First, mount the bio cgroup filesystem.

      # mount -t cgroup -o bio none /cgroup/bio

Then, make new bio cgroups and put some processes in them.

      # mkdir /cgroup/bio/bgroup1
      # mkdir /cgroup/bio/bgroup2
      # echo 1234 > /cgroup/bio/bgroup1/tasks
      # echo 5678 > /cgroup/bio/bgroup1/tasks

Now, check the ID of each bio cgroup which is just created.

      # cat /cgroup/bio/bgroup1/bio.id
      2
      # cat /cgroup/bio/bgroup2/bio.id
      3

Finally, attach the cgroups to "ioband1" and assign them weights.

      # dmsetup message ioband1 0 type cgroup
      # dmsetup message ioband1 0 attach 2
      # dmsetup message ioband1 0 attach 3
      # dmsetup message ioband1 0 weight 2:30
      # dmsetup message ioband1 0 weight 3:60

You can also make use of the dm-ioband administration tool
iobandctl.py. You can set up the device with the tool as follows.
In this case, you don't need to know the IDs of the cgroups.

      # iobandctl.py group /dev/mapper/ioband1 cgroup \
        /cgroup/bio/bgroup1:30 /cgroup/bio/bgroup2:60
