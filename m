Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbXEYI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbXEYI23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXEYI2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:28:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:51902 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXEYI2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:28:21 -0400
Message-ID: <46569E23.6010101@qumranet.com>
Date: Fri, 25 May 2007 11:28:19 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lhcs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/7] KVM: Suspend and cpu hotplug fixes
References: <1180008615579-git-send-email-avi@qumranet.com> <1180055432.9919.3.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1180055432.9919.3.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 25 May 2007 11:28:19 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Thu, 2007-05-24 at 20:10 +0800, Avi Kivity wrote:
>   
>> The following patchset makes kvm more robust wrt cpu hotunplug, and
>> makes suspend-to-ram actually work.  Suspend-to-disk benefits from
>> the cpu hotunplug improvements as well.
>>
>> The major issue is that KVM wants to disable the virtualization
>> extensions at a point in time when no user processes are schedulable
>> on the victim cpu.  No current notifier exists, so a new one,
>> CPU_DYING,
>> is added for the purpose.
>>
>> Should there be no objections, I will submit this patchset for
>> inclusion
>> in 2.6.22, and backport it to 2.6.21.stable.
>>     
> Is it possible disabling kvm can be done at the begining of play_dead?
> take_cpu_done is designed to run fast.
>
>   

It's possible, but I have issues with play_dead():

- it is arch specific, so we need to modify i386, x86_64, and ia64 (when
we have an ia64 kvm port)
- there is no hook available here to call modules like the hotplug notifier

I estimate that that take_cpu_down will run for about a millisecond if
there are a few hundred vcpus which have last run on the dying cpu (and
that's an extreme case, which is not expected in normal operation).  If
that's too much, it can be reduced as follows:

- add a per-cpu list of vcpus that have last run on a cpu, maintained at
runtime
- on CPU_DOWN_PREPARE, walk the list and vmclear any vcpus that last ran
on the dying cpu
- on CPU_DYING (take_cpu_down), walk the list again an vmclear any vcpus
that managed to get scheduled to the dying vcpu again.  the list should
not have more than 1-2 entries in normal operation.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

