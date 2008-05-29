Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYE2MZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYE2MZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYE2MZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:25:20 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:64319 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbYE2MZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:25:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMFACM7PkhMQWqh/2dsb2JhbACBVa4H
Date: Thu, 29 May 2008 08:25:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Yeh <jason.yeh@amd.com>, Philippe Elie <phil.el@wanadoo.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch 1/1] Oprofile Multiplexing
Message-ID: <20080529122514.GA17191@Krystal>
References: <483C6A58.3010008@amd.com> <20080529011035.9e12e5d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080529011035.9e12e5d7.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:14:32 up 90 days,  8:25,  3 users,  load average: 0.24, 0.89,
	1.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 27 May 2008 15:08:56 -0500 Jason Yeh <jason.yeh@amd.com> wrote:
> 
> > hi,
> > 
> > This patch adds multiplexing functionality to Oprofile driver and also
> > the AMD arch specific handler. Basically, the mechanism schedules delayed
> > work and swaps the contents of event counter and event control in arch
> > specific handler when the scheduled work is executed.
> > 
> > Please let me know if you have any comment or question. Thanks.
> > 
> 
> In the next version, please fully describe the patch in the changelog. 
> Such as: what "multiplexing" is!
> 
> Your email client has space-stuffed the patch. 
> http://mbligh.org/linuxdocs/Email/Clients/Thunderbird has repair
> instructions.
> 
> Your patch has a number of trivial coding-style errors.  Please feed it
> through scripts/checkpatch.pl and consider the result.
> 

I have been contemplating the idea of using the performance counters in
the LTTng kernel tracer for quite a while, but I see the the underlying
implementations often deal with those counters as if they were
per-process ressources. Given those ressources are limited amongst the
whole system, would it make sense to allow an in-kernel consumer to
connect to some of these counters on a per-CPU basis and return a
"ressource not available error" to userspace when it tries to connect to
them ? (and also to kick out a userspace reader when an higher priority
in-kernel request is done, which implies that the "read" operation may
fail)

It could already be considered, but when I see such counter multiplexing
proposals, I am always afraid of how this is designed to work with
tracer interested in system-wide counters.

Thanks,

Mathieu

> > 
> > ---
> > 
> >   arch/x86/oprofile/nmi_int.c         |   22 ++++++
> >   arch/x86/oprofile/op_counter.h      |    3
> >   arch/x86/oprofile/op_model_athlon.c |  125 +++++++++++++++++++++++++++++-------
> >   arch/x86/oprofile/op_x86_model.h    |    2
> >   drivers/oprofile/oprof.c            |   48 +++++++++++++
> >   drivers/oprofile/oprof.h            |    4 -
> >   drivers/oprofile/oprofile_files.c   |   35 +++++++++-
> >   include/linux/oprofile.h            |    3
> 
> It's half an oprofile patch and half an x86 patch.  Please cc the x86
> maintainers and myself on the next version and we'll work out who should
> be merging it.
> 
> Please also cc the oprofile maintainer and mailing list.
> 
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> >   				     unsigned long val, void *data)
> >   {
> > @@ -326,6 +344,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
> >   		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
> >   		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
> >   		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
> > +		counter_config[i].save_count_low = 0;
> >   	}
> > 
> >   	return 0;
> > @@ -419,7 +438,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
> >   			break;
> >   		case 0x10:
> >   			model = &op_athlon_spec;
> > -			cpu_type = "x86-64/family10";
> > +			cpu_type = "x86-64/family10h";
> 
> Are there any userspace compatibility implications here?
> 
> 
> >   			break;
> >   		}
> >   		break;
> > @@ -455,6 +474,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
> >   	ops->start = nmi_start;
> >   	ops->stop = nmi_stop;
> >   	ops->cpu_type = cpu_type;
> > +	ops->switch_events = nmi_switch_event;
> >   	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
> >   	return 0;
> >   }
> > diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
> > index 2880b15..786d6e0 100644
> > --- a/arch/x86/oprofile/op_counter.h
> > +++ b/arch/x86/oprofile/op_counter.h
> > @@ -10,13 +10,14 @@
> >   #ifndef OP_COUNTER_H
> >   #define OP_COUNTER_H
> > 
> > -#define OP_MAX_COUNTER 8
> > +#define OP_MAX_COUNTER 32
> 
> What weas the reason for changing this?
> 
> >   /* Per-perfctr configuration as set via
> >    * oprofilefs.
> >    */
> >   struct op_counter_config {
> >           unsigned long count;
> > +		unsigned long save_count_low;
> 
> Extra tab.
> 
> >           unsigned long enabled;
> >           unsigned long event;
> >           unsigned long kernel;
> > diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
> > index 3d53487..2684683 100644
> > --- a/arch/x86/oprofile/op_model_athlon.c
> > +++ b/arch/x86/oprofile/op_model_athlon.c
> > @@ -11,6 +11,7 @@
> >    */
> > 
> >   #include <linux/oprofile.h>
> > +#include <linux/percpu.h>
> >   #include <asm/ptrace.h>
> >   #include <asm/msr.h>
> >   #include <asm/nmi.h>
> > @@ -18,8 +19,10 @@
> >   #include "op_x86_model.h"
> >   #include "op_counter.h"
> > 
> > -#define NUM_COUNTERS 4
> > -#define NUM_CONTROLS 4
> > +#define NUM_COUNTERS 32
> > +#define NUM_HARDWARE_COUNTERS 4
> > +#define NUM_CONTROLS 32
> > +#define NUM_HARDWARE_CONTROLS 4
> 
> reasons?
> 
> >   #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
> >   #define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
> > @@ -43,21 +46,24 @@
> >   #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
> > 
> >   static unsigned long reset_value[NUM_COUNTERS];
> > +DEFINE_PER_CPU(int, switch_index);
> 
> Can be made static.
> 
> >   static void athlon_fill_in_addresses(struct op_msrs * const msrs)
> >   {
> >   	int i;
> > 
> >   	for (i = 0; i < NUM_COUNTERS; i++) {
> > -		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
> > -			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
> > +		int hw_counter = i % NUM_HARDWARE_COUNTERS;
> > + 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + hw_counter))
> > + 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + hw_counter;
> >   		else
> >   			msrs->counters[i].addr = 0;
> >   	}
> > 
> >   	for (i = 0; i < NUM_CONTROLS; i++) {
> > -		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
> > -			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
> > +		int hw_control = i % NUM_HARDWARE_CONTROLS;
> > +		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + hw_control))
> > +			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + hw_control;
> >   		else
> >   			msrs->controls[i].addr = 0;
> >   	}
> > @@ -69,8 +75,15 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
> >   	unsigned int low, high;
> >   	int i;
> > 
> > +	for (i = 0; i < NUM_COUNTERS; ++i) {
> > +		if (counter_config[i].enabled)
> > +			reset_value[i] = counter_config[i].count;
> > +		else
> > +			reset_value[i] = 0;
> > +	}
> 
> Maybe reset_value[] was all-zeroes here?
> 
> >   	/* clear all counters */
> > -	for (i = 0 ; i < NUM_CONTROLS; ++i) {
> > +	for (i = 0 ; i < NUM_HARDWARE_CONTROLS; ++i) {
> 
> checkpatch will complain, even though you're just retaining previous
> bustage.  Feel free to unbust things as you alter them.
> 
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> > +/*
> > + * Quick check to see if multiplexing is necessary.
> > + * The check should be efficient since counters are used
> > + * in ordre.
> > + */
> > +static int athlon_check_multiplexing(struct op_msrs const * const msrs)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!counter_config[NUM_HARDWARE_COUNTERS].count)
> > +		ret = -EINVAL;
> > +	
> > +	return ret;
> > +}
> 
> That was a bit verbose.
> 
> 	return counter_config[NUM_HARDWARE_COUNTERS].count ? 0 : -EINVAL;
> 
> ?
> 
> > +
> >   static int athlon_check_ctrs(struct pt_regs * const regs,
> >   			     struct op_msrs const * const msrs)
> >   {
> >   	unsigned int low, high;
> >   	int i;
> > 
> > -	for (i = 0 ; i < NUM_COUNTERS; ++i) {
> > -		if (!reset_value[i])
> > +	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
> > +		int offset = i + __get_cpu_var(switch_index);
> > +		if (!reset_value[offset])
> >   			continue;
> >   		CTR_READ(low, high, msrs, i);
> >   		if (CTR_OVERFLOWED(low)) {
> > -			oprofile_add_sample(regs, i);
> > -			CTR_WRITE(reset_value[i], msrs, i);
> > +			oprofile_add_sample(regs, offset);
> > +			CTR_WRITE(reset_value[offset], msrs, i);
> >   		}
> >   	}
> 
> Is preemption always disabled by the op_x86_model_spec.check_ctrs()
> caller?  If not we have a race here and warnings will be generated if
> suitable debugging options were enabled.
> 
> We this code runtime tested with all debugging options enabled? 
> Documentation/SubmitChecklist has info about this.
> 
> > @@ -138,13 +166,14 @@ static void athlon_start(struct op_msrs const * const msrs)
> >   {
> >   	unsigned int low, high;
> >   	int i;
> > -	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
> > +	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
> >   		if (reset_value[i]) {
> >   			CTRL_READ(low, high, msrs, i);
> >   			CTRL_SET_ACTIVE(low);
> >   			CTRL_WRITE(low, high, msrs, i);
> >   		}
> >   	}
> > +	__get_cpu_var(switch_index) = 0;
> >   }
> 
> Ditto.
> 
> > 
> > @@ -155,8 +184,8 @@ static void athlon_stop(struct op_msrs const * const msrs)
> > 
> >   	/* Subtle: stop on all counters to avoid race with
> >   	 * setting our pm callback */
> > -	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
> > -		if (!reset_value[i])
> > +	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
> > +		if (!reset_value[i + per_cpu(switch_index, smp_processor_id())])
> >   			continue;
> >   		CTRL_READ(low, high, msrs, i);
> >   		CTRL_SET_INACTIVE(low);
> > @@ -164,15 +193,67 @@ static void athlon_stop(struct op_msrs const * const msrs)
> >   	}
> >   }
> > 
> > +
> > +static void athlon_switch_ctrs(struct op_msrs const * const msrs)
> > +{
> > +	unsigned int low, high;
> > +	int i, s = per_cpu(switch_index, smp_processor_id());
> 
> More dittoes.
> 
> > +	athlon_stop(msrs);
> > +
> > +	/* save the current hw counts */
> > +	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
> > +		int offset = i + s;
> > +		if (!reset_value[offset])
> > +			continue;
> > +		CTR_READ(low, high, msrs, i);
> > +		/* convert counter value to actual count, assume high = -1 */
> > +		counter_config[offset].save_count_low = (unsigned int)-1 - low - 1;
> > +	}
> > +
> > +
> > +	/* move to next eventset */
> > +	s += NUM_HARDWARE_COUNTERS;
> > +	if ((s > NUM_HARDWARE_COUNTERS) || (counter_config[s].count == 0)) {
> > +		per_cpu(switch_index, smp_processor_id()) = 0;
> > +		s = 0;
> > +	} else
> > +		per_cpu(switch_index, smp_processor_id()) = s;
> > +
> > +	/* enable next active counters */
> > +	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
> > +		int offset = i + s;
> > +		if ((counter_config[offset].enabled) && (CTR_IS_RESERVED(msrs,i))) {
> > +			if (unlikely(!counter_config[offset].save_count_low))
> > +				counter_config[offset].save_count_low = counter_config[offset].count;
> > +			CTR_WRITE(counter_config[offset].save_count_low, msrs, i);
> > +			CTRL_READ(low, high, msrs, i);
> > +			CTRL_CLEAR_LO(low);
> > +			CTRL_CLEAR_HI(high);
> > +			CTRL_SET_ENABLE(low);
> > +			CTRL_SET_USR(low, counter_config[offset].user);
> > +			CTRL_SET_KERN(low, counter_config[offset].kernel);
> > +			CTRL_SET_UM(low, counter_config[offset].unit_mask);
> > +			CTRL_SET_EVENT_LOW(low, counter_config[offset].event);
> > +			CTRL_SET_EVENT_HIGH(high, counter_config[offset].event);
> > +			CTRL_SET_HOST_ONLY(high, 0);
> > +			CTRL_SET_GUEST_ONLY(high, 0);
> > +			CTRL_SET_ACTIVE(low);
> > +			CTRL_WRITE(low, high, msrs, i);
> > +		}
> > +	}
> > +}
> > +
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> > @@ -24,6 +25,9 @@ struct oprofile_operations oprofile_ops;
> > 
> >   unsigned long oprofile_started;
> >   unsigned long backtrace_depth;
> > +/* Multiplexing defaults at 5000 useconds */
> > +unsigned long time_slice = 5 * USEC_PER_SEC	;
> 
> static?
> 
> > +struct delayed_work switch_work;
> 
> static?
> 
> Can we use DECLARE_DELAYED_WORK() here?
> 
> >   static unsigned long is_setup;
> >   static DEFINE_MUTEX(start_mutex);
> > 
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> > @@ -123,6 +139,7 @@ void oprofile_stop(void)
> >   		goto out;
> >   	oprofile_ops.stop();
> >   	oprofile_started = 0;
> > +	cancel_delayed_work_sync(&switch_work);
> 
> Whoa.  Yours is that one patch in twenty which remembered to do this.
> 
> >   	/* wake up the daemon to read what remains */
> >   	wake_up_buffer_waiter();
> >   out:
> > @@ -155,6 +172,29 @@ post_sync:
> >   	mutex_unlock(&start_mutex);
> >   }
> > 
> > +int oprofile_set_time_slice(unsigned long val)
> > +{
> > +	int err = 0;
> > +
> > +	mutex_lock(&start_mutex);
> > +
> > +	if (oprofile_started) {
> > +		err = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	if (!oprofile_ops.switch_events) {
> > +		err = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	time_slice = val;
> > +
> > +out:
> > +	mutex_unlock(&start_mutex);
> > +	return err;
> > +
> > +}
> 
> Pity the poor reader who tries to work out what units `val' is in. 
> Better choice of identifiers and addition of some comments would help
> maintainability.
> 
> >   int oprofile_set_backtrace(unsigned long val)
> >   {
> > @@ -179,10 +219,16 @@ out:
> >   	return err;
> >   }
> > 
> > +static void __init oprofile_switch_timer_init(void)
> > +{
> > +	INIT_DELAYED_WORK(&switch_work, switch_worker);
> > +}
> 
> Can be removed if DECLARE_DELAYED_WORK() is used.
> 
> >   static int __init oprofile_init(void)
> >   {
> >   	int err;
> > 
> > +	oprofile_switch_timer_init();
> 
> zap
> 
> >   	err = oprofile_arch_init(&oprofile_ops);
> > 
> >   	if (err < 0 || timer) {
> > diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
> > index 1832365..fc3a2bd 100644
> > --- a/drivers/oprofile/oprof.h
> > +++ b/drivers/oprofile/oprof.h
> > @@ -27,7 +27,8 @@ extern unsigned long fs_buffer_watershed;
> >   extern struct oprofile_operations oprofile_ops;
> >   extern unsigned long oprofile_started;
> >   extern unsigned long backtrace_depth;
> > -
> > +extern unsigned long time_slice;
> 
> It would really help if the identifier were to show the units also. 
> time_slice_nsecs?  time_slice_fortnights?
> 
> >   struct super_block;
> >   struct dentry;
> > 
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> > +static ssize_t time_slice_write(struct file * file, char const __user * buf, size_t count, loff_t * offset)
> > +{
> > +	unsigned long val;
> > +	int retval;
> > +
> > +	if (*offset)
> > +		return -EINVAL;
> > +
> > +	retval = oprofilefs_ulong_from_user(&val, buf, count);
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = oprofile_set_time_slice(val);
> > +
> > +	if (retval)
> > +		return retval;
> > +	return count;
> > +}
> > +
> > +static const struct file_operations time_slice_fops = {
> > +	.read		= time_slice_read,
> > +	.write		= time_slice_write
> 
> It's conventional to add a "," on the last entry here.  So that later
> patches are simpler.
> 
> > +};
> 
> So we have userspace interface changes.  I assume that changes to
> oprofile userspace are in the pipeline?
> 
> >
> > ...
> >
> >   static int profile_exceptions_notify(struct notifier_block *self,
> > @@ -65,6 +65,9 @@ struct oprofile_operations {
> > 
> >   	/* Initiate a stack backtrace. Optional. */
> >   	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
> > +
> > +	/* Multiplex between different events. Optioinal. */
> 
> typo there.
> 
> > +	int (*switch_events)(void);
> >   	/* CPU identification string. */
> >   	char * cpu_type;
> >   };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
