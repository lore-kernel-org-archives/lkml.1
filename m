Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbZCPWed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbZCPWed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZCPWeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:34:24 -0400
Received: from www.tglx.de ([62.245.132.106]:56523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZCPWeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:34:23 -0400
Date: Mon, 16 Mar 2009 23:33:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup 20090317
In-Reply-To: <1237229111.2827.2.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903162128010.29264@localhost.localdomain>
References: <1237229111.2827.2.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:

I think I made it entirely clear that blindly adding comments to
#endif / #else constructs is not what is considered a useful change.

> +static void early_init_intel_fam15(void)
> +{
> +#ifdef CONFIG_KMEMCHECK
> +	u64 misc_enable;
> +
> +	rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +	if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> +		pr_info("kmemcheck: Disabling fast string operations\n");
> +
> +		misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> +		wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +	}
> +#endif /* CONFIG_KMEMCHECK */
> +}

  Useless

>  #ifdef CONFIG_X86_64
>  	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
> -#else
> +#else /* CONFIG_X86_64 */
>  	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
>  	if (c->x86 == 15 && c->x86_cache_alignment == 64)
>  		c->x86_cache_alignment = 128;
> -#endif
> +#endif /* CONFIG_X86_64 */

  Annoying.
  
>  
>  #ifdef CONFIG_X86_32
> @@ -125,9 +131,11 @@ int __cpuinit ppro_with_ram_bug(void)
>  	    boot_cpu_data.x86 == 6 &&
>  	    boot_cpu_data.x86_model == 1 &&
>  	    boot_cpu_data.x86_mask < 8) {
> -		printk(KERN_INFO "Pentium Pro with Errata#50 detected. Taking evasive action.\n");
> +		pr_info("Pentium Pro with Errata#50 detected. "
> +			"Taking evasive action.\n");
>  		return 1;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -143,7 +151,7 @@ static void __cpuinit trap_init_f00f_bug(void)
>  	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
>  	load_idt(&idt_descr);
>  }
> -#endif
> +#endif /* CONFIG_X86_F00F_BUG */

  Another add a comment whether it makes sense or not
  
>  static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
>  {
> @@ -164,7 +172,22 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
>  		WARN_ONCE(1, "WARNING: SMP operation may be unreliable"
>  				    "with B stepping processors.\n");
>  	}
> -#endif
> +#endif /* CONFIG_SMP */
> +}

  Ditto.

 
>  static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
> @@ -173,8 +196,9 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  
>  #ifdef CONFIG_X86_F00F_BUG
>  	/*
> -	 * All current models of Pentium and Pentium with MMX technology CPUs
> -	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
> +	 * All current models of Pentium and Pentium with MMX technology
> +	 * CPUs have the F0 0F bug, which lets nonprivileged users lock
> +	 * up the system.
>  	 * Note that the workaround only should be initialized once...
>  	 */
>  	c->f00f_bug = 0;
> @@ -184,17 +208,18 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  		c->f00f_bug = 1;
>  		if (!f00f_workaround_enabled) {
>  			trap_init_f00f_bug();
> -			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
> +			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - "
> +				"workaround enabled.\n");
>  			f00f_workaround_enabled = 1;
>  		}
>  	}
> -#endif
> +#endif /* CONFIG_X86_F00F_BUG */

  Same here.
  
> @@ -238,36 +263,39 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  		movsl_mask.mask = 7;
>  		break;
>  	}
> -#endif
> +#endif /* CONFIG_X86_INTEL_USERCOPY */

  Ditto.
  
>  #ifdef CONFIG_X86_NUMAQ
>  	numaq_tsc_disable();
> -#endif
> +#endif /* CONFIG_X86_NUMAQ */

  Sigh.
  
>  	intel_smp_check(c);
>  }
> -#else
> +#else /* CONFIG_X86_32 */
> +
>  static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  {
>  }
> -#endif
> +#endif /* CONFIG_X86_32 */

  Nice. That one is really useful.
  
>  static void __cpuinit srat_detect_node(void)
>  {
>  #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
> -	unsigned node;
> -	int cpu = smp_processor_id();
>  	int apicid = hard_smp_processor_id();
> +	int cpu = smp_processor_id();
> +	unsigned node;
>  
> -	/* Don't do the funky fallback heuristics the AMD version employs
> -	   for now. */
> +	/*
> +	 * Don't do the funky fallback heuristics the AMD version
> +	 * employs for now.
> +	 */
>  	node = apicid_to_node[apicid];
>  	if (node == NUMA_NO_NODE || !node_online(node))
>  		node = first_node(node_online_map);
>  	numa_set_node(cpu, node);
>  
> -	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> -#endif
> +	pr_info("CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> +#endif /* CONFIG_NUMA && CONFIG_X86_64 */

  Useless again.

>  
>  #ifdef CONFIG_X86_64
> -	if (c->x86 == 15)
> -		c->x86_cache_alignment = c->x86_clflush_size * 2;
> -	if (c->x86 == 6)
>  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> -#else
> +#else /* CONFIG_X86_64 */

  Ditto
  	/*
>  	 * Names for the Pentium II/Celeron processors
>  	 * detectable only by also checking the cache size.
>  	 * Dixon is NOT a Celeron.
>  	 */
> -	if (c->x86 == 6) {
> -		char *p = NULL;
>  
>  		switch (c->x86_model) {
>  		case 5:
> @@ -403,13 +421,19 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  
>  		if (p)
>  			strcpy(c->x86_model_id, p);
> -	}
>  
> -	if (c->x86 == 15)
> -		set_cpu_cap(c, X86_FEATURE_P4);
> -	if (c->x86 == 6)
>  		set_cpu_cap(c, X86_FEATURE_P3);
> -#endif
> +#endif /* CONFIG_X86_64 */

  Total nonsense. This is the end of the #else path which should be
  marked as /* !CONFIG_X86_64 */

> +		break;
> +
> +	case 15:
> +#ifdef CONFIG_X86_64
> +		c->x86_cache_alignment = c->x86_clflush_size * 2;
> +#else /* CONFIG_X86_64 */
> +		set_cpu_cap(c, X86_FEATURE_P4);
> +#endif /* CONFIG_X86_64 */

  Groan.

> +		break;
> +	}
>  
>  	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
>  		/*
> @@ -419,7 +443,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  		c->x86_max_cores = intel_num_cpu_cores(c);
>  #ifdef CONFIG_X86_32
>  		detect_ht(c);
> -#endif
> +#endif /* CONFIG_X86_32 */

  crap++;

>  
>  static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
>  	.c_vendor	= "Intel",
> @@ -498,11 +508,10 @@ static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
>  		},
>  	},
>  	.c_size_cache	= intel_size_cache,
> -#endif
> +#endif /* CONFIG_X86_32 */

  maybe_useful++;

 
>  #ifdef CONFIG_X86_32
>  static void pit_disable_clocksource(void);
> -#else
> +#else /* CONFIG_X86_32 */
>  static inline void pit_disable_clocksource(void) { }
> -#endif
> +#endif /* CONFIG_X86_32 */

  crap++;
  
>  /*
>   * HPET replaces the PIT, when enabled. So we need to know, which of
> @@ -40,7 +40,7 @@ static void init_pit_timer(enum clock_event_mode mode,
>  {
>  	spin_lock(&i8253_lock);
>  
> -	switch(mode) {
> +	switch (mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
>  		/* binary, mode 2, LSB/MSB, ch 0 */
>  		outb_pit(0x34, PIT_MODE);
> @@ -95,7 +95,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
>   * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
>   * !using_apic_timer decisions in do_timer_interrupt_hook()
>   */
> -static struct clock_event_device pit_clockevent = {
> +static struct clock_event_device pit_dev = {

  Why do we need to change the name of the variable ? Just for fun or
  is pit_dev more self explaining than pit_clockevent ?

>  #ifndef CONFIG_X86_64
> @@ -133,11 +130,11 @@ void __init setup_pit_timer(void)
>   */
>  static cycle_t pit_read(void)
>  {
> +	static int old_count;
>  	unsigned long flags;
> +	static u32 old_jifs;

  Doh. Can we keep the statics together and not just at random places ?

>  	int count;
>  	u32 jifs;
> -	static int old_count;
> -	static u32 old_jifs;
>  
>  	spin_lock_irqsave(&i8253_lock, flags);
>  	/*
> @@ -179,9 +176,9 @@ static cycle_t pit_read(void)
>  	 * Previous attempts to handle these cases intelligently were
>  	 * buggy, so we just do the simple thing now.
>  	 */
> -	if (count > old_count && jifs == old_jifs) {
> +	if (count > old_count && jifs == old_jifs)
>  		count = old_count;
> -	}
> +

  We trade a brace against a newline. What's the win here ? Oh, I
  forgot there is some magic rule which requires this.

> -static struct clocksource clocksource_pit = {
> +static struct clocksource pit_src = {

  very intuitive naming and a bunch of changes which are just useless.

> +	return clocksource_register(&pit_src);
>  }
>  arch_initcall(init_pit_clocksource);

   Hint: You forgot to annotate the #endif here.

> @@ -22,10 +22,6 @@ static int __initdata io_delay_override;
>  void native_io_delay(void)
>  {
>  	switch (io_delay_type) {
> -	default:
> -	case CONFIG_IO_DELAY_TYPE_0X80:
> -		asm volatile ("outb %al, $0x80");
> -		break;
>  	case CONFIG_IO_DELAY_TYPE_0XED:
>  		asm volatile ("outb %al, $0xed");
>  		break;
> @@ -40,6 +36,10 @@ void native_io_delay(void)
>  		udelay(2);
>  	case CONFIG_IO_DELAY_TYPE_NONE:
>  		break;
> +	case CONFIG_IO_DELAY_TYPE_0X80:
> +	default:
> +		asm volatile ("outb %al, $0x80");
> +		break;
>  	}
>  }

   Did you bother to compare the assembly output ? Definitely not. The
   ordering has a reason. Darn, this is not a playground for "oh this
   looks nicer" changes.

>  static int __init
> @@ -92,16 +93,19 @@ create_setup_data_node(struct dentry *parent, int no,
>  		error = -ENOMEM;
>  		goto err_return;
>  	}
> +
>  	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
>  	if (!type) {
>  		error = -ENOMEM;
>  		goto err_dir;
>  	}
> +
>  	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
>  	if (!data) {
>  		error = -ENOMEM;
>  		goto err_type;
>  	}
> +

  Yuck. Instead of adding blindly newlines you could have cleaned up
  the "error = -ENOMEM" repetitive crap.

>  		if (PageHighMem(pg))
>  			iounmap(data);
> +
>  		if (error)
>  			goto err_dir;
> +
>  		no++;
>  	}
> +
>  	return 0;

  Sigh. This way I see only half of the code on a screen.
  
> -#endif
> +#endif /* CONFIG_DEBUG_BOOT_PARAMS */

  maybe_usefull++;

> -#endif  
> -
> -#ifdef CONFIG_X86_IO_APIC

  The first #ifdef change which makes really sense.
  
>  static int bad_ioapic(unsigned long address)
>  {
> @@ -125,6 +122,7 @@ static int bad_ioapic(unsigned long address)
>  		       " found in table, skipping!\n");
>  		return 1;
>  	}
> +

  Can we stop this please ? These changes are just annoying.

> -				struct mpc_bus *m = (struct mpc_bus *)mpt;
> -#ifdef CONFIG_X86_IO_APIC
> -				MP_bus_info(m);
> -#endif

 Good catch.

Can you please remove all the useless changes and concentrate on the
useful ones ?

Thanks,

	tglx
