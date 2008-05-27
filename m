Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYE0Wb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYE0Wb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbYE0WbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:31:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbYE0WbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:31:17 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5304"; a="3445237"
Message-ID: <483C8BA6.8090309@qualcomm.com>
Date: Tue, 27 May 2008 15:31:02 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: mingo@elte.hu
CC: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] [sched] Fixed CPU hotplug and sched domain handling
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com> <1211926006-11559-2-git-send-email-maxk@qualcomm.com>
In-Reply-To: <1211926006-11559-2-git-send-email-maxk@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> First issue is that we're leaking doms_cur. It's allocated in
> arch_init_sched_domains() which is called for every hotplug event.
> So we just keep reallocation doms_cur without freeing it.
> I introduced free_sched_domains() function that cleans things up.
> 
> Second issue is that sched domains created by the cpusets are
> completely destroyed by the CPU hotplug events. For all CPU hotplug
> events scheduler attaches all CPUs to the NULL domain and then puts
> them all into the single domain thereby destroying domains created
> by the cpusets (partition_sched_domains).
> The solution is simple, when cpusets are enabled scheduler should not
> create default domain and instead let cpusets do that. Which is
> exactly what the patch does.

Here is more info on this, with debug logs.

Here is initial cpuset setup.
cpus 0-3 balanced, cpus 4-7 non-balanced

cd /dev/cgroup
echo 0 > cpusets.sched_load_balance
mkdir boot
echo 0-3 > boot/cpusets.cpus
echo 1   > boot/cpusets.sched_load_balance
...

-----
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
CPU7 attaching NULL sched-domain.
CPU0 attaching sched-domain:
  domain 0: span 0f
   groups: 01 02 04 08
CPU1 attaching sched-domain:
  domain 0: span 0f
   groups: 02 04 08 01
CPU2 attaching sched-domain:
  domain 0: span 0f
   groups: 04 08 01 02
CPU3 attaching sched-domain:
  domain 0: span 0f
   groups: 08 01 02 04
-----

Looks good so far.
Now lets bring cpu7 offline (echo 0 > /sys/devices/system/cpu/cpu7/online)

-----
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
CPU7 attaching NULL sched-domain.
CPU 7 is now offline
CPU0 attaching sched-domain:
  domain 0: span 11
   groups: 01 10
   domain 1: span 7f
    groups: 11 22 44 08
CPU1 attaching sched-domain:
  domain 0: span 22
   groups: 02 20
   domain 1: span 7f
    groups: 22 44 08 11
CPU2 attaching sched-domain:
  domain 0: span 44
   groups: 04 40
   domain 1: span 7f
    groups: 44 08 11 22
CPU3 attaching sched-domain:
  domain 0: span 7f
   groups: 08 11 22 44
CPU4 attaching sched-domain:
  domain 0: span 11
   groups: 10 01
   domain 1: span 7f
    groups: 11 22 44 08
CPU5 attaching sched-domain:
  domain 0: span 22
   groups: 20 02
   domain 1: span 7f
    groups: 22 44 08 11
CPU6 attaching sched-domain:
  domain 0: span 44
   groups: 40 04
   domain 1: span 7f
    groups: 44 08 11 22
----

All cpus are now in the single domain.
Same thing happens when cpu7 comes back online.

----
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 4655.39 BogoMIPS (lpj=9310785)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#3 -> CPU#7]: passed.
CPU0 attaching sched-domain:
  domain 0: span 11
   groups: 01 10
   domain 1: span ff
    groups: 11 22 44 88
CPU1 attaching sched-domain:
  domain 0: span 22
   groups: 02 20
   domain 1: span ff
    groups: 22 44 88 11
CPU2 attaching sched-domain:
  domain 0: span 44
   groups: 04 40
   domain 1: span ff
    groups: 44 88 11 22
CPU3 attaching sched-domain:
  domain 0: span 88
   groups: 08 80
   domain 1: span ff
    groups: 88 11 22 44
CPU4 attaching sched-domain:
  domain 0: span 11
   groups: 10 01
   domain 1: span ff
    groups: 11 22 44 88
CPU5 attaching sched-domain:
  domain 0: span 22
   groups: 20 02
   domain 1: span ff
    groups: 22 44 88 11
CPU6 attaching sched-domain:
  domain 0: span 44
   groups: 40 04
   domain 1: span ff
    groups: 44 88 11 22
CPU7 attaching sched-domain:
  domain 0: span 88
   groups: 80 08
   domain 1: span ff
    groups: 88 11 22 44
----

As if cpusets do not exist :).
With the patch we now do the right thing when cpus go off/online.

----
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
CPU7 attaching NULL sched-domain.
CPU0 attaching sched-domain:
  domain 0: span 0f
   groups: 01 02 04 08
CPU1 attaching sched-domain:
  domain 0: span 0f
   groups: 02 04 08 01
CPU2 attaching sched-domain:
  domain 0: span 0f
   groups: 04 08 01 02
CPU3 attaching sched-domain:
  domain 0: span 0f
   groups: 08 01 02 04

CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
CPU7 attaching NULL sched-domain.
CPU0 attaching sched-domain:
  domain 0: span 0f
   groups: 01 02 04 08
CPU1 attaching sched-domain:
  domain 0: span 0f
   groups: 02 04 08 01
CPU2 attaching sched-domain:
  domain 0: span 0f
   groups: 04 08 01 02
CPU3 attaching sched-domain:
  domain 0: span 0f
   groups: 08 01 02 04
CPU 7 is now offline

CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU2 attaching NULL sched-domain.
CPU3 attaching NULL sched-domain.
CPU4 attaching NULL sched-domain.
CPU5 attaching NULL sched-domain.
CPU6 attaching NULL sched-domain.
CPU0 attaching sched-domain:
  domain 0: span 0f
   groups: 01 02 04 08
CPU1 attaching sched-domain:
  domain 0: span 0f
   groups: 02 04 08 01
CPU2 attaching sched-domain:
  domain 0: span 0f
   groups: 04 08 01 02
CPU3 attaching sched-domain:
  domain 0: span 0f
   groups: 08 01 02 04
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 4655.37 BogoMIPS (lpj=9310749)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#3 -> CPU#7]: passed.

Max
