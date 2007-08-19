Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXHSKzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXHSKzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 06:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXHSKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 06:55:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:51987 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXHSKzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 06:55:01 -0400
Message-ID: <46C82191.90300@qumranet.com>
Date: Sun, 19 Aug 2007 13:55:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
References: <20070810134140.2806b587@localhost>	<6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com> <20070813134237.23f4b5a1@localhost> <46C05017.3050806@qumranet.com>
In-Reply-To: <46C05017.3050806@qumranet.com>
Content-Type: multipart/mixed;
 boundary="------------080108090808040004090202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108090808040004090202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Avi Kivity wrote:
> Paolo Ornati wrote:
>> On Fri, 10 Aug 2007 14:04:33 +0200
>> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>>
>>  
>>>> [  756.707601] Disabling non-boot CPUs ...
>>>> [  756.712034] kvm: disabling virtualization on CPU1
>>>> [  756.712037] WARNING: at arch/x86_64/kernel/smp.c:379 
>>>> smp_call_function_single()
>>>> [  756.712039]
>>>> [  756.712039] Call Trace:
>>>> [  756.712046]  [<ffffffff8021d159>] 
>>>> smp_call_function_single+0x119/0x120
>>>> [  756.712050]  [<ffffffff80542169>] thread_return+0x1bf/0x626
>>>> [  756.712054]  [<ffffffff80234b5b>] sys_sched_yield+0x2b/0x80
>>>> [  756.712057]  [<ffffffff8043684b>] kvm_cpu_hotplug+0x4b/0xa0
>>>> [  756.712060]  [<ffffffff80247c83>] notifier_call_chain+0x53/0x80
>>>> [  756.712062]  [<ffffffff80247d09>] 
>>>> __raw_notifier_call_chain+0x9/0x10
>>>> [  756.712065]  [<ffffffff80247d21>] raw_notifier_call_chain+0x11/0x20
>>>> [  756.712068]  [<ffffffff8026184b>] take_cpu_down+0x1b/0x30
>>>> [  756.712071]  [<ffffffff802699d2>] do_stop+0xd2/0x150
>>>> [  756.712073]  [<ffffffff80269900>] do_stop+0x0/0x150
>>>> [  756.712076]  [<ffffffff8024f84d>] kthread+0x4d/0x80
>>>> [  756.712079]  [<ffffffff8020cb28>] child_rip+0xa/0x12
>>>> [  756.712081]  [<ffffffff8020c23c>] restore_args+0x0/0x30
>>>> [  756.712084]  [<ffffffff8024f800>] kthread+0x0/0x80
>>>> [  756.712086]  [<ffffffff8020cb1e>] child_rip+0x0/0x12
>>>> [  756.712087]
>>>> [  756.815693] CPU 1 is now offline
>>>> [  756.815697] lockdep: not fixing up alternatives.
>>>> [  756.819276] CPU1 is down
>>>>  
>>>>       
>>> Added to KR list, thanks for the report.
>>>     
>>
>>
>> I've bisected it down to this commit:
>>
>> cec9ad279b66793bee0b5009b7ca311060061efd
>>
>>     KVM: Use CPU_DYING for disabling virtualization
>>         Only at the CPU_DYING stage can we be sure that no user 
>> process will
>>     be scheduled onto the cpu and oops when trying to use virtualization
>>     extensions.
>>
>>   
>
> Thanks.  I'll have a go at it.
>
>

Sorry about the delay -- here is the fairly simple patch.  A Tested-by: 
would be appreciated.


-- 
error compiling committee.c: too many arguments to function


--------------080108090808040004090202
Content-Type: text/x-patch;
 name="0001-KVM-Avoid-calling-smp_call_function_single-with-i.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-KVM-Avoid-calling-smp_call_function_single-with-i.patch"

>From a8c346b28695b938018f4bafd458f6d3e70c36e3 Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 19 Aug 2007 13:51:00 +0300
Subject: [PATCH] KVM: Avoid calling smp_call_function_single() with interrupts disabled

When taking a cpu down, we need to hardware_disable() it.  Unfortunately,
the CPU_DYING notifier is called with interrupts disabled, which means
we can't use smp_call_function_single().  Fortunately, the CPU_DYING notifier
is always called on the dying cpu, so we don't need to use the function at
all and can simply call hardware_disable() directly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9685609..cd05579 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2974,6 +2974,10 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	switch (val) {
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
+		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
+		       cpu);
+		hardware_disable(NULL);
+		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
-- 
1.5.2.4


--------------080108090808040004090202--
