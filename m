Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZCMTre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZCMTre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZCMTrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:47:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbZCMTrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:47:24 -0400
Message-ID: <49BAB7FF.4030107@kernel.org>
Date: Fri, 13 Mar 2009 12:46:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>, mingo@elte.hu
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
References: <49B9BA5A.40108@kernel.org>	 <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>	 <1236958403.2646.1.camel@ht.satnam> <1236959121.2646.3.camel@ht.satnam>
In-Reply-To: <1236959121.2646.3.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Fri, 2009-03-13 at 21:03 +0530, Jaswinder Singh Rajput wrote:
>> On Fri, 2009-03-13 at 02:34 +0000, Yinghai Lu wrote:
>>> Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
>>> Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
>>> Author:     Yinghai Lu <yinghai@kernel.org>
>>> AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
>>> Commit:     Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Fri, 13 Mar 2009 02:52:18 +0100
>>>
>>> x86: more MTRR debug printouts
>>>
>>> Impact: improve MTRR debugging messages
>>>
>>> There's still inefficiencies suspected with the MTRR sanitizing
>>> code, so make sure we get all the info we need from a dmesg.
>>>
>>> - Remove unneeded mtrr_show
>>>
>>>  (It will only printout one time by first cpu, so it is no big deal.)
>>>
>>> - Also print out directly from get_mtrr, because it doesn't update mtrr_state.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> LKML-Reference: <49B9BA5A.40108@kernel.org>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>
>>>
>>>  		*base = 0;
>>> @@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>>>  	*size = -mask_lo;
>>>  	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
>>>  	*type = base_lo & 0xff;
>>> +
>>> +	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
>>> +			smp_processor_id(), reg, *base, *size,
>>> +			mtrr_attrib_to_str(*type & 0xff));
>>>  }
>>>  
>> This leads to:
>>
>> Kernel failure message 1:
>> BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
>> caller is generic_get_mtrr+0x12a/0x146
>> Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
>> 13 20:43:36 IST 2009
>> Call Trace:
>>  [<c0412cc3>] ? printk+0x14/0x16
>>  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
>>  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
>>  [<c010e351>] mtrr_add_page+0x154/0x332
>>  [<c010e7b1>] mtrr_file_add+0x72/0x86
>>  [<c010e9e0>] mtrr_ioctl+0x21b/0x309
>>  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
>>  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
>>  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
>>  [<c0194101>] vfs_ioctl+0x27/0x6e
>>  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
>>  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
>>  [<c01898b0>] ? fget_light+0x40/0x130
>>  [<c01946ee>] sys_ioctl+0x34/0x61
>>  [<c0102c73>] sysenter_do_call+0x12/0x25
>>

please check

[PATCH] x86: fix get_mtrr warning about smp_processor_id with preempt

Impact: fix warning

Jaswinder noticed that there is warning about smp_processor_id() in get_mtrr

try to fix it by use disable/enable to wrap it.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -381,14 +381,18 @@ static void generic_get_mtrr(unsigned in
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
+	int cpu;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
 	 * from any cpu, so try to print it out directly.
 	 */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
 	if ((mask_lo & 0x800) == 0) {
+		preempt_enable();
 		/*  Invalid (i.e. free) range  */
 		*base = 0;
 		*size = 0;
@@ -397,6 +401,7 @@ static void generic_get_mtrr(unsigned in
 	}
 
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
+	preempt_enable();
 
 	/* Work out the shifted address mask. */
 	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
@@ -419,7 +424,7 @@ static void generic_get_mtrr(unsigned in
 	*type = base_lo & 0xff;
 
 	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
-			smp_processor_id(), reg, *base, *size,
+			cpu, reg, *base, *size,
 			mtrr_attrib_to_str(*type & 0xff));
 }
 
