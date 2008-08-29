Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYH2OsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYH2OsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYH2OsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:48:10 -0400
Received: from gw.goop.org ([64.81.55.164]:59136 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYH2OsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:48:08 -0400
Message-ID: <48B80C26.2080002@goop.org>
Date: Fri, 29 Aug 2008 07:48:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808290817190.21494@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Thanks for taking this on, Jeremy: I had too many doubts to do so.
>
> On Thu, 28 Aug 2008, Jeremy Fitzhardinge wrote:
>   
>> Some BIOSes have been observed to corrupt memory in the low 64k.
>>     
>
> hpa introduced the 64k idea, and we've all been repeating it;
> but I've not heard the reasoning behind it.  Is it a fundamental
> addressing limitation within the BIOS memory model?  Or a case
> that Windows treats the bottom 64k as scratch, so BIOS testers
> won't notice if they corrupt it?
>
> The two instances of corruption we've been studying have indeed
> been below 64k (one in page 8 and one in page 11), but that's
> because they were both recognizable corruptions of direct map PMDs.
>
> If there is not a very strong justification for that 64k limit,
> then I don't think this approach will be very useful, and we should
> simply continue to rely on analyzing corruption when it appears, and
> recommend memmap= as a way of avoiding it once analyzed.  If there
> is a strong justification for it, please dispel my ignorance!
>   

I don't think there's been a strong rationale.  64k is significant
because it's the size of an old 16-bit real-mode segment, and perhaps
the bios code in question is 16-bit code.

But I think it's really a question of limiting the scope of the problem:
yes, the BIOS could corrupt any memory anywhere, but what can we
possibly do about that?  Such a machine is as useless as a system with
intermittent faulty memory hardware.

We have to assume that it is basically possible to use the machine, and
that presumably whatever bug the BIOS has isn't making Windows crash. 
Windows might be avoiding the low 64k for some ancient-history DOS
reason, or perhaps it's just full of boot code which isn't used again?

It would be easy to add another kernel parameter to select how much
memory to reserve for corruption checking.  64k?  1M?

>> This patch does two things:
>>  - Reserves all memory which does not have to be in that area, to
>>    prevent it from being used as general memory by the kernel.  Things
>>    like the SMP trampoline are still in the memory, however.
>>  - Clears the reserved memory so we can observe changes to it.
>>  - Adds a function check_for_bios_corruption() which checks and reports on
>>    memory becoming unexpectedly non-zero.  Currently it's called in the
>>    x86 fault handler, and the powermanagement debug output.
>>
>> RFC: What other places should we check for corruption in?
>>     
>
> I don't know: the easy answer would be just to do it once every minute.
> As the patch stands, we'll only learn more on machines going through
> suspend+resume (disk or ram).  If the corruption avoidance works,
> then the fault case should never trigger.
>   

Right.  Once a minute sounds good, though it might be a bit too long to
correlate the corruption to a specific event.

>> [ Alan, Rafał: could you check you see:
>>    1: corruption messages
>>    2: no crashes
>>   Thanks -J
>> ]
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Cc: Hugh Dickens <hugh@veritas.com>
>>     
>
>            Dickins
>
>   
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Rafał Miłecki <zajec5@gmail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  Documentation/kernel-parameters.txt |    5 ++
>>  arch/x86/Kconfig                    |    3 +
>>  arch/x86/kernel/setup.c             |   86 +++++++++++++++++++++++++++++++++++
>>  arch/x86/mm/fault.c                 |    2 
>>  drivers/base/power/main.c           |    1 
>>  include/linux/kernel.h              |   12 ++++
>>  6 files changed, 109 insertions(+)
>>
>> ===================================================================
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -359,6 +359,11 @@
>>  			BayCom Serial Port AX.25 Modem (Half Duplex Mode)
>>  			Format: <io>,<irq>,<mode>
>>  			See header of drivers/net/hamradio/baycom_ser_hdx.c.
>> +
>> +	bios_corruption_check=0/1 [X86]
>> +			Some BIOSes seem to corrupt the first 64k of memory
>> +			when doing things like suspend/resume.  Setting this
>> +			option will scan the memory looking for corruption.
>>     
>
> It's actually a bottom_of_memory corruption_check: it would pick
> up corruption there whether it's caused by the BIOS or not.
> The boot parameter description ought to refer to the config
> option: ah, the config option is always on for x86, hmm.
>   

Yeah, I didn't bother to make it switchable yet.

> If the 64k is in any doubt, maybe the corruption_check boot option
> should specify limiting address rather than just off/on.
>   

Yes, that sounds good.  Also, it might be worth being able to set the
rate.  Doing it once every 10 seconds wouldn't add too much overhead,
and once a second would be reasonable if you think there's an actual
problem.

>>  
>>  	boot_delay=	Milliseconds to delay each printk during boot.
>>  			Values larger than 10 seconds (10000) are changed to
>> ===================================================================
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -203,6 +203,9 @@
>>  	bool
>>  	depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
>>  	default y
>> +
>> +config X86_CHECK_BIOS_CORRUPTION
>> +        def_bool y
>>     
>
> Always on?  For the moment, perhaps.  I'm very pleased to see you've
> set it on for x86_32 as well as for x86_64, I'd been wanting to ask
> what's been happening on 32-bit.
>   

I couldn't see any reason the problem would be restricted to 64-bit.  It
could just be lurking in a rarely used corner of the address space.

>>  
>>  config KTIME_SCALAR
>>  	def_bool X86_32
>> ===================================================================
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -582,6 +582,88 @@
>>  struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
>>  
>>  /*
>> + * Some BIOSes seem to corrupt the low 64k of memory during events
>> + * like suspend/resume and unplugging an HDMI cable.  Reserve all
>> + * remaining free memory in that area and fill it with a distinct
>> + * pattern.
>> + */
>> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>> +#define MAX_SCAN_AREAS	8
>> +static struct e820entry scan_areas[MAX_SCAN_AREAS];
>> +static int num_scan_areas;
>> +
>> +static void __init setup_bios_corruption_check(void)
>> +{
>> +	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
>> +
>> +	while(addr < 0x10000 && num_scan_areas < MAX_SCAN_AREAS) {
>> +		u64 size;
>> +		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
>> +
>> +		if (addr == 0)
>> +			break;
>> +
>> +		if ((addr + size) > 0x10000)
>> +			size = 0x10000 - addr;
>>     
>
> Here (and the patch description) might be the right place to justify 64k.
>   

I'm inclined to make it variable.

>> +
>> +		if (size == 0)
>> +			break;
>> +
>> +		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
>> +		scan_areas[num_scan_areas].addr = addr;
>> +		scan_areas[num_scan_areas].size = size;
>> +		num_scan_areas++;
>> +
>> +		/* Assume we've already mapped this early memory */
>> +		memset(__va(addr), 0, size);
>> +
>> +		addr += size;
>> +	}
>> +
>> +	printk(KERN_INFO "scanning %d areas for BIOS corruption\n",
>> +	       num_scan_areas);
>> +	update_e820();
>> +}
>> +
>> +static int __read_mostly bios_corruption_check = 1;
>> +
>> +void check_for_bios_corruption(void)
>> +{
>> +	int i;
>> +	int corruption = 0;
>> +
>> +	if (!bios_corruption_check)
>> +		return;
>> +
>> +	for(i = 0; i < num_scan_areas; i++) {
>> +		unsigned long *addr = __va(scan_areas[i].addr);
>>     
>
> Small point, but since we're doing the same on 32-bit and 64-bit,
> I think it would be better to operate on unsigned ints, to get
> the same kind of printout in the two cases.
>   

OK.

>> +		unsigned long size = scan_areas[i].size;
>> +
>> +		for(; size; addr++, size--) {
>> +			if (!*addr)
>> +				continue;
>> +			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
>> +			       addr, __pa(addr), *addr);
>>     
>
> Don't you need to reset *addr to 0 here, to avoid noise ever after?
>   

Yes.

>> +			corruption = 1;
>> +		}
>> +	}
>> +
>> +	if (corruption)
>> +		dump_stack();
>>     
>
> The purpose of the dump_stack being to insert a recognizable and
> irritating spew into the log, prompting people to report these cases:
> the stacktrace itself is unlikely to be relevant.  Is a simple
> dump_stack enough to get it reported to kerneloops.org, or is
> more tweaking necessary?
>   

Well, no, I was thinking about it would give a clue about what went
wrong.  If you see the spew out of the pm code, then it was likely
suspend/resume.  If it's out of the timer function then it won't tell
you much other than "something else".  If we put it elsewhere (even if
temporarily for detecting other suspected corruption symptoms), then it
will be useful for distinguishing those.

An alternative would be to pass a flag to say whether a backtrace would
likely be useful.  Or wrap it in a macro to provide file/line info.

>> +}
>> +
>> +static int set_bios_corruption_check(char *arg)
>> +{
>> +	char *end;
>> +
>> +	bios_corruption_check = simple_strtol(arg, &end, 10);
>> +
>> +	return (*end == 0) ? 0 : -EINVAL;
>> +}
>> +early_param("bios_corruption_check", set_bios_corruption_check);
>> +#endif
>> +
>> +/*
>>   * Determine if we were loaded by an EFI loader.  If so, then we have also been
>>   * passed the efi memmap, systab, etc., so we should use these data structures
>>   * for initialization.  Note, the efi init code path is determined by the
>> @@ -766,6 +848,10 @@
>>  		max_low_pfn = max_pfn;
>>  
>>  	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>> +#endif
>> +
>> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>> +	setup_bios_corruption_check();
>>  #endif
>>  
>>  	/* max_pfn_mapped is updated here */
>> ===================================================================
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -864,6 +864,8 @@
>>   * Oops. The kernel tried to access some bad page. We'll have to
>>   * terminate things with extreme prejudice.
>>   */
>> +	check_for_bios_corruption();
>> +
>>  #ifdef CONFIG_X86_32
>>  	bust_spinlocks(1);
>>  #else
>> ===================================================================
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -254,6 +254,7 @@
>>  
>>  static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
>>  {
>> +	check_for_bios_corruption();
>>  	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
>>  		((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
>>  		", may wakeup" : "");
>> ===================================================================
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -246,6 +246,18 @@
>>  extern void add_taint(unsigned);
>>  extern int root_mountflags;
>>  
>> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>> +/*
>> + * This is obviously not a great place for this, but we want to be
>> + * able to scatter it around anywhere in the kernel.
>> + */
>> +void check_for_bios_corruption(void);
>> +#else
>> +static inline void check_for_bios_corruption(void)
>> +{
>> +}
>> +#endif
>> +
>>  /* Values used for system_state */
>>  extern enum system_states {
>>  	SYSTEM_BOOTING,
>>     
>
> I'll give this or something like it a try on my machines later on,
> 32 and 64, to see if anything comes up which hasn't caused any
> visible problem before (but will either need to do suspend+resume
> on machines not tried before, or add in the periodic test).
>
> I do wonder whether for 2.6.27 we should simply go back to the
> previous kernel pagetable layout, so there's no regression while
> we investigate the issue further.  But I don't recall how well-
> defined that layout was, and whether your perturbation was just
> in that one patch or not.
>   

That would break Xen.  I needed to do the pagetable reuse to make sure
that the Xen domain-builder pagetables are preserved.

> Is this the right moment for me to mention again that I'm not sure
> your reuse of existing pagetables was quite right anyway: NX being
> excluded from level2_ident_pgt, but wanted in the direct map?
>   

We could add NX.  What's the behaviour of setting NX in a
non-NX-supporting CPU?  I don't think it would trigger a "reserved bit"
exception (the other high pte flags don't).  Or failing that, we could
mask out NX once we've worked out the CPU doesn't support it (at the
same time it relocates the pagetables to the kernel's load-time address).

    J
