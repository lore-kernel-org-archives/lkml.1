Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYCCGYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYCCGYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYCCGYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:24:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:54350 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYCCGYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:24:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,436,1199692800"; 
   d="scan'208";a="214223647"
Subject: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked
	when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel
Date: Mon, 03 Mar 2008 02:42:09 +0800
Message-Id: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i run cpu hotplug stress test on a system with 16 logical cpus,
some processes are deadlocked, it can be regenerated on 2.6.25-rc2
and 2.6.25-rc3.

The kernel thread [watchdog/1] isn't reaped by its parent when cpu #1
is set to offline, so that [kstopmachine] sleeps for ever.

After i investigated, debugged and analyzed it, i think it is a scheduler
specific issue, i noticed someone submitted a patch which mentioned
kthread_should_stop calling rule:

"In order to safely use kthread_stop() for kthread, there is a requirement
on how its main loop has to be orginized. Namely, the sequence of
events that lead to kthread being blocked (schedule()) has to be
ordered as follows:

    set_current_state(TASK_INTERRUPTIBLE);
    if (kthread_should_stop()) break;
    schedule() or similar.

set_current_state() implies a full memory barrier. kthread_stop()
has a matching barrier right after an update of kthread_stop_info.k
and before kthread's wakeup."

I don't think it is a good programming paradigm because it will result
in some issues very easily, why can't we provide a simple wrapper for it?

This issue seems such one, but i tried to change it to follow this rule but
the issue is still there.

Why isn't the kernel thread [watchdog/1] reaped by its parent? its state
is TASK_RUNNING with high priority (R< means this), why it isn't done?

Anyone ever met such a problem? Your thought?


Here is my stress test script, you may try it on SMP platforms (the more
number of cpu is ,  the easier it can be regenerated.).

########################################################################

####### stresscpus.sh #######

#!/bin/sh

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
do
        ./bugexposure.sh $i &
done


######## bugexposure.sh ###########

#!/bin/bash

main(){

    typeset -i CPU=$1
    ./task.sh > /dev/null&
    PID=$!

    if [ `cat /sys/devices/system/cpu/cpu${CPU}/online` = "0" ]; then
        echo "1" > /sys/devices/system/cpu/cpu${CPU}/online
    fi

    MASK=$((1<<${CPU}))

    `taskset -p ${MASK} ${PID} > /dev/null 2>&1`

    echo "0" > /sys/devices/system/cpu/cpu${CPU}/online

    echo "1" > /sys/devices/system/cpu/cpu${CPU}/online

    disown $PID
    kill -9 $PID > /dev/null 2>&1

    #echo "PASS\n"

}

typeset -i TEST_CPU=$1
while true
do
        main $TEST_CPU
done


###### task.sh ######
#!/bin/bash

while :
do
  NOOP=1
done

########################################################################

My tracing and analysis info is below:

# ps aux | grep watchdog
root         5  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/0]
root         8  0.0  0.0      0     0 ?        R<   22:26   0:00 [watchdog/1]
root        11  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/2]
root        14  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/3]
root        17  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/4]
root        20  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/5]
root        23  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/6]
root        26  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/7]
root        29  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/8]
root        32  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/9]
root        35  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/10]
root        38  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/11]
root        41  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/12]
root        44  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/13]
root        50  0.0  0.0      0     0 ?        S<   22:26   0:00 [watchdog/15]
root      5641  0.0  0.0  61144   708 pts/0    R+   22:58   0:00 grep watchdog
#

# ps aux | grep ksoftirqd
root         4  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/0]
root        10  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/2]
root        13  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/3]
root        16  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/4]
root        19  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/5]
root        22  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/6]
root        25  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/7]
root        28  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/8]
root        31  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/9]
root        34  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/10]
root        37  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/11]
root        40  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/12]
root        43  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/13]
root        49  0.0  0.0      0     0 ?        S<   22:26   0:00 [ksoftirqd/15]
root      5647  0.0  0.0  61144   712 pts/0    R+   23:00   0:00 grep ksoftirqd
#

#ps aux
...
root      5554  0.0  0.0      0     0 ?        S<   22:42   0:00 [kstopmachine]
root      5556  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5557  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5558  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5559  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5560  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5561  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5562  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5563  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5564  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5565  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5566  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5567  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5568  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
root      5569  0.0  0.0      0     0 ?        Z<   22:42   0:00 [kstopmachine] <defunct>
...


[watchdog/1] isn't terminated so that [kstopmachine] will waiting for it
for ever, so that "echo 0 > /sys/devices/syste/cpu/cpu1/online" will hang
up, so that hotplug spinlock will be holden by it, so that other spinlock
contenter will wait for locking it for ever, so that...

These are some softlock detection output:

process 5471 (task.sh) no longer affine to cpu1
INFO: task group_balance:51 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
group_balance D ffff810001011580     0    51      2
 ffff81027e97fdc0 0000000000000046 ffff81027e97fdd0 ffffffff80472b15
 0000000000000000 ffff81027e97d280 ffff81027c8bd300 ffff81027e97d5d0
 0000000080569da0 ffff81027e97d5d0 000000007e97d280 000000010009d366
Call Trace:
 [<ffffffff80472b15>] thread_return+0x3d/0xa2
 [<ffffffff8023cce5>] lock_timer_base+0x26/0x4b
 [<ffffffff8047338b>] __mutex_lock_slowpath+0x5c/0x93
 [<ffffffff80473221>] mutex_lock+0x1a/0x1e
 [<ffffffff8024f8fd>] get_online_cpus+0x27/0x3e
 [<ffffffff8022fd04>] load_balance_monitor+0x60/0x375
 [<ffffffff8022fca4>] load_balance_monitor+0x0/0x375
 [<ffffffff80245ff6>] kthread+0x47/0x75
 [<ffffffff802301f0>] schedule_tail+0x28/0x5c
 [<ffffffff8020cc78>] child_rip+0xa/0x12
 [<ffffffff80245faf>] kthread+0x0/0x75
 [<ffffffff8020cc6e>] child_rip+0x0/0x12

INFO: task bugexposure.sh:5462 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bugexposure.s D ffff8100010e1580     0  5462      1
 ffff81026a981c58 0000000000000082 ffff81026a981c68 ffffffff80472b15
 00000000000004d6 ffff81027c83c920 ffff81027e8bd680 ffff81027c83cc70
 0000000d7e8bc4c0 ffff81027c83cc70 0000000d00000002 000000010009d809
Call Trace:
 [<ffffffff80472b15>] thread_return+0x3d/0xa2
 [<ffffffff80314b25>] __next_cpu+0x19/0x28
 [<ffffffff8022a5d4>] enqueue_rt_entity+0x4e/0xb1
 [<ffffffff80472f34>] schedule_timeout+0x1e/0xad
 [<ffffffff802280bf>] enqueue_task+0x4d/0x58
 [<ffffffff80472ccf>] wait_for_common+0xd5/0x118
 [<ffffffff8022c31b>] default_wake_function+0x0/0xe
 [<ffffffff80245c93>] kthread_stop+0x58/0x79
 [<ffffffff8046fdcf>] cpu_callback+0x189/0x197
 [<ffffffff8046f59e>] cpu_callback+0x1cf/0x274
 [<ffffffff8026c07e>] writeback_set_ratelimit+0x19/0x68
 [<ffffffff8047658b>] notifier_call_chain+0x29/0x4c
 [<ffffffff8024f74d>] _cpu_down+0x1d6/0x2aa
 [<ffffffff8024f845>] cpu_down+0x24/0x31
 [<ffffffff8038fcf4>] store_online+0x29/0x67
 [<ffffffff802d23e1>] sysfs_write_file+0xd2/0x110
 [<ffffffff8028db49>] vfs_write+0xad/0x136
 [<ffffffff8028e086>] sys_write+0x45/0x6e
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1



