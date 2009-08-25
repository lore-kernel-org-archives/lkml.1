Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZHYA16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZHYA16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZHYA16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:27:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:43016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZHYA15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:27:57 -0400
Message-ID: <4A932FD7.5030000@kernel.org>
Date: Mon, 24 Aug 2009 17:27:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org>
In-Reply-To: <4A932809.1000103@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Ravikiran G Thirumalai wrote:
>> 2.6.31-rc7 does not boot on vSMPowered systems.  The sched domains
>> seem to build incorrectly with error messages of the sort:
>>
>> [    8.501108] CPU31: Thermal monitoring enabled (TM1)
>> [    8.501127] CPU 31 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
>> [    8.650254] CPU31: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz
>> stepping 04
>> [    8.710324] Brought up 32 CPUs
>> [    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
>> [    8.721489] ERROR: parent span is not a superset of domain->span
>> [    8.727686] ERROR: domain->groups does not contain CPU0
>> [    8.733091] ERROR: groups don't span domain->span
>> [    8.737975] ERROR: domain->cpu_power not set
>> [    8.742416]
>>
>> This is followed by oopsen in the scheduler code
>> with NULL pointer deference in find_busiest_group.
>>
>> Git bisection pointed to the following commit:
>>
>> commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c
>> x86: don't call read_apic_id if !cpu_has_apic
>>
>> Upon examining the history of the commit, the above commit seems to be a fix
>> for:
>>
>> commit 4797f6b021a3fa399942245d07a1feb30df81bb8
>> x86: read apic ID in the !acpi_lapic case
>>
>> However, there appears to be bug in the commit
>> 2759c3287de27266e06f1f4e82cbd2d65f6a044c, where flat_phys_pkg_id
>> uses initial apic id instead of hard_smp_processor_id() on SMP machines.
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2759c3287de27266e06f1f4e82cbd2d65f6a044c
>>
>> This patch fixes the bug and causes vSMPowered systems to boot up
>> correctly,

can you check if this one fix your problem?

BTW: what does your /proc/cpuinfo print about apic id and initial apic id?

[PATCH] x86: use read_apic_id to get apic id

and leave phys_proc_id to use initial apic id.

---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -715,7 +715,7 @@ static void __cpuinit generic_identify(s
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
-		c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+		c->apicid = read_apic_id();
 # else
 		c->apicid = c->initial_apicid;
 # endif
@@ -772,7 +772,7 @@ static void __cpuinit identify_cpu(struc
 	}
 
 #ifdef CONFIG_X86_64
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = read_apic_id();
 #endif
 
 	/*

