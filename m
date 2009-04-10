Return-Path: <linux-kernel-owner+w=401wt.eu-S939131AbZDJRuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939131AbZDJRuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936531AbZDJRtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:49:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764908AbZDJRts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:49:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ackh65dtxmKfS61QVh6077zDOkBbacxl1Bba9fuQshbLXs25XPvkP/eZjLFV8Y0lt
	mDp98Tbwb9igIuer3/H4g==
MIME-Version: 1.0
In-Reply-To: <49DF1256.7080403@cn.fujitsu.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <49DF1256.7080403@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 10:49:39 -0700
Message-ID: <e98e18940904101049u6b40801dhb671081c3cf2418@mail.gmail.com>
Subject: Re: [RFC] IO Controller
From: Nauman Rafique <nauman@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:33 AM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> Hi All,
>>
>> Here is another posting for IO controller patches. Last time I had posted
>> RFC patches for an IO controller which did bio control per cgroup.
>
>  Hi Vivek,
>
>  I got the following OOPS when testing, can't reproduce again :(
>
> kernel BUG at block/elevator-fq.c:1396!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/block/hdb/queue/scheduler
> Modules linked in: ipv6 cpufreq_ondemand acpi_cpufreq dm_mirror dm_multipath sbd
> Pid: 5032, comm: rmdir Not tainted (2.6.29-rc7-vivek #17) Veriton M460
> EIP: 0060:[<c04ec7de>] EFLAGS: 00010082 CPU: 0
> EIP is at iocg_destroy+0xdc/0x14e
> EAX: 00000000 EBX: f62278b4 ECX: f6207800 EDX: f6227904
> ESI: f6227800 EDI: f62278a0 EBP: 00000003 ESP: c8790f00
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rmdir (pid: 5032, ti=c8790000 task=f6636960 task.ti=c8790000)
> Stack:
>  f53cc5c0 f62b7258 f10991c8 00000282 f6227800 c0733fa0 ec1c5140 edfc6d34
>  c8790000 c04463ce f6a4c84c edfc6d34 0804c840 c048883c f6a4c84c f6a4c84c
>  c04888d6 f6a4c84c 00000000 c04897de f6a4c84c c048504c f115f4c0 ebc37954
> Call Trace:
>  [<c04463ce>] cgroup_diput+0x41/0x8c
>  [<c048883c>] dentry_iput+0x45/0x5e
>  [<c04888d6>] d_kill+0x19/0x32
>  [<c04897de>] dput+0xd8/0xdf
>  [<c048504c>] do_rmdir+0x8f/0xb6
>  [<c06330fc>] do_page_fault+0x2a2/0x579
>  [<c0402fc1>] sysenter_do_call+0x12/0x21
>  [<c0630000>] schedule+0x641/0x830
> Code: 08 00 74 04 0f 0b eb fe 83 7f 04 00 74 04 0f 0b eb fe 45 83 c3 1c 83 fd 0
> EIP: [<c04ec7de>] iocg_destroy+0xdc/0x14e SS:ESP 0068:c8790f00

We have seen this too. And have been able to reproduce it. I did not
get a chance to fix it so far, but my understanding is that one of the
async queues was active when the cgroup was getting destroyed. We
moved it to root cgroup, but did not deactivate it; so active_entity
still points to the entity of the async queue which has now been moved
to the root cgroup. I will send an update if I can verify this, or fix
it.

>
> --
> Regards
> Gui Jianfeng
>
>
