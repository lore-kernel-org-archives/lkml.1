Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbXE2Bs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbXE2Bs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbXE2Bsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:48:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:57561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbXE2Bst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,587,1170662400"; 
   d="scan'208";a="248180383"
From: Yang Sheng <sheng.yang@intel.com>
Organization: intel
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC PATCH]Multi-threaded Initcall with dependence support
Date: Tue, 29 May 2007 09:47:53 +0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200705281503.10918.sheng.yang@intel.com> <20070528155229.26a6848e.randy.dunlap@oracle.com>
In-Reply-To: <20070528155229.26a6848e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705290947.53881.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 06:52, Randy Dunlap wrote:
> On Mon, 28 May 2007 15:03:10 +0800 Yang Sheng wrote:
> > Why we need this:
> >
> > It can speed up the calling of initcalls, especially useful for some
> > embed device.
>
> Can you give concrete example(s) of why we need this?
> Any real configs/hardware where it helps and how much it helps.
>

We didn't got the precise data at hand now, because we should build a complete  
stable initcall dependence relationship for it, but we can't do it now. 

But we have done a relative stable test in a common x86_64 machine, with 2 
threads and one dependence relation(pnpacpi_init depends on pnp_init and 
acpi_init). The result is the time spending on initcall calling reducing from 
about _5s_ to _2s_ (make the kernel with the defconfig). We analyzed the 
dmesg and found the most of time was save by run ide_generic_init and 
piix_init in parallel. 

Of course the dependence in the test case is not sufficient, but the effect is 
shown. 

We think this patch would be very useful in some embed deviced which requires 
fast boot speed. Some server may benefit too because of it's long time for 
device initiation. 

>
> General:
> 1/ Patch has 12 lines with trailing whitespace.  Please chop those
> off (always).
> 2/ Try to keep sources lines < 80 characters.
> 3/ Read & use Documentation/CodingStyle, Documentation/SubmittingPatches,
> and Documentation/SubmitChecklist.
>

Thanks for advise! Next time I will be more careful on coding style and check 
the patch following the document above. 

The patch below is a prototype now. Some problem can't be solve in current 
stage, like the map function's algorithm complexity is O(n^2). I have another 
method for this but require some duplicate name initcall's rename. 

Thanks!

> > Idea:
> >
> > 1. The initcall can indicate a executing sequence by using the a
> > macro(initcall_depend()) in case of causing dependence problem in
> > multi-threaded running. Multi dependences is also allowed.
> > 2. Ensure the calling of initcalls in the same layer would be completed
> > before the next layers' calling.
> >
> > Usage:
> > You can indicate that initcall A must be run after initcall B by calling
> > the macro in A's file:
> >
> > initcall_depend(A, B);
> >
> > Means initcall A must run after initcall B finish executing(A depends on
> > B).
> >
> > Take notice of that if you declare A depends on B and C, you must put
> > these together as (the sequences is not important):
> >
> > initcall_depend(A, B);
> > initcall_depend(A, C);
> >
> > The detail of method:
> >
> > A new section called .initcall.depend was added to
> > arch/xxx/kernel/vmlinux.lds.S to indicate the dependence relationship. A
> > struct called initcall_depend_t stored the relationship between A and B,
> > and was stored in section .initcall.depend.
> >
> > Because all the dependence of A are put together, and the sequences of
> > initcall_depend_t was decided in linker order as initcall itself did.
> > When A is going to run, we can check if A would depend on others by
> > checking the point indicate the current item in dependence table. If the
> > field "call" of initcall_depend_t point to A, we know that A is depend on
> > something and get the prev_addr of the struct to find what it depends on.
> > The field "prev_addr" point to somewhere in .initcall.init section to
> > indicate the address(also the order) of depended initcall, so it can be
> > used to find out whether other threads complete executing of the depended
> > initcall. If the current point of the thread executing is smaller than
> > prev_addr(it means some thread not completed executing, not only this
> > thread), we'll wait, otherwise we can continue to check next thread. If
> > all the thread is ok, we will run the initcall and go to the next one.
> >
> > This method is not very precision(for we may have to wait even when the
> > initcall was completed but not all the other pass it), but easy to
> > implement.
> >
> > I provide two method to get the dependence relationship, the following
> > code contains the one which is more flexibly but less efficiency.
> >
> > The downside of this patch is every driver must explictly indicate its
> > dependence, please tell if this is acceptable. Any suggestions and
> > comments are welcome.
> >
> > Thanks.
> >
> > ----
> >
> >  arch/x86_64/kernel/vmlinux.lds.S |    6 +
> >  include/linux/init.h             |   16 +++
> >  init/main.c                      |  257
> > +++++++++++++++++++++++++++++++------ 3 files changed, 237 insertions(+),
> > 42 deletions(-)
> >
> > diff --git a/arch/x86_64/kernel/vmlinux.lds.S
> > b/arch/x86_64/kernel/vmlinux.lds.S
> > index dbccfda..355c8b6 100644
> > --- a/arch/x86_64/kernel/vmlinux.lds.S
> > +++ b/arch/x86_64/kernel/vmlinux.lds.S
> > @@ -167,6 +167,12 @@ SECTIONS
> >  	INITCALLS
> >    }
> >    __initcall_end = .;
> > +  . = ALIGN(16);
> > +  __initcall_depend_start = .;
> > +  .initcall.depend : AT(ADDR(.initcall.depend) - LOAD_OFFSET) {
> > +	*(.initcall.depend)
> > +  }
> > +  __initcall_depend_end = .;
> >    __con_initcall_start = .;
> >    .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
> >  	*(.con_initcall.init)
> > diff --git a/include/linux/init.h b/include/linux/init.h
> > index 56ec4c6..68134d7 100644
> > --- a/include/linux/init.h
> > +++ b/include/linux/init.h
> > @@ -73,7 +73,17 @@
> >  /*
> >   * Used for initialization calls..
> >   */
> > +
> >  typedef int (*initcall_t)(void);
> > +
> > +typedef struct {
> > +	initcall_t call;
> > +	union {
> > +		initcall_t func;
> > +		initcall_t* addr;
> > +	} prev;
> > +} initcall_depend_t;
>
> Don't add typedefs as shortcuts for struct names.
>
> > +
> >  typedef void (*exitcall_t)(void);
> >
> >  extern initcall_t __con_initcall_start[], __con_initcall_end[];
> > @@ -108,6 +118,12 @@ void prepare_namespace(void);
> >  	static initcall_t __initcall_##fn##id __attribute_used__ \
> >  	__attribute__((__section__(".initcall" level ".init"))) = fn
> >
> > +#define initcall_depend(fn, req) \
> > +	static initcall_depend_t __dependency_##fn_after_##req \
> > +	__attribute_used__ __attribute__((__section__(".initcall.depend"))) = {
> > \ +		.call = fn, \
> > +		.prev.func = req }
> > +
> >  /*
> >   * A "pure" initcall has no dependencies on anything else, and purely
> >   * initializes variables that couldn't be statically initialized.
> > diff --git a/init/main.c b/init/main.c
> > index eb8bdba..75c39c7 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -645,68 +645,241 @@ static int __init initcall_debug_setup(char *str)
> >  }
> >  __setup("initcall_debug", initcall_debug_setup);
> >
> > -extern initcall_t __initcall_start[], __initcall_end[];
> > +static int __initdata original_count;
> >
> > -static void __init do_initcalls(void)
> > +static int __init initcall_run(initcall_t* call)
>
> style (space *, not * space):  (initcall_t *call)
>
> >  {
> > -	initcall_t *call;
> > -	int count = preempt_count();
> > -
> > -	for (call = __initcall_start; call < __initcall_end; call++) {
> > -		ktime_t t0, t1, delta;
> > -		char *msg = NULL;
> > -		char msgbuf[40];
> > -		int result;
> > -
> > -		if (initcall_debug) {
> > -			printk("Calling initcall 0x%p", *call);
> > -			print_fn_descriptor_symbol(": %s()",
> > -					(unsigned long) *call);
> > -			printk("\n");
> > -			t0 = ktime_get();
> > -		}
> > +	ktime_t t0, t1, delta;
> > +	char *msg = NULL;
> > +	char msgbuf[40];
> > +	int result;
> > +
> > +	if (initcall_debug) {
> > +		printk("Calling initcall 0x%p", *call);
> > +		print_fn_descriptor_symbol(": %s()",
> > +				(unsigned long) *call);
> > +		printk("\n");
> > +		t0 = ktime_get();
> > +	}
> >
> > -		result = (*call)();
> > +	result = (*call)();
> >
> > -		if (initcall_debug) {
> > -			t1 = ktime_get();
> > -			delta = ktime_sub(t1, t0);
> > +	if (initcall_debug) {
> > +		t1 = ktime_get();
> > +		delta = ktime_sub(t1, t0);
> >
> > -			printk("initcall 0x%p", *call);
> > -			print_fn_descriptor_symbol(": %s()",
> > -					(unsigned long) *call);
> > -			printk(" returned %d.\n", result);
> > +		printk("initcall 0x%p", *call);
> > +		print_fn_descriptor_symbol(": %s()",
> > +				(unsigned long) *call);
> > +		printk(" returned %d.\n", result);
> >
> > -			printk("initcall 0x%p ran for %Ld msecs: ",
> > +		printk("initcall 0x%p ran for %Ld msecs: ",
> >  				*call, (unsigned long long)delta.tv64 >> 20);
> > -			print_fn_descriptor_symbol("%s()\n",
> > +		print_fn_descriptor_symbol("%s()\n",
> >  				(unsigned long) *call);
> > +	}
> > +
> > +	if (result && result != -ENODEV && initcall_debug) {
> > +		sprintf(msgbuf, "error code %d", result);
> > +		msg = msgbuf;
> > +	}
> > +	if (preempt_count() != original_count) {
> > +		msg = "preemption imbalance";
>
> That destroys previous <msg> content...
>
> > +		preempt_count() = original_count;
> > +	}
> > +	if (irqs_disabled()) {
> > +		msg = "disabled interrupts";
>
> ditto.
>
> > +		local_irq_enable();
> > +	}
> > +	if (msg) {
> > +		printk(KERN_WARNING "initcall at 0x%p", *call);
> > +		print_fn_descriptor_symbol(": %s()",
> > +				(unsigned long) *call);
> > +		printk(": returned with %s\n", msg);
>
> These printk's need to use a KERN_* level.
>
> > +	}
> > +	return 0;
> > +}

The msg above comes from the initcall_debug code in the tree.

> > +
> > +static int __init wait_for_initcall(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +extern initcall_t __initcall_start[], __initcall_end[];
> > +extern initcall_depend_t __initcall_depend_start[],
> > __initcall_depend_end[]; +
> > +static initcall_t* __initdata initcall_pt;
> > +static initcall_depend_t* __initdata initcall_depend_pt;
> > +static struct mutex __initdata initcall_pt_mutex;
> > +static struct mutex __initdata initcall_depend_pt_mutex;
> > +
> > +#define NR_INIT_THREADS 2
>
> What is the significance of the value 2 here?

This is the thread number which would be run at the same time. Should be able 
to config...

>
> > +static initcall_t* __initdata thread_pt[NR_INIT_THREADS];
> > +static struct mutex __initdata thread_mutex[NR_INIT_THREADS];
> > +static atomic_t __initdata threading_count =
> > ATOMIC_INIT(NR_INIT_THREADS); +static struct completion __initdata
> > initcall_completion;
> > +
> > +static atomic_t __initdata initcall_executing_count = ATOMIC_INIT(0);
> > +
> > +static void __init wait_for_depend(initcall_depend_t* call_depend, int
> > thread_no)
> > +{
> > +	int i;
> > +
> > +	while (*call_depend->call == *thread_pt[thread_no]) {
> > +		for (i = 0; i < NR_INIT_THREADS; i++)
>
> style: { goes at end of line above, not on line by itself.
>
> > +		{
> > +			if (i == thread_no) continue;
>
> continue; goes on line by itself.
>
> > +			mutex_lock(&thread_mutex[i]);
> > +
> > +			/* when the request function was not executed, wait for it*/
> > +			while (call_depend->prev.addr >= thread_pt[i]) {
> > +				mutex_unlock(&thread_mutex[i]);
> > +				yield();
> > +				mutex_lock(&thread_mutex[i]);
> > +			}
> > +
> > +			mutex_unlock(&thread_mutex[i]);
> >  		}
> > +		++call_depend;
> > +	}
> > +}
> > +
> > +static int __init initcall_process(void *data)
> > +{
> > +	long thread_no = (long)data;
> > +
> > +	initcall_depend_t* call_depend;
> >
> > -		if (result && result != -ENODEV && initcall_debug) {
> > -			sprintf(msgbuf, "error code %d", result);
> > -			msg = msgbuf;
> > +	for (;;) {
> > +		mutex_lock(&initcall_pt_mutex);
> > +
> > +		atomic_inc(&initcall_executing_count);
> > +		if (initcall_pt >= __initcall_end) {
> > +			mutex_unlock(&initcall_pt_mutex);
> > +			break;
> >  		}
> > -		if (preempt_count() != count) {
> > -			msg = "preemption imbalance";
> > -			preempt_count() = count;
> > +
> > +		mutex_lock(&thread_mutex[thread_no]);
> > +		thread_pt[thread_no] = initcall_pt;
> > +		mutex_unlock(&thread_mutex[thread_no]);
> > +
> > +		++initcall_pt;
> > +
> > +		if (*thread_pt[thread_no] == wait_for_initcall) {
> > +
> > +			if (initcall_debug) {
> > +				printk("Wait for %d initcalls to complete.\n",
> > +						atomic_read(&initcall_executing_count) - 1);
>
> printk needs KERN_* level.
> Don't use braces around one-statement blocks.
>
> > +			}
> > +
> > +			while (atomic_read(&initcall_executing_count) != 1) {
> > +				yield();
> > +			}
> > +			mutex_unlock(&initcall_pt_mutex);
> > +			atomic_dec(&initcall_executing_count);
> > +			continue;
> >  		}
> > -		if (irqs_disabled()) {
> > -			msg = "disabled interrupts";
> > -			local_irq_enable();
> > +
> > +		mutex_unlock(&initcall_pt_mutex);
> > +
> > +		mutex_lock(&initcall_depend_pt_mutex);
> > +		if ((initcall_depend_pt < __initcall_depend_end) &&
> > +				(*thread_pt[thread_no] == *initcall_depend_pt->call)) {
> > +			call_depend = initcall_depend_pt;
> > +
> > +			/* find the next initcall dependency */
> > +			while ((initcall_depend_pt < __initcall_depend_end) &&
> > +					(*initcall_depend_pt->call == *call_depend->call))
> > +				++initcall_depend_pt;
> > +			mutex_unlock(&initcall_depend_pt_mutex);
> > +
> > +			wait_for_depend(call_depend, thread_no);
> > +			initcall_run(thread_pt[thread_no]);
> > +		} else {
> > +			mutex_unlock(&initcall_depend_pt_mutex);
> > +
> > +			initcall_run(thread_pt[thread_no]);
> >  		}
> > -		if (msg) {
> > -			printk(KERN_WARNING "initcall at 0x%p", *call);
> > -			print_fn_descriptor_symbol(": %s()",
> > -					(unsigned long) *call);
> > -			printk(": returned with %s\n", msg);
> > +		atomic_dec(&initcall_executing_count);
> > +	}
> > +
> > +	if (initcall_debug) {
> > +		printk("Initcall thread %ld is completed!\n", thread_no);
> > +	}
>
> printk needs KERN_* level.
> No braces.
>
> > +
> > +	if (atomic_dec_and_test(&threading_count)) {
> > +		complete(&initcall_completion);
> > +	}
>
> No braces.
>
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Map the initcall_depend_t.prev.addr from prev.func.
> > + * Only match the first matched function.
> > + */
> > +static void __init map_depend_address(void)
> > +{
> > +	initcall_t* pt;
> > +	initcall_depend_t* dpt;
> > +
> > +	for (dpt = __initcall_depend_start;
> > +			dpt < __initcall_depend_end; ++dpt)
> > +	{
> > +		for (pt = __initcall_start;
> > +				pt < __initcall_end; ++pt) {
> > +			if (*dpt->prev.func == *pt ) {
> > +				dpt->prev.addr = pt;
> > +				break;
> > +			}
> > +		}
> > +		if (pt >= __initcall_end)
> > +			panic("Want to depend on a non-exist initcall!\n");
>
>                                                    non-existent
>
> Is there any reasonable way out of this besides panic()?

Yeah, I shouldn't use panic here. In fact, if dpt->prev.func is not found, 
which the initcall it depends is not exist in current image. But we can 
ignore it to provide more flexibly. 

>
> > +	}
> > +}
> > +
> > +static void __init do_initcalls(void)
> > +{
> > +	long i;
> > +	struct task_struct* initcall_task[NR_INIT_THREADS];
> > +
> > +	original_count = preempt_count();
> > +
> > +	mutex_init(&initcall_pt_mutex);
> > +	mutex_init(&initcall_depend_pt_mutex);
> > +	init_completion(&initcall_completion);
> > +
> > +	map_depend_address();
> > +
> > +	initcall_pt = __initcall_start;
> > +	initcall_depend_pt = __initcall_depend_start;
> > +
> > +	for (i = 0; i < NR_INIT_THREADS; ++i) {
> > +		mutex_init(&thread_mutex[i]);
> > +	}
>
> Unneeded braces.
>
> > +
> > +	for (i = 0; i < NR_INIT_THREADS; ++i) {
> > +		initcall_task[i] = kthread_run(initcall_process, (long *)i,
> > +				"initcallthread-%d", i);
> > +		if (IS_ERR(initcall_task[i])) {
> > +			panic("Fail to set up initcall process thread...\n");
> >  		}
> >  	}
> >
> > +	wait_for_completion(&initcall_completion);
> > +
> >  	/* Make sure there is no pending stuff from the initcall sequence */
> >  	flush_scheduled_work();
> >  }
> >
> > +core_initcall_sync(wait_for_initcall);
> > +postcore_initcall_sync(wait_for_initcall);
> > +arch_initcall_sync(wait_for_initcall);
> > +subsys_initcall_sync(wait_for_initcall);
> > +fs_initcall_sync(wait_for_initcall);
> > +device_initcall_sync(wait_for_initcall);
> > +late_initcall_sync(wait_for_initcall);
> > +
> >  /*
> >   * Ok, the machine is now initialized. None of the devices
> >   * have been touched yet, but the CPU subsystem is up and
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***

Thanks!

-- 
regards
Yang, Sheng
