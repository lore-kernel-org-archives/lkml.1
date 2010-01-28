Return-Path: <linux-kernel-owner+w=401wt.eu-S932221Ab0A1Rpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0A1Rpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256Ab0A1Rpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:45:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:52946 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0A1Rpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:45:43 -0500
Message-ID: <4B61CD14.7000901@windriver.com>
Date: Thu, 28 Jan 2010 11:44:52 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to use hw_breakpointAPI
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere>
In-Reply-To: <20100128171050.GA18683@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 17:44:52.0317 (UTC) FILETIME=[985F20D0:01CAA041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Jan 25, 2010 at 10:26:37PM -0600, Jason Wessel wrote:
>   
>> @@ -466,7 +466,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>>  {
>>  	int i, cpu, rc = NOTIFY_STOP;
>>  	struct perf_event *bp;
>> -	unsigned long dr7, dr6;
>> +	unsigned long dr6;
>>  	unsigned long *dr6_p;
>>  
>>  	/* The DR6 value is pointed by args->err */
>> @@ -477,7 +477,6 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>>  	if ((dr6 & DR_TRAP_BITS) == 0)
>>  		return NOTIFY_DONE;
>>  
>> -	get_debugreg(dr7, 7);
>>  	/* Disable breakpoints during exception handling */
>>  	set_debugreg(0UL, 7);
>>  	/*
>> @@ -525,7 +524,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>>  	if (dr6 & (~DR_TRAP_BITS))
>>  		rc = NOTIFY_DONE;
>>  
>> -	set_debugreg(dr7, 7);
>> +	set_debugreg(__get_cpu_var(cpu_dr7), 7);
>>  	put_cpu();
>>     
>
>
>
> Good simplification, but that doesn't appear related to kgdb,
> this should be done in a separate patch, for the perf/core tree.
>
>
>
>   

Specifically this is required so that kgdb can modify the state of dr7
by installing and removing breakpoints.  Without this change, on return
from the callback the dr7 was not correct.

As far as I know, only kgdb was altering the dr registers during a call
back..

>
>>  	}
>> -	if (correctit)
>> -		set_debugreg(dr7, 7);
>> +	hw_breakpoint_restore();
>>     
>
>
>
> hw_breakpoint_restore() is used by KVM only, for now.
> The cpu var cpu_debugreg[] contains values that
> are only saved when KVM switches to a guest, then
> this function is called when KVM switches back to the
> host. I bet this is not the function you need.
> In fact, I don't know what you intended to do there.
>
>   

I was looking to restore the proper contents of the debug registers when
resuming the general kernel execution.

As far as I could tell it looked like the right function because
arch_install_breakpoint() uses the per_cpu vars.  If there is a save
function that I need to call first that is a different issue.

IE:
    __get_cpu_var(cpu_debugreg[i]) = info->address;


I admit I did not test running a kvm instance, so I don't know what kind
of conflict there would be here.  I went and further looked at the kvm
code, and they call the function for the same reason kgdb does.  They
want the original system values back on resuming normal kernel
execution.  KVM can modify dr7 or other regs directly on entry for its
guest execution.  Kgdb does the same sort of thing so as to prevent the
debugger from interrupting itself.


>
>   
>> @@ -278,27 +285,38 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
>>  
>>  	switch (bptype) {
>>  	case BP_HARDWARE_BREAKPOINT:
>> -		type = 0;
>> -		len  = 1;
>> +		len = 1;
>> +		breakinfo[i].type = X86_BREAKPOINT_EXECUTE;
>>  		break;
>>  	case BP_WRITE_WATCHPOINT:
>> -		type = 1;
>> +		breakinfo[i].type = X86_BREAKPOINT_WRITE;
>>  		break;
>>  	case BP_ACCESS_WATCHPOINT:
>> -		type = 3;
>> +		breakinfo[i].type = X86_BREAKPOINT_RW;
>>  		break;
>>     
>
>
>
> Would be nice to have bptype set to the generic flags
> we have already in linux/hw_breakpoint.h:
>
> enum {
> 	HW_BREAKPOINT_R = 1,
> 	HW_BREAKPOINT_W = 2,
> 	HW_BREAKPOINT_X = 4,
> };
>
>
>   

These numbers have to get translated somewhere from the GDB version
which it handed off via the gdb serial protocol.  They could be
translated in the gdb stub, but for now they are in the arch specific
stub.  Or you can choose to use the same numbering scheme as gdb for the
breakpoint types and the values could be used directly.

> We have functions in x86 to do the conversion to
> x86 values in arch/x86/kernel/hw_breakpoint.c
>
> Nothing urgent though, as this patch is a regression fix,
> this can be done later.
>
>
>
>   
>> +	switch (len) {
>> +	case 1:
>> +		breakinfo[i].len = X86_BREAKPOINT_LEN_1;
>> +		break;
>> +	case 2:
>> +		breakinfo[i].len = X86_BREAKPOINT_LEN_2;
>> +		break;
>> +	case 4:
>> +		breakinfo[i].len = X86_BREAKPOINT_LEN_4;
>> +		break;
>> +#ifdef CONFIG_X86_64
>> +	case 8:
>> +	breakinfo[i].len = X86_BREAKPOINT_LEN_8;
>> +		break;
>> +#endif
>>     
>
>
>
> Same here, see arch_build_bp_info().
> Actually, arch_validate_hwbkpt_settings() would do all
> that for you. May require few changes though to adapt.
>
> Actually, I don't understand why you encumber with this
> breakinfo thing. Why not just keeping a per cpu array
> of perf events? You have everything you need inside:
> the generic breakpoint attributes in the attrs and
> the arch info in the hw_perf_event struct inside.
>   

I think the break info thing will go away via a refactor.  For now I was
really looking to make it work.   There was no way to tell at the time
what values were safe to use in attr struct provided by perf.  I would
have further preferred to be able to use the simple -1 cpu in the bp
type and let perf do all the work, but there is no way to allocate a
perf hw wide break like this at the moment.

Realize that what is here is well tested, and aimed to first correct the
regression.

> Hence you would be able to use the x86 breakpoint API
> we have already, arch_validate_hwbkpt_settings() does
> everything for you. This is going to shrink your code
> and then make it a stronger argument to pull request
> as a not-that-one-liner regression fix late in the
> process (which I must confess is my bad, firstly: I
> did the regression and secondly: I should have
> reviewed these fixes sooner).
>
>
>
>   
>> @@ -313,8 +331,21 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
>>   */
>>  void kgdb_disable_hw_debug(struct pt_regs *regs)
>>  {
>> +	int i;
>> +	int cpu = raw_smp_processor_id();
>> +	struct perf_event *bp;
>> +
>>  	/* Disable hardware debugging while we are in kgdb: */
>>  	set_debugreg(0UL, 7);
>> +	for (i = 0; i < 4; i++) {
>> +		if (!breakinfo[i].enabled)
>>     
>
>
>
> See? Here you could use simply bp->attr.disabled instead
> of playing with this breakinfo.
>
>
>   

Right now, no because the disabled attribute was separately tracking if
it was installed or not.  The breakinfo thing crudely tracked the kgdb
breakpoint list while in kgdb, and then it is synced with the real
install state.

Yes, I'd like to get rid of it, but it is more changes than I want to
make at the moment.

>> @@ -378,7 +409,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
>>  			       struct pt_regs *linux_regs)
>>  {
>>  	unsigned long addr;
>> -	unsigned long dr6;
>>  	char *ptr;
>>  	int newPC;
>>  
>> @@ -448,10 +464,12 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
>>  }
>>  
>>  static int was_in_debug_nmi[NR_CPUS];
>> +static int recieved_hw_brk[NR_CPUS];
>>  
>>  static int __kgdb_notify(struct die_args *args, unsigned long cmd)
>>  {
>>  	struct pt_regs *regs = args->regs;
>> +	unsigned long *dr6_p;
>>  
>>  	switch (cmd) {
>>  	case DIE_NMI:
>> @@ -485,16 +503,24 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
>>  		break;
>>  
>>  	case DIE_DEBUG:
>> -		if (atomic_read(&kgdb_cpu_doing_single_step) ==
>> -		    raw_smp_processor_id()) {
>> +		dr6_p = (unsigned long *)ERR_PTR(args->err);
>> +		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
>> +			if (dr6_p && (*dr6_p & DR_STEP) == 0)
>> +				return NOTIFY_DONE;
>>  			if (user_mode(regs))
>>  				return single_step_cont(regs, args);
>>  			break;
>> -		} else if (test_thread_flag(TIF_SINGLESTEP))
>> +		} else if (test_thread_flag(TIF_SINGLESTEP)) {
>>  			/* This means a user thread is single stepping
>>  			 * a system call which should be ignored
>>  			 */
>>  			return NOTIFY_DONE;
>> +		} else if (recieved_hw_brk[raw_smp_processor_id()] == 1) {
>> +			recieved_hw_brk[raw_smp_processor_id()] = 0;
>> +			return NOTIFY_STOP;
>> +		} else if (dr6_p && (*dr6_p & DR_TRAP_BITS) == 0) {
>> +			return NOTIFY_DONE;
>> +		}
>>     
>
>
>
> So this is the debug handler, right?
>
>
>   

This ugly bit is all because the patch I had for returning something
from the event call back was tossed.

Because perf does not honor the return code from a call back there is no
way to dismiss an event in the die notifier.  The forces the debug
handler to do very nasty tricks so as not to handle the same event twice.

>>  
>> +static void kgdb_hw_bp(struct perf_event *bp, int nmi,
>> +		       struct perf_sample_data *data,
>> +		       struct pt_regs *regs)
>> +{
>> +	struct die_args args;
>> +	int cpu = raw_smp_processor_id();
>> +
>> +	args.trapnr = 0;
>> +	args.signr = 5;
>> +	args.err = 0;
>> +	args.regs = regs;
>> +	args.str = "debug";
>> +	recieved_hw_brk[cpu] = 0;
>> +	if (__kgdb_notify(&args, DIE_DEBUG) == NOTIFY_STOP)
>> +		recieved_hw_brk[cpu] = 1;
>> +	else
>> +		recieved_hw_brk[cpu] = 0;
>> +}
>>     
>
>
>
> And this looks like the perf event handler.
>
> I'm confused by the logic here. We have the x86 breakpoint
> handler which calls perf_bp_event which in turn will call
> the above. The above calls __kgdb_notify(), but it will
> also be called later as it is a debug notifier.
>
>
>   

Perf was eating my events if I had no call back.  If you know a way
around this let me know.


>   
>> +
>>  /**
>>   *	kgdb_arch_init - Perform any architecture specific initalization.
>>   *
>> @@ -539,7 +584,43 @@ static struct notifier_block kgdb_notifier = {
>>   */
>>  int kgdb_arch_init(void)
>>  {
>> -	return register_die_notifier(&kgdb_notifier);
>> +	int i, cpu;
>> +	int ret;
>> +	struct perf_event_attr attr;
>> +	struct perf_event **pevent;
>> +
>> +	ret = register_die_notifier(&kgdb_notifier);
>> +	if (ret != 0)
>> +		return ret;
>> +	/*
>> +	 * Pre-allocate the hw breakpoint structions in the non-atomic
>> +	 * portion of kgdb because this operation requires mutexs to
>> +	 * complete.
>> +	 */
>> +	attr.bp_addr = (unsigned long)kgdb_arch_init;
>> +	attr.type = PERF_TYPE_BREAKPOINT;
>> +	attr.bp_len = HW_BREAKPOINT_LEN_1;
>> +	attr.bp_type = HW_BREAKPOINT_X;
>> +	attr.disabled = 1;
>> +	for (i = 0; i < 4; i++) {
>> +		breakinfo[i].pev = register_wide_hw_breakpoint(&attr,
>> +							       kgdb_hw_bp);
>>     
>
>
>
> By calling this, you are reserving all the breakpoint slots.
>
>   

Looking down further you will see only 1 slot is used because it is
immediately released.

>
>   
>> +		if (IS_ERR(breakinfo[i].pev)) {
>> +			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
>> +			breakinfo[i].pev = NULL;
>> +			kgdb_arch_exit();
>> +			return -1;
>> +		}
>> +		for_each_online_cpu(cpu) {
>> +			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
>> +			pevent[0]->hw.sample_period = 1;
>> +			if (pevent[0]->destroy != NULL) {
>> +				pevent[0]->destroy = NULL;
>> +				release_bp_slot(*pevent);
>>     
>
>
>
> And then you release these, ok. We should find a proper
> way for that later, but for now it should work.
>
>   

Previously, I was unable to convince anyone that the kernel debugger
needed to be able to do this.  I had an API change to perf for it, but
it was dismissed along with the notify return value on the call back. 
This is merely a work around to correct the regression.

Jason.

