Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbZDFWDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbZDFWDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbZDFWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:01:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760775AbZDFWA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:00:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Auhl8UHhFiab+q9D59wR4FF3zHLHbF1XQTcRd5Ljm7gRxUdLmZsS92vSocf4W3VCh
	ko5ygiFieVsjYrl+x6Y3A==
MIME-Version: 1.0
In-Reply-To: <20090406143556.GK7082@balbir.in.ibm.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	 <20090406143556.GK7082@balbir.in.ibm.com>
Date: Mon, 6 Apr 2009 15:00:50 -0700
Message-ID: <e98e18940904061500v3d29d7f3t82d4f302b5ab646a@mail.gmail.com>
Subject: Re: [PATCH 01/10] Documentation
From: Nauman Rafique <nauman@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 7:35 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-03-11 21:56:46]:
>
>> o Documentation for io-controller.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>  Documentation/block/io-controller.txt |  221 +++++++++++++++++++++++++++++++++
>>  1 files changed, 221 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/block/io-controller.txt
>>
>> diff --git a/Documentation/block/io-controller.txt b/Documentation/block/io-controller.txt
>> new file mode 100644
>> index 0000000..8884c5a
>> --- /dev/null
>> +++ b/Documentation/block/io-controller.txt
>> @@ -0,0 +1,221 @@
>> +                             IO Controller
>> +                             =============
>> +
>> +Overview
>> +========
>> +
>> +This patchset implements a proportional weight IO controller. That is one
>> +can create cgroups and assign prio/weights to those cgroups and task group
>> +will get access to disk proportionate to the weight of the group.
>> +
>> +These patches modify elevator layer and individual IO schedulers to do
>> +IO control hence this io controller works only on block devices which use
>> +one of the standard io schedulers can not be used with any xyz logical block
>> +device.
>> +
>> +The assumption/thought behind modifying IO scheduler is that resource control
>> +is needed only on leaf nodes where the actual contention for resources is
>> +present and not on intertermediate logical block devices.
>> +
>> +Consider following hypothetical scenario. Lets say there are three physical
>> +disks, namely sda, sdb and sdc. Two logical volumes (lv0 and lv1) have been
>> +created on top of these. Some part of sdb is in lv0 and some part is in lv1.
>> +
>> +                         lv0      lv1
>> +                       /     \  /     \
>> +                     sda      sdb      sdc
>> +
>> +Also consider following cgroup hierarchy
>> +
>> +                             root
>> +                             /   \
>> +                            A     B
>> +                           / \    / \
>> +                          T1 T2  T3  T4
>> +
>> +A and B are two cgroups and T1, T2, T3 and T4 are tasks with-in those cgroups.
>> +Assuming T1, T2, T3 and T4 are doing IO on lv0 and lv1. These tasks should
>> +get their fair share of bandwidth on disks sda, sdb and sdc. There is no
>> +IO control on intermediate logical block nodes (lv0, lv1).
>> +
>> +So if tasks T1 and T2 are doing IO on lv0 and T3 and T4 are doing IO on lv1
>> +only, there will not be any contetion for resources between group A and B if
>> +IO is going to sda or sdc. But if actual IO gets translated to disk sdb, then
>> +IO scheduler associated with the sdb will distribute disk bandwidth to
>> +group A and B proportionate to their weight.
>
> What if we have partitions sda1, sda2 and sda3 instead of sda, sdb and
> sdc?
>
>> +
>> +CFQ already has the notion of fairness and it provides differential disk
>> +access based on priority and class of the task. Just that it is flat and
>> +with cgroup stuff, it needs to be made hierarchical.
>> +
>> +Rest of the IO schedulers (noop, deadline and AS) don't have any notion
>> +of fairness among various threads.
>> +
>> +One of the concerns raised with modifying IO schedulers was that we don't
>> +want to replicate the code in all the IO schedulers. These patches share
>> +the fair queuing code which has been moved to a common layer (elevator
>> +layer). Hence we don't end up replicating code across IO schedulers.
>> +
>> +Design
>> +======
>> +This patchset primarily uses BFQ (Budget Fair Queuing) code to provide
>> +fairness among different IO queues. Fabio and Paolo implemented BFQ which uses
>> +B-WF2Q+ algorithm for fair queuing.
>> +
>
> References to BFQ, please. I can search them, but having them in the
> doc would be nice.
>
>> +Why BFQ?
>> +
>> +- Not sure if weighted round robin logic of CFQ can be easily extended for
>> +  hierarchical mode. One of the things is that we can not keep dividing
>> +  the time slice of parent group among childrens. Deeper we go in hierarchy
>> +  time slice will get smaller.
>> +
>> +  One of the ways to implement hierarchical support could be to keep track
>> +  of virtual time and service provided to queue/group and select a queue/group
>> +  for service based on any of the various available algoriths.
>> +
>> +  BFQ already had support for hierarchical scheduling, taking those patches
>> +  was easier.
>> +
>
> Could you elaborate, when you say timeslices get smaller -
>
> 1. Are you referring to inability to use higher resolution time?
> 2. Loss of throughput due to timeslice degradation?
>
>> +- BFQ was designed to provide tighter bounds/delay w.r.t service provided
>> +  to a queue. Delay/Jitter with BFQ is supposed to be O(1).
>> +
>> +  Note: BFQ originally used amount of IO done (number of sectors) as notion
>> +        of service provided. IOW, it tried to provide fairness in terms of
>> +        actual IO done and not in terms of actual time disk access was
>> +     given to a queue.
>
> I assume by sectors you mean the kernel sector size?
>
>> +
>> +     This patcheset modified BFQ to provide fairness in time domain because
>> +     that's what CFQ does. So idea was try not to deviate too much from
>> +     the CFQ behavior initially.
>> +
>> +     Providing fairness in time domain makes accounting trciky because
>> +     due to command queueing, at one time there might be multiple requests
>> +     from different queues and there is no easy way to find out how much
>> +     disk time actually was consumed by the requests of a particular
>> +     queue. More about this in comments in source code.
>> +
>> +So it is yet to be seen if changing to time domain still retains BFQ gurantees
>> +or not.
>> +
>> +From data structure point of view, one can think of a tree per device, where
>> +io groups and io queues are hanging and are being scheduled using B-WF2Q+
>> +algorithm. io_queue, is end queue where requests are actually stored and
>> +dispatched from (like cfqq).
>> +
>> +These io queues are primarily created by and managed by end io schedulers
>> +depending on its semantics. For example, noop, deadline and AS ioschedulers
>> +keep one io queues per cgroup and cfqq keeps one io queue per io_context in
>> +a cgroup (apart from async queues).
>> +
>
> I assume there is one io_context per cgroup.
>
>> +A request is mapped to an io group by elevator layer and which io queue it
>> +is mapped to with in group depends on ioscheduler. Currently "current" task
>> +is used to determine the cgroup (hence io group) of the request. Down the
>> +line we need to make use of bio-cgroup patches to map delayed writes to
>> +right group.
>
> That seem acceptable
>
>> +
>> +Going back to old behavior
>> +==========================
>> +In new scheme of things essentially we are creating hierarchical fair
>> +queuing logic in elevator layer and chaning IO schedulers to make use of
>> +that logic so that end IO schedulers start supporting hierarchical scheduling.
>> +
>> +Elevator layer continues to support the old interfaces. So even if fair queuing
>> +is enabled at elevator layer, one can have both new hierchical scheduler as
>> +well as old non-hierarchical scheduler operating.
>> +
>> +Also noop, deadline and AS have option of enabling hierarchical scheduling.
>> +If it is selected, fair queuing is done in hierarchical manner. If hierarchical
>> +scheduling is disabled, noop, deadline and AS should retain their existing
>> +behavior.
>> +
>> +CFQ is the only exception where one can not disable fair queuing as it is
>> +needed for provding fairness among various threads even in non-hierarchical
>> +mode.
>> +
>> +Various user visible config options
>> +===================================
>> +CONFIG_IOSCHED_NOOP_HIER
>> +     - Enables hierchical fair queuing in noop. Not selecting this option
>> +       leads to old behavior of noop.
>> +
>> +CONFIG_IOSCHED_DEADLINE_HIER
>> +     - Enables hierchical fair queuing in deadline. Not selecting this
>> +       option leads to old behavior of deadline.
>> +
>> +CONFIG_IOSCHED_AS_HIER
>> +     - Enables hierchical fair queuing in AS. Not selecting this option
>> +       leads to old behavior of AS.
>> +
>> +CONFIG_IOSCHED_CFQ_HIER
>> +     - Enables hierarchical fair queuing in CFQ. Not selecting this option
>> +       still does fair queuing among various queus but it is flat and not
>> +       hierarchical.
>> +
>> +Config options selected automatically
>> +=====================================
>> +These config options are not user visible and are selected/deselected
>> +automatically based on IO scheduler configurations.
>> +
>> +CONFIG_ELV_FAIR_QUEUING
>> +     - Enables/Disables the fair queuing logic at elevator layer.
>> +
>> +CONFIG_GROUP_IOSCHED
>> +     - Enables/Disables hierarchical queuing and associated cgroup bits.
>> +
>> +TODO
>> +====
>> +- Lots of cleanups, testing, bug fixing, optimizations, benchmarking etc...
>> +- Convert cgroup ioprio to notion of weight.
>> +- Anticipatory code will need more work. It is not working properly currently
>> +  and needs more thought.
>
> What are the problems with the code?
>
>> +- Use of bio-cgroup patches.
>
> I saw these posted as well

I have refactored the bio-cgroup patches to work on top of this patch
set, and keep track of async writes. But we have not been able to get
proportional division for async writes. The problem seems to stem from
the fact that pdflush is cgroup agnostic. Getting proportional IO
scheduling to work might need work beyond block layer. Vivek has been
able to do more testing with those patches, and can explain more.

>
>> +- Use of Nauman's per cgroup request descriptor patches.
>> +
>
> More details would be nice, I am not sure I understand

Right now, the block layer has a limit on request descriptors that can
be allocated. Once that limit is reached, a process trying to get a
request descriptor would be blocked. I wrote a patch in which I made
the request descriptor limit per cgroup, i.e a process will only be
blocked if request descriptors allocated to a give cgroup exceed a
certain limit.

This patch set is already big and we are trying to be careful to
include all the work we have done for solving the problem. So I was
planning to hold onto that patch, and send it out for comments once
the basic infrastructure gets some traction.

>
>> +HOWTO
>> +=====
>> +So far I have done very simple testing of running two dd threads in two
>> +different cgroups. Here is what you can do.
>> +
>> +- Enable hierarchical scheduling in io scheuduler of your choice (say cfq).
>> +     CONFIG_IOSCHED_CFQ_HIER=y
>> +
>> +- Compile and boot into kernel and mount IO controller.
>> +
>> +     mount -t cgroup -o io none /cgroup
>> +
>> +- Create two cgroups
>> +     mkdir -p /cgroup/test1/ /cgroup/test2
>> +
>> +- Set io priority of group test1 and test2
>> +     echo 0 > /cgroup/test1/io.ioprio
>> +     echo 4 > /cgroup/test2/io.ioprio
>> +
>
> What is the meaning of priorities? Which is higher, which is lower?
> What is the maximum? How does it impact b/w?
>
>> +- Create two same size files (say 512MB each) on same disk (file1, file2) and
>> +  launch two dd threads in different cgroup to read those files. Make sure
>> +  right io scheduler is being used for the block device where files are
>> +  present (the one you compiled in hierarchical mode).
>> +
>> +     echo 1 > /proc/sys/vm/drop_caches
>> +
>> +     dd if=/mnt/lv0/zerofile1 of=/dev/null &
>> +     echo $! > /cgroup/test1/tasks
>> +     cat /cgroup/test1/tasks
>> +
>> +     dd if=/mnt/lv0/zerofile2 of=/dev/null &
>> +     echo $! > /cgroup/test2/tasks
>> +     cat /cgroup/test2/tasks
>> +
>> +- First dd should finish first.
>> +
>> +Some Test Results
>> +=================
>> +- Two dd in two cgroups with prio 0 and 4. Ran two "dd" in those cgroups.
>> +
>> +234179072 bytes (234 MB) copied, 10.1811 s, 23.0 MB/s
>> +234179072 bytes (234 MB) copied, 12.6187 s, 18.6 MB/s
>> +
>> +- Three dd in three cgroups with prio 0, 4, 4.
>> +
>> +234179072 bytes (234 MB) copied, 13.7654 s, 17.0 MB/s
>> +234179072 bytes (234 MB) copied, 19.476 s, 12.0 MB/s
>> +234179072 bytes (234 MB) copied, 20.1858 s, 11.6 MB/s
>> --
>> 1.6.0.1
>>
>>
>
> --
>        Balbir
>
