Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbYKLITu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYKLITu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYKLITm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:19:42 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40763 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYKLITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:19:41 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>
Cc: "'Hirokazu Takahashi'" <taka@valinux.co.jp>, <balbir@linux.vnet.ibm.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>, <menage@google.com>,
       "SUGAWARA Tomoyoshi" <tom-sugawara@ap.jp.nec.com>
Subject: [PATCH][RFC][12+2][v3] A expanded CFQ scheduler for cgroups
Date: Wed, 12 Nov 2008 17:15:06 +0900
Message-ID: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/w==
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset expands traditional CFQ scheduler in order to support cgroups,
and improves old version.

Improvements are as following.

 * Modularizing our new CFQ scheduler.
      The expanded CFQ scheduler is registered/unregistered as new I/O 
    elevator scheduler called "cfq-cgroups".  By this, the traditional CFQ
    scheduler, which does not handle cgroups, and our new CFQ scheduler, which
    handles cgroups, can be used at the same time for different devices.

 * Allowing to set parameter per device.
      The expanded CFQ scheduler allows users to set parameter per device.
    By this, users can decide share (priority) per device.

--- Optional functions ---

 * Adding a validation flag for 'think time'. (Opt-1 patch)
      CFQ show poor scalability.  One of its causes is the think time.
    The think time is used to improve the I/O performance by handling queues
    with poor I/O as IDLE class.  However, when many tasks have I/O requests,
    think time for their tasks became long and then all queues are handled as
    IDLE class.  As a result, dispatching I/O requests is dispersed, and then
    the I/O performance falls.  The think time valid flag controls think time
    judgment.

 * Adding ioprio class for cgroups. (Opt-2 patch)
      The previous expanded CFQ scheduler can not implement ioprio class.
    This optional patch implements its proto-type.  This patch gives a basic
    service tree control for ioprio class of cgroups and does not give preempt
    function, completed function and so on yet.



1.  Introduction.

This patchset introduce "Yet Another" I/O bandwidth controlling
subsystem for cgroups based on CFQ (called 2 layer CFQ).

The idea of 2 layer CFQ is to build fairness control per group on the top of
existing CFQ control.
We added a new data structure called CFQ driver data on the top of
cfqd in order to control I/O bandwidth for cgroups.
CFQ driver data control cfq_datas by service tree (rb-tree) and
CFQ algorithm when synchronous I/O.
An active cfqd controls queue for cfq by service tree.
Namely, the CFQ meta-data control traditional CFQ data.
the CFQ data runs conventionally.

           cfqdd     cfqdd     (cfqmd = cfq driver data)
            |          |
  cfqc  -- cfqd ----- cfqd     (cfqd = cfq data,
            |          |        cfqc = cfq cgroup data)
  cfqc  --[cfqd]----- cfqd
            ^
            |
        conventional control.

This patchset is against 2.6.28-rc2


2. Build 

 i. Apply this patchset (series 01 - 12) to kernel 2.6.28-rc2.

     If you want to use optional functions, apply opt-1/opt-2 patches
   to kernel 2.6.28-rc2.

 ii. Build kernel with IOSCHED_CFQ_CGROUP=y option.

 iii. Restart new kernel.


3. Usage of 2 layer CFQ

* Preparation for using 2 layer CFQ

 i. Mount cfq_cgroup special device to device directory.
    ex.
      mkdir /dev/cgroup
      mount -t cgroup -o cfq cfq /dev/cgroup

 ii. Change elevator scheduler for device to "cfq-cgroups"
    ex.
      echo cfq-cgorups  > /sys/block/sda/queue/scheduler


* Usage of grouping control.
 - Create a new group.
      Make a new directory under /dev/cgroup.
      For example, the following command generates a 'test1' group.
          mkdir /dev/cgroup/test1

 - Insert a task to a group.
      Write process id(pid) on "tasks" entry in the corresponding group.
      For example, the following command sets task with pid 1100 into test1
     group.
         echo 1100 > /dev/cgroup/test1/tasks
   
      New child tasks of this task is also inserted into test1 group.

 - Change I/O priorities of a group.
      Write priority on "cfq.ioprio" entry in the corresponding group.
      For example, the following command sets priority of rank 2 to 'test1'
     group.

          echo 2 > /dev/cgroup/test1/cfq.ioprio

      I/O priority for cgroups takes the value from 0 to 7. It is same as
     existing per-task CFQ.

      If you want to change only I/O priority of a specific device and group,
     add its device name as a second parameter.
      For example, the following command sets priority of rank 2 to 'test1'
     group for 'sda' device.

          echo 2 sda > /dev/cgroup/test1/cfq.ioprio

      
      If you want to change I/O priority of a specific device and group via
     sysfs.  If you can change its priority, Add its path for cgroup as a
     second parameter.
      For example, the following command sets priority of rank 2 to 'test1'
     group for 'sda' device via sysfs. 
      
          echo 2 /test1 > /sys/block/sda/queue/iosched/ioprio 

       If you can change parameters of cfq_data (slice_sync, back_seek_penalty
      and so on) for a specific device and group.
       If you write only one parameter via sysfs, its setting reflects all
      groups.

       If you set elevator scheduler as cfq-cgroups, I/O priorities of its
      new device set a default priority with groups.  If you want to change
      this default priority, write priority and "default" as second parameter 
      on "cfq.ioprio" entry in the corresponding group.
       For example, 

          echo 2 default > /dev/cgroup/test1/cfq.ioprio
      
 - Change I/O priority of task
     Use existing "ionice" command.


4. Usage of Optional Functions.

 i. Usage of a validation flag for 'think time'
    
   This parameter can use via sysfs as similar as other cfq data parameter.
   Its entry name is 'ttime_valid'.

   This flag is decide to check think time.
     The value 0 is always handled queues as idle class.
        In practice, idie_window flag is clear.
     The value 1 is handled as same as traditional CFQ.
     The value 2 makes the think time invalid.


 ii. Usage of ioprio class for cgroups. 

   The ioprio class use via cgroupfs as similar as ioprio.
   Its entry name is 'cfq.ioprio_class'

   The values of ioprio class are as same as I/O class of traditional CFQ.
     0: IOPRIO_CLASS_NONE (is equal to IOPRIO_CLASS_BE)
     1: IOPRIO_CLASS_RT   
     2: IOPRIO_CLASS_BE
     3: IOPRIO_CLASS_IDLE


5. Future work.
 We must implement the follows.
 * Handle buffered I/O.

