Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbYLXIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbYLXIKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 03:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYLXIJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 03:09:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:60096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYLXIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 03:09:55 -0500
Message-ID: <4951EE20.5080004@kernel.org>
Date: Wed, 24 Dec 2008 00:09:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: parsing mem=700M broken
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com> <20081223143327.GF29151@elte.hu> <200812241808.16195.rusty@rustcorp.com.au>
In-Reply-To: <200812241808.16195.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 24 December 2008 01:03:27 Ingo Molnar wrote:
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On Mon, Dec 22, 2008 at 7:06 PM, Hugh Dickins <hugh@veritas.com> wrote:
>>>> Hi Rusty,
>>>>
>>>> I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
>>>> and have bisected it down to your patch below; but now I'm off to bed
>>>> without working out just what goes wrong (I'll bet it's the "=").
> 
> Thanks for the report and analysis.
> 
>> Rusty, will you fix or revert it?
> 
> mem= is actually easy, memmap= is harder.  This is tested and pushed.
> 
> This commit is actually orthogonal to the other changes, but makes most
> sense I think in the bootparam tree.
> 
> commit b69cab1078c69a568afdd2eb8ee6f8559b769e2c
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Dec 24 18:04:19 2008 +1030
> 
>     Fix mem= and memmap= parsing: now it happens *before* e820 setup.
>     
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 7aafeb5..cab24a6 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -37,6 +37,8 @@
>   * copied. It doesn't get modified afterwards. It's registered for the
>   * /sys/firmware/memmap interface.
>   *
> + * user_e820, exactmap and memlimit are set on cmdline by mem= and memmap=.
> + *
>   * That memory map is not modified and is used as base for kexec. The kexec'd
>   * kernel should get the same memory map as the firmware provides. Then the
>   * user can e.g. boot the original kernel with mem=1G while still booting the
> @@ -44,6 +46,9 @@
>   */
>  struct e820map e820;
>  struct e820map e820_saved;
> +static struct e820map user_e820 __initdata;
> +static bool exactmap __initdata;
> +static u64 memlimit __initdata;
>  
>  /* For PCI or other memory-mapped resources */
>  unsigned long pci_mem_start = 0xaeedbabe;
> @@ -107,22 +112,28 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
>  	return 0;
>  }
>  
> -/*
> - * Add a memory region to the kernel e820 map.
> - */
> -void __init e820_add_region(u64 start, u64 size, int type)
> +static void __init __e820_add_region(struct e820map *e820,
> +				     u64 start, u64 size, int type)
>  {
> -	int x = e820.nr_map;
> +	int x = e820->nr_map;
>  
> -	if (x == ARRAY_SIZE(e820.map)) {
> +	if (x == ARRAY_SIZE(e820->map)) {
>  		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
>  		return;
>  	}
>  
> -	e820.map[x].addr = start;
> -	e820.map[x].size = size;
> -	e820.map[x].type = type;
> -	e820.nr_map++;
> +	e820->map[x].addr = start;
> +	e820->map[x].size = size;
> +	e820->map[x].type = type;
> +	e820->nr_map++;
> +}
> +
> +/*
> + * Add a memory region to the kernel e820 map.
> + */
> +void __init e820_add_region(u64 start, u64 size, int type)
> +{
> +	__e820_add_region(&e820, start, size, type);
>  }
>  
>  void __init e820_print_map(char *who)
> @@ -1173,13 +1184,9 @@ static void early_panic(char *msg)
>  	panic(msg);
>  }
>  
> -static int userdef __initdata;
> -
>  /* "mem=nopentium" disables the 4MB page tables. */
>  static int __init parse_memopt(char *p)
>  {
> -	u64 mem_size;
> -
>  	if (!p)
>  		return -EINVAL;
>  
> @@ -1190,10 +1197,7 @@ static int __init parse_memopt(char *p)
>  	}
>  #endif
>  
> -	userdef = 1;
> -	mem_size = memparse(p, &p);
> -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> -
> +	memlimit = memparse(p, &p);
>  	return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -1207,16 +1211,7 @@ static int __init parse_memmap_opt(char *p)
>  		return -EINVAL;
>  
>  	if (!strncmp(p, "exactmap", 8)) {
> -#ifdef CONFIG_CRASH_DUMP
> -		/*
> -		 * If we are doing a crash dump, we still need to know
> -		 * the real mem size before original memory map is
> -		 * reset.
> -		 */
> -		saved_max_pfn = e820_end_of_ram_pfn();
> -#endif
> -		e820.nr_map = 0;
> -		userdef = 1;
> +		exactmap = true;
>  		return 0;
>  	}
>  
> @@ -1225,18 +1220,18 @@ static int __init parse_memmap_opt(char *p)
>  	if (p == oldp)
>  		return -EINVAL;
>  
> -	userdef = 1;
>  	if (*p == '@') {
>  		start_at = memparse(p+1, &p);
> -		e820_add_region(start_at, mem_size, E820_RAM);
> +		__e820_add_region(&user_e820, start_at, mem_size, E820_RAM);
>  	} else if (*p == '#') {
>  		start_at = memparse(p+1, &p);
> -		e820_add_region(start_at, mem_size, E820_ACPI);
> +		__e820_add_region(&user_e820, start_at, mem_size, E820_ACPI);
>  	} else if (*p == '$') {
>  		start_at = memparse(p+1, &p);
> -		e820_add_region(start_at, mem_size, E820_RESERVED);
> +		__e820_add_region(&user_e820, start_at, mem_size,
> +				  E820_RESERVED);
>  	} else
> -		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> +		memlimit = mem_size;
>  
>  	return *p == '\0' ? 0 : -EINVAL;
>  }
> @@ -1244,6 +1239,33 @@ early_param("memmap", parse_memmap_opt);
>  
>  void __init finish_e820_parsing(void)
>  {
> +	bool userdef;
> +	int i;
> +
> +	if (memlimit) {
> +		e820_remove_range(memlimit, ULLONG_MAX - memlimit, E820_RAM, 1);
> +		userdef = true;
> +	}
> +
> +	if (exactmap) {
> +#ifdef CONFIG_CRASH_DUMP
> +		/*
> +		 * If we are doing a crash dump, we still need to know
> +		 * the real mem size before original memory map is
> +		 * reset.
> +		 */
> +		saved_max_pfn = e820_end_of_ram_pfn();
> +#endif
> +		e820.nr_map = 0;
> +		userdef = true;
> +	}
> +
> +	for (i = 0; i < user_e820.nr_map; i++) {
> +		e820_add_region(user_e820.map[i].addr, user_e820.map[i].size,
> +				user_e820.map[i].type);
> +		userdef = true;
> +	}
> +
>  	if (userdef) {
>  		int nr = e820.nr_map;
>  

looks good.

for cpu caps on boot cpu setup still need

could be in tip your tree.

---

[PATCH] x86: clean up setup_clear/force_cpu_cap handling

Impact: fix and cleanup

setup_force_cpu_cap() only have one user xen
but it should not reuse cleared_cpu_cpus. it will have problem
for smp.

need to have cpu_cpus_set array too.
also need to setup handling before all cpus cap AND

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 arch/x86/include/asm/processor.h  |    3 ++-
 arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
 3 files changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h
+++ linux-2.6/arch/x86/include/asm/cpufeature.h
@@ -190,11 +190,11 @@ extern const char * const x86_power_flag
 #define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
 #define setup_clear_cpu_cap(bit) do { \
 	clear_cpu_cap(&boot_cpu_data, bit);	\
-	set_bit(bit, (unsigned long *)cleared_cpu_caps); \
+	set_bit(bit, (unsigned long *)cpu_caps_cleared); \
 } while (0)
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, (unsigned long *)cleared_cpu_caps);	\
+	set_bit(bit, (unsigned long *)cpu_caps_set);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -134,7 +134,8 @@ extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
 extern struct tss_struct	doublefault_tss;
-extern __u32			cleared_cpu_caps[NCAPINTS];
+extern __u32			cpu_caps_cleared[NCAPINTS];
+extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -221,7 +221,8 @@ static char __cpuinit *table_lookup_mode
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
@@ -706,6 +707,16 @@ static void __cpuinit identify_cpu(struc
 #endif
 
 	init_hypervisor(c);
+
+	/*
+	 * Clear/Set all flags overriden by options, need do it
+	 * before following smp all cpus cap AND.
+	 */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -718,10 +729,6 @@ static void __cpuinit identify_cpu(struc
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);


---
could be put in next:

[PATCH] x86: update boot_cpu x86 cap according in early_identify_cpu

Impact: fix

early_param is moved more earlier. So need to update boot_cpu_data x86 cap
in early_identify_cpu() to make sure that is right.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/common.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -552,6 +552,16 @@ static void __init early_identify_cpu(st
 	if (this_cpu->c_early_init)
 		this_cpu->c_early_init(c);
 
+	/*
+	 * Clear/Set all flags overriden by options, need do it
+	 * because early_param is done before early_cpu_init now.
+	 * We can get boot_cpu_data.x86_capability right.
+	 */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 	validate_pat_support(c);
 
 #ifdef CONFIG_SMP
