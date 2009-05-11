Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZEKRoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZEKRoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZEKRog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:44:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:51714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZEKRof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:44:35 -0400
Message-ID: <4A0863C5.9070206@kernel.org>
Date: Mon, 11 May 2009 10:43:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org> <20090511110234.GH4648@elte.hu> <20090511134140.GH4624@lenovo> <20090511134950.GA949@elte.hu>
In-Reply-To: <20090511134950.GA949@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> [Ingo Molnar - Mon, May 11, 2009 at 01:02:34PM +0200]
>> | 
>> | * tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:
>> | 
>> | > Commit-ID:  4401da6111ac58f94234417427d06a72c4048c74
>> | > Gitweb:     http://git.kernel.org/tip/4401da6111ac58f94234417427d06a72c4048c74
>> | > Author:     Yinghai Lu <yinghai@kernel.org>
>> | > AuthorDate: Sat, 2 May 2009 10:40:57 -0700
>> | > Committer:  Ingo Molnar <mingo@elte.hu>
>> | > CommitDate: Mon, 11 May 2009 11:29:23 +0200
>> | > 
>> | > x86: read apic ID in the !acpi_lapic case
>> | > 
>> | > Ed found that on 32-bit, boot_cpu_physical_apicid is not read right,
>> | > when the mptable is broken.
>> | 
>> | -tip testing found that this patch causes a kernel crash:
>> | 
>> | [    1.208000] initcall pci_iommu_init+0x0/0x11 returned 0 after 0 usecs
>> | [    1.212000] calling  print_all_ICs+0x0/0x62a @ 1
>> | [    1.216000] 
>> | [    1.216000] printing PIC contents
>> | [    1.220000] ... PIC  IMR: fffa
>> | [    1.220000] ... PIC  IRR: 0000
>> | [    1.224000] ... PIC  ISR: 0000
>> | [    1.228000] ... PIC ELCR: 0828
>> | [    1.232000] BUG: unable to handle kernel paging request at ffffb020
>> | [    1.232000] IP: [<78417d5c>] native_apic_mem_read+0x15/0x19
>> | [    1.232000] *pde = 010ef067 *pte = 00000000 
>> | [    1.232000] Oops: 0000 [#1] PREEMPT 
>> | [    1.232000] last sysfs file: 
>> | [    1.232000] Modules linked in:
>> | [    1.232000] 
>> | [    1.232000] Pid: 1, comm: swapper Not tainted (2.6.30-rc5-tip #40847) System Product Name
>> | [    1.232000] EIP: 0060:[<78417d5c>] EFLAGS: 00010046 CPU: 0
>> | [    1.232000] EIP is at native_apic_mem_read+0x15/0x19
>> | [    1.232000] EAX: ffffb020 EBX: 00000000 ECX: 00000000 EDX: fffff000
>> | [    1.232000] ESI: 00000000 EDI: 7908c52e EBP: 9786fd38 ESP: 9786fd38
>> | [    1.232000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> | [    1.232000] Process swapper (pid: 1, ti=9786e000 task=97870000 task.ti=9786e000)
>> | [    1.232000] Stack:
>> | [    1.232000]  9786fd40 78416e0d 9786fd48 78416fad 9786fd64 7908c55f 00000001 00000000
>> | [    1.232000]  00000000 00000000 7908c52e 9786fd78 784671bf 00000001 00000000 00000000
>> | [    1.232000]  9786fdac 7908ca42 00000001 9786fda0 784551ad 00000001 00000000 487ab0fc
>> | [    1.232000] Call Trace:
>> | [    1.232000]  [<78416e0d>] ? read_apic_id+0x19/0x24
>> | [    1.232000]  [<78416fad>] ? hard_smp_processor_id+0xd/0xf
>> | [    1.232000]  [<7908c55f>] ? print_local_APIC+0x31/0x3c7
>> | [    1.232000]  [<7908c52e>] ? print_local_APIC+0x0/0x3c7
>> | [    1.232000]  [<784671bf>] ? smp_call_function_single+0x5b/0x64
>> | [    1.232000]  [<7908ca42>] ? print_all_ICs+0x14d/0x62a
>> | [    1.232000]  [<784551ad>] ? ktime_get+0x16/0x34
>> | [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
>> | [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
>> | [    1.232000]  [<7840107f>] ? _stext+0x7f/0x1f2
>> | [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
>> | [    1.232000]  [<784afae4>] ? page_count+0x22/0x3f
>> | [    1.232000]  [<784b1c0a>] ? get_page_from_freelist+0x51f/0x6b0
>> | [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
>> | [    1.232000]  [<784dcbee>] ? check_object+0x207/0x252
>> | [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
>> | [    1.232000]  [<784dd5c5>] ? __slab_free+0x11a/0x4af
>> | [    1.232000]  [<784df012>] ? kmem_cache_free+0xce/0x163
>> | [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
>> | [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
>> | [    1.232000]  [<786bb75f>] ? ida_pre_get+0x13/0x18b
>> | [    1.232000]  [<7853f384>] ? proc_register+0x32a/0x34e
>> | [    1.232000]  [<7853f5bd>] ? create_proc_entry+0xf0/0x119
>> | [    1.232000]  [<7847e0bc>] ? register_irq_proc+0x87/0xbb
>> | [    1.232000]  [<7908251b>] ? kernel_init+0x8d/0x10a
>> | [    1.232000]  [<7908248e>] ? kernel_init+0x0/0x10a
>> | [    1.232000]  [<78403ee7>] ? kernel_thread_helper+0x7/0x10
>> | [    1.232000] Code: 44 00 00 89 d1 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff 89 08 5d c3 55 89 e5 0f 1f 44 00 00 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff <8b> 00 5d c3 55 89 e5 0f 1f 44 00 00 89 c2 eb 02 f3 90 8b 02 85 
>> | [    1.232000] EIP: [<78417d5c>] native_apic_mem_read+0x15/0x19 SS:ESP 0068:9786fd38
>> | [    1.232000] CR2: 00000000ffffb020
>> | [    1.232000] ---[ end trace a7919e7f17c0a725 ]---
>> | [    1.232000] Kernel panic - not syncing: Fatal exception
>> | 
>> | 	Ingo
>>
>> Ingo, could check if the following do the trick?
>> (on top of 
>>
>> 	commit f6271becbae641903a9f703b7b75cccb202df82a
>> 	Merge: 486cb6c 0498625
>> 	Author: Ingo Molnar <mingo@elte.hu>
>> 	Date:   Mon May 11 12:26:00 2009 +0200
>>
>> 	    Merge branch 'tracing/core'
>> )
>>
>>
>> 	-- Cyrill
>> ---
>>
>> x86: apic - fixmap apic address even if apic disabled
>>
>> In case if apic were disabled by boot option
>> we still need read_apic operation. So fixmap
>> a fake apic area if needed.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> ---
>>  arch/x86/kernel/apic/apic.c |   17 +++++++++--------
>>  1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
>> =====================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
>> +++ linux-2.6.git/arch/x86/kernel/apic/apic.c
>> @@ -1591,13 +1591,6 @@ void __init init_apic_mappings(void)
>>  	} else
>>  		apic_phys = mp_lapic_addr;
>>  
>> -	/* lets check if we may NOP'ify apic operations */
>> -	if (!cpu_has_apic) {
>> -		pr_info("APIC: disable apic facility\n");
>> -		apic_disable();
>> -		return;
>> -	}
>> -
>>  	/*
>>  	 * acpi lapic path already maps that address in
>>  	 * acpi_register_lapic_address()
>> @@ -1606,7 +1599,15 @@ void __init init_apic_mappings(void)
>>  		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
>>  
>>  	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
>> -				APIC_BASE, apic_phys);
>> +			APIC_BASE, apic_phys);
>> +
>> +	/* lets check if we may NOP'ify apic operations */
>> +	if (!cpu_has_apic) {
>> +		pr_info("APIC: disable apic facility\n");
>> +		apic_disable();
>> +		return;
>> +	}
>> +
> 
> Will check this - thanks.
> 

please check this one instead.

[PATCH] x86: add native_apic_read_dummy

when apic is not used ( not there, or disable_apic ), try to install
dummy read too.

could save 4k in that case.

[ Impact: fix bug when try to dump APIC reg ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>

---
 arch/x86/include/asm/smp.h     |    2 -
 arch/x86/kernel/apic/apic.c    |   45 ++++++++++++++++++++---------------------
 arch/x86/kernel/apic/io_apic.c |    5 ++++
 3 files changed, 28 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -243,17 +243,24 @@ static int modern_apic(void)
  * bare function to substitute write operation
  * and it's _that_ fast :)
  */
-void native_apic_write_dummy(u32 reg, u32 v)
+static void native_apic_write_dummy(u32 reg, u32 v)
 {
 	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
 }
 
+static u32 native_apic_read_dummy(u32 reg)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	return 0;
+}
+
 /*
  * right after this call apic->write doesn't do anything
  * note that there is no restore operation it works one way
  */
 void apic_disable(void)
 {
+	apic->read = native_apic_read_dummy;
 	apic->write = native_apic_write_dummy;
 }
 
@@ -1580,33 +1587,25 @@ void __init init_apic_mappings(void)
 		return;
 	}
 
-	/*
-	 * If no local APIC can be found then set up a fake all
-	 * zeroes page to simulate the local APIC and another
-	 * one for the IO-APIC.
-	 */
+	/* If no local APIC can be found return early */
 	if (!smp_found_config && detect_init_APIC()) {
-		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
-		apic_phys = __pa(apic_phys);
-	} else
-		apic_phys = mp_lapic_addr;
-
-	/* lets check if we may NOP'ify apic operations */
-	if (!cpu_has_apic) {
+		/* lets NOP'ify apic operations */
 		pr_info("APIC: disable apic facility\n");
 		apic_disable();
-		return;
-	}
+	} else {
+		apic_phys = mp_lapic_addr;
 
-	/*
-	 * acpi lapic path already maps that address in
-	 * acpi_register_lapic_address()
-	 */
-	if (!acpi_lapic)
-		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+		/*
+		 * acpi lapic path already maps that address in
+		 * acpi_register_lapic_address()
+		 */
+		if (!acpi_lapic)
+			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+
+		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
+					APIC_BASE, apic_phys);
+	}
 
-	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-				APIC_BASE, apic_phys);
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1847,6 +1847,11 @@ __apicdebuginit(void) print_PIC(void)
 __apicdebuginit(int) print_all_ICs(void)
 {
 	print_PIC();
+
+	/* don't print out if apic is not there */
+	if (!cpu_has_apic || disable_apic)
+		return 0;
+
 	print_all_local_APICs();
 	print_IO_APIC();
 
Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -180,7 +180,7 @@ extern int safe_smp_processor_id(void);
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
+	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 }
 
 #endif
