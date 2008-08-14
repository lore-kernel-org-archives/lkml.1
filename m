Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYHND0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYHND0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 23:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYHNDZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 23:25:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46197
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbYHNDZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 23:25:58 -0400
Date: Wed, 13 Aug 2008 20:25:59 -0700 (PDT)
Message-Id: <20080813.202559.193705172.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: console handover badness
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808130845290.8416@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
	<20080812.184052.193693538.davem@davemloft.net>
	<Pine.LNX.4.64.0808130845290.8416@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 13 Aug 2008 08:46:37 -0400 (EDT)

> On Tue, 12 Aug 2008, David Miller wrote:
> 
> > Mikulas can you send me the .config you're using in 2.6.27 to trigger
> > this?
> > 
> > Thanks.
> 
> Here it is. The computer is Ultra 5 with 512MB RAM.

Thanks, I've tried a lot of things to try and reproduce this myself but to
no avail.

Let's try to track down exactly where the corruption happens.  Please try
the debug patch below on your box.  It will spit out a message something
like:

[    0.000000] BUG: Bogus migrate type 5
[    0.000000] BUG: Usemap for section 0 corrupted at sparse_init+0x17c/0x218[mm/sparse.c:498]

The theory is that some other piece of code is either not allocating a large
enough buffer or overwriting past the end of a validly sized other buffer
for some reason, and thus clobbering this pageblock flags bitmap.

Wherever this debugging check first triggers should give us some idea
of who the culprit might be.

diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index 217de3e..26b018f 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1643,6 +1643,8 @@ void __init setup_per_cpu_areas(void)
 {
 }
 
+extern void sparse_validate_usemap(const char *file, int line);
+
 void __init paging_init(void)
 {
 	unsigned long end_pfn, shift, phys_base;
@@ -1788,7 +1790,9 @@ void __init paging_init(void)
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	max_mapnr = last_valid_pfn;
 #endif
+	sparse_validate_usemap(__FILE__, __LINE__);
 	kernel_physical_mapping_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 
 	{
 		unsigned long max_zone_pfns[MAX_NR_ZONES];
@@ -1798,12 +1802,15 @@ void __init paging_init(void)
 		max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
 		free_area_init_nodes(max_zone_pfns);
+		sparse_validate_usemap(__FILE__, __LINE__);
 	}
 
 	printk("Booting Linux...\n");
 
 	central_probe();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	cpu_probe();
+	sparse_validate_usemap(__FILE__, __LINE__);
 }
 
 int __init page_in_phys_avail(unsigned long paddr)
diff --git a/init/main.c b/init/main.c
index 0bc7e16..80771f5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -536,6 +536,8 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
+extern void sparse_validate_usemap(const char *file, int line);
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -567,12 +569,19 @@ asmlinkage void __init start_kernel(void)
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 	setup_arch(&command_line);
+	sparse_validate_usemap(__FILE__, __LINE__);
 	mm_init_owner(&init_mm, &init_task);
+	sparse_validate_usemap(__FILE__, __LINE__);
 	setup_command_line(command_line);
+	sparse_validate_usemap(__FILE__, __LINE__);
 	unwind_setup();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	setup_per_cpu_areas();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	setup_nr_cpu_ids();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
+	sparse_validate_usemap(__FILE__, __LINE__);
 
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
@@ -580,35 +589,52 @@ asmlinkage void __init start_kernel(void)
 	 * time - but meanwhile we still have a functioning scheduler.
 	 */
 	sched_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	/*
 	 * Disable preemption - early bootup scheduling is extremely
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
 	build_all_zonelists();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	page_alloc_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+	sparse_validate_usemap(__FILE__, __LINE__);
 	if (!irqs_disabled()) {
 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
 	sort_main_extable();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	trap_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	rcu_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	init_IRQ();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	pidhash_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	init_timers();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	hrtimers_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	softirq_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	timekeeping_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	time_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	sched_clock_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	profile_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	if (!irqs_disabled())
 		printk("start_kernel(): bug: interrupts were enabled early\n");
 	early_boot_irqs_on();
@@ -620,10 +646,12 @@ asmlinkage void __init start_kernel(void)
 	 * this. But we do want output early, in case something goes wrong.
 	 */
 	console_init();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	if (panic_later)
 		panic(panic_later, panic_param);
 
 	lockdep_info();
+	sparse_validate_usemap(__FILE__, __LINE__);
 
 	/*
 	 * Need to run this when irqs are enabled, because it wants
@@ -631,6 +659,7 @@ asmlinkage void __init start_kernel(void)
 	 * too:
 	 */
 	locking_selftest();
+	sparse_validate_usemap(__FILE__, __LINE__);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
@@ -643,7 +672,9 @@ asmlinkage void __init start_kernel(void)
 	}
 #endif
 	vfs_caches_init_early();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	cpuset_init_early();
+	sparse_validate_usemap(__FILE__, __LINE__);
 	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
diff --git a/mm/sparse.c b/mm/sparse.c
index 5d9dbbb..116559c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -262,6 +262,52 @@ unsigned long usemap_size(void)
 	return size_bytes;
 }
 
+#if 1
+static int check_one_blockval(unsigned long *bitmap, unsigned long off, unsigned long nbits)
+{
+	unsigned long i, value = 1, flags = 0;
+
+	for (i = 0; i < nbits; i++, value <<= 1)
+		if (test_bit(off + i, bitmap))
+			flags |= value;
+
+	if (flags >= MIGRATE_TYPES) {
+		printk(KERN_ERR "BUG: Bogus migrate type %lu\n", flags);
+		return 1;
+	}
+	return 0;
+}
+
+void sparse_validate_usemap(const char *file, int line)
+{
+	void *caller = __builtin_return_address(0);
+	unsigned long size = usemap_size();
+	unsigned long pnum;
+	static int reported = 0;
+
+	if (reported)
+		return;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		unsigned long *bitmap;
+		unsigned long off;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		bitmap = ms->pageblock_flags;
+		for (off = 0; off < size; off += 3) {
+			if (check_one_blockval(bitmap, off, 3)) {
+				printk(KERN_ERR "BUG: Usemap for section %lu corrupted at %pS[%s:%d]\n",
+				       pnum, caller, file, line);
+				reported = 1;
+				break;
+			}
+		}
+	}
+}
+#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long *__kmalloc_section_usemap(void)
 {
@@ -445,10 +491,16 @@ void __init sparse_init(void)
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
 	}
+#if 1
+	sparse_validate_usemap(__FILE__, __LINE__);
+#endif
 
 	vmemmap_populate_print_last();
 
 	free_bootmem(__pa(usemap_map), size);
+#if 1
+	sparse_validate_usemap(__FILE__, __LINE__);
+#endif
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
