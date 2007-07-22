Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbXGVPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbXGVPoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXGVPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:06 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXGVPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:user-agent:date:from:to:subject;
        b=BuO7OEVZ48ejKAuV9mhBG4+eFLa8XeUlmzM0PFpf7j3K3E2vkgr67Q+0zwXA5VJ6DMtOXn6y5uAAfa4imZ/vCQaq+xAicYmrxDPZ99gI5IyX+nZaokFticd/F1xtgx4NCCN3H663XsI+RAcVSv9XBvSEuQyQOMfCx3RhtqCXSKM=
Message-Id: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/9] CPU hotplug error handling fixes take2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes the error handling for cpu hotplug.
The problem is revealed by CPU hotplug/unplug test with fault-injection.

The changes from previous patchset:

- Removed the patch titled sysfs: avoid kmem_cache_free(NULL)
  Because it was merged into mainline.

- Removed the patch titled sysdev: add error check in sysdev_register()
  It turned out that the patch needs more fixes for microcode and
  cpufreq. So I'll separate them from this series of patches.

- Added slab fix noticed by Gautham R Shenoy

The series of patches:

[patch 1/9] slab: cleanup cpuup_callback()
[patch 2/9] slab: fix memory leak in cpu hotplug error path
[patch 3/9] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks
            with CPU_UP_PREPARE
[patch 4/9] topology: remove topology_dev_map
[patch 5/9] thermal_throttle: fix cpu hotplug error handling
[patch 6/9] msr: fix cpu hotplug error handling
[patch 7/9] cpuid: fix cpu hotplug error handling
[patch 8/9] mce: fix cpu hotplug error handling
[patch 9/9] intel_cacheinfo: fix cpu hotplug error handling

The patch 1/9 factors out some code from cpuup_callback() to simplify
what the patch 2/9 does.

The patch 2/9 fixes memory leak in allocation failure path. Also it
avoids the memory leak that will be introduced by the patch 3/9.

The patch 3/9 changes the behavior when one of the callbacks in notifier
chain returns NOTIFY_BAD with CPU_UP_PREPARE event. This change makes
cpu hotplug error handling simple.

The patch 4/9 simplifies the cpu hotplug event handling in topology.c
enabled by the patch 3/9.

The patch 5-9/9 are cpu hotplug error handling fixes in drivers.
Mainly these patches shift some callbacks from CPU_ONLINE to CPU_UP_PREPARE.

CPU hotplug/unplug test script:

----------[ cut here ]----------

#!/bin/bash

FAILTYPE=failslab
CPU=1
CPU_ONLINE=/sys/devices/system/cpu/cpu${CPU}/online

faulty_system()
{
	bash -c "echo 1 > /proc/self/make-it-fail && exec $*"
}

[ "$UID" == 0 ] || exit 1
[ -n "$FAILTYPE" -a -f /debug/$FAILTYPE/probability ] || exit 1
[ -f $CPU_ONLINE ] || exit 1

echo N > /debug/$FAILTYPE/ignore-gfp-wait
echo Y > /debug/$FAILTYPE/task-filter
echo 1 > /debug/$FAILTYPE/probability
echo -1 > /debug/$FAILTYPE/times

while true
do
	faulty_system "echo 0 > $CPU_ONLINE"
	faulty_system "echo 1 > $CPU_ONLINE"
done
