Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYHZA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYHZA7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 20:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYHZA7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 20:59:06 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:52315 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYHZA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 20:59:05 -0400
Message-ID: <48B354FC.1090001@hypersurf.com>
Date: Mon, 25 Aug 2008 17:57:32 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
References: <48B28F23.1000906@hypersurf.com> <200808251343.18027.arnd@arndb.de>
In-Reply-To: <200808251343.18027.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 25 August 2008, Kevin Diggs wrote:
> 
>>+ * cf750gx.c - cpufreq driver for the dual PLLs in the 750gx
> 
> 
> Thanks for posting this driver and for your attention for detail
> and for documentation in particular. Few people bother to write
> documentation at this level.
> 
> I don't understand enough of cpufreq or your hardware to comment
> on that, but please let me give you a few hints on coding style.
> 
> 
>>+ *  Copyright (C) 2008       kevin Diggs
> 
> 
> Most people list their email address here as well
> 
For reasons I'd rather not go into, my email address is not likely
to remain valid for much longer.
> 
>>+#define cf750gxmChangingPll            (0x80000000)
>>+#define cf750gxmChangingPllBit         (31)
>>+#define cf750gxmTurningIdlePllOff      (0x40000000)
>>+#define cf750gxmTurningIdlePllOffBit   (30)
> 
> 
> constants should be ALL_CAPS, not sIllYCaPS.
> 
Are cf750gxm_CHANGING_PLL and cf750gxm_CHANGING_PLL_BIT_POS ok?
> 
>>+struct pll_750fgx_t {
>>+       unsigned short min_ratio;       /* min bus ratio */
>>+       unsigned short max_ratio;       /* max bus ratio */
>>+       unsigned int min_core;          /* min core frequency per spec (KHz) */
>>+       unsigned int max_core;          /* max core frequency per spec (KHz) */
>>+};
> 
> 
> please drop the _t at the end of the identifier.
> 
done
> 
>>+MODULE_AUTHOR("Kevin Diggs");
>>+MODULE_DESCRIPTION("750GX Dual PLL cpufreq driver");
>>+MODULE_LICENSE("GPL");
> 
> 
> Move this to the end.
> 
done
> 
>>+struct cf750gx_t_call_data {
>>+       struct cpufreq_freqs freqs;
>>+       unsigned long current_pll;
>>+       int idle_pll_off;
>>+};
> 
> 
> drop the _t here, or make explicit what is meant by it.
> 
Now that I look at it the _t is supposed to be at the end. It is
meant to indicate that this is a structure tag or type. I'll
remove it.
> 
>>+static const struct pll_750fgx_t __initdata pll_750fx = {
>>+       .min_ratio = 2,
>>+       .max_ratio = 20,
>>+       .min_core = 400000,
>>+       .max_core = 800000,
>>+};
>>+
>>+static const struct pll_750fgx_t __initdata pll_750gx = {
>>+       .min_ratio = 2,
>>+       .max_ratio = 20,
>>+       .min_core = 500000,
>>+       .max_core = 1000000,
>>+};
> 
> 
> Are these correct on any board? If they can be different
> depending on the board design, it would be better to get
> this data from the device tree.
> 
They are a spceification of the processor itself. Should be
the same for any board using the 750GX (or FX).
> 
>>+static DECLARE_COMPLETION(cf750gx_v_exit_completion);
>>+
>>+static unsigned int override_min_core = 0;
>>+static unsigned int override_max_core = 0;
>>+static unsigned int minmaxmode = 0;
>>+
>>+static unsigned int cf750gx_v_min_core = 0;
>>+static unsigned int cf750gx_v_max_core = 0;
>>+static int cf750gx_v_idle_pll_off = 0;
>>+static int cf750gx_v_min_max_mode = 0;
>>+static unsigned long cf750gx_v_state_bits = 0;
> 
> 
> Is 0 a meaningful value for these? If it just means 'uninitialized',
> then better don't initialize them in the first place, for clarity.
> 
The first 3 are module parameters. For the first 2, 0 means
that they were not set. minmaxmode is a boolean. 0 is the
default of disabled.

When I was initially writing the code I figured I would
need the min and max core frequencies in several places.
As it turns out they are only used in the code
initialization routine (cf750gx_init()). I have made
them locals.

..._idle_pll_off is a boolean for a sysfs attribute. 0 is
the default of disabled.

..._min_max_mode is a boolean to hold the state of
minmaxmode. Seems to be only used to print the current
value.

..._state_bits is a global to maintain state.

Does the PowerPC suffer any performance penalties when
accessing shorts compared to ints? Can I save a few bytes
by using shorts?
> 
>>+static struct cpufreq_frequency_table *cf750gx_v_f_table;
>>+static struct cpufreq_frequency_table *cf750gx_v_freq_table;
>>+static struct cpufreq_frequency_table *cf750gx_v_min_max_freq_table;
>>+
>>+static struct cf750gx_t_call_data cf750gx_v_switch_call_data;
>>+static struct cf750gx_t_call_data cf750gx_v_lock_call_data;
>>+static struct notifier_block cf750gx_v_pll_switch_nb;
>>+static struct notifier_block cf750gx_v_pll_lock_nb;
> 
> 
> Also, in general, try to avoid global variables here, even 
> in file scope (static), but rather put all device specific
> data into a per-device data structure.
> 
How big of a problem is this? I regret the decision to rip
the SMP stuff out. But it is kinda done. If absolutely
necessary I can put these into a structure?
> 
>>+static int cf750gx_pll_switch_cb(struct notifier_block *nb, unsigned long
>>+       action, void *data)
>>+{
>>+struct cf750gx_t_call_data *cd;
>>+unsigned int idle_pll;
>>+unsigned int pll_off_cmd;
>>+unsigned int new_pll;
> 
> 
> The whitespace appears damaged here.
> 
Just a coding style thing. I put declarations (or definitions -
I get the two confused?) on the same indent as the block they are
in. Is this a 15 yard illegal procedure penalty?
> 
>>+       cd = (struct cf750gx_t_call_data *)data;
> 
done
> 
> data is a void pointer, so you don't need the cast, and shouldn't
> have it therefore.
> 
>>+static int cf750gx_pll_lock_cb(struct notifier_block *nb, unsigned long action,
>>+       void *data)
>>+{
>>+struct cf750gx_t_call_data *cd;
>>+
>>+       cd = (struct cf750gx_t_call_data *)data;
> 
> 
> same here.
> 
and done
> 
>>+static int cf750gx_target(struct cpufreq_policy *policy,
>>+                              unsigned int target_freq, unsigned int relation)
>>+{
>>+unsigned int next_index = 0;           /* Index into freq_table */
>>+unsigned int next_freq = 0;            /* next frequency from perf table */
>>+unsigned int next_perf_state = 0;      /* Index from perf table */
>>+int result = 0;
> 
> 
> Don't initialize local variables in the declaration, as that will prevent
> the compiler from warning about uninitialized use.
> 
done
> 
>>+unsigned int pll;
>>+unsigned int new_pll;
>>+unsigned int active_pll;
>>+struct cpufreq_freqs freqs;
>>+struct cpufreq_frequency_table *ft = cf750gx_v_f_table;
> 
> 
> more whitespace damage. Maybe there is something wrong with your
> text editor.
> 
Nope, just a faulty programmer ...
> 
>>+       dprintk(__FILE__">%s(, %u KHz, relation %u)-%d:  on cpu %d\n",
>>+               __func__, target_freq, relation, __LINE__, policy->cpu);
>>+
>>+       if (test_and_set_bit(cf750gxmChangingPllBit, &cf750gx_v_state_bits))
>>+               return -EAGAIN;
>>+
>>+       INIT_COMPLETION(cf750gx_v_exit_completion);
>>+
>>+       result = cpufreq_frequency_table_target(policy,
>>+                                               ft,
>>+                                               target_freq,
>>+                                               relation, &next_index);
>>+
>>+       if (unlikely(result))
>>+               goto cf750gxTargetNoFreq;
> 
> 
> The unlikely() here looks like overoptimization, drop it in favor of
> readability unless you can measure a real-world difference.
> 
This was stolen from the ACPI Processor P-States Driver. Given the
frequency of calls I would guess it does not make a difference.
> 
>>+       if (active_pll) {
>>+       unsigned int current_state;
> 
> 
> whitespace damage.
> 
same here ...
> 
>>+       dprintk(__FILE__">%s()-%d:  Modifying PLL:  0x%x\n", __func__, __LINE__,
>>+               new_pll);
> 
> 
> Please go through all your dprintk and see if you really really need all of them.
> Usually they are useful while you are doing the initial code, but only get in the
> way as soon as it starts working.
> 
This from a code readability standpoint? Or an efficiency one?
I think the cpufreq stuff has a debug configure option that
disables compilation of these unless enabled.
> 
>>+cf750gxTargetOut:
>>+       return result;
>>+
>>+cf750gxTargetNoFreq:
>>+       result = -ENODEV;
>>+
>>+       goto cf750gxTargetUnlock;
>>+cf750gxTargetFreqSet:
>>+       result = 0;
>>+
>>+       goto cf750gxTargetUnlock;
>>+cf750gxTargetUnlock:
>>+       clear_bit(cf750gxmChangingPllBit, &cf750gx_v_state_bits);
>>+       complete(&cf750gx_v_exit_completion);
>>+
>>+       goto cf750gxTargetOut;
> 
> 
> The conventional way to write this would be:
> 
> 	result = -ENODEV;
> 	if (foo)
> 		goto out_unlock;
> 
> 	result = 0;
> 	if (bar)
> 		goto out_unlock;
> 
> 	return 0;
> 
> out_unlock:
> 	clear_bit(cf750gxmChangingPllBit, &cf750gx_v_state_bits);
> 	complete(&cf750gx_v_exit_completion);
> out:
> 	return result;
> 
I'll fix this.
> 
>>+/*     policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL; */
>>+       policy->cpuinfo.transition_latency = pllif_get_latency();
> 
> 
> The comment does not really explain anything. If you just want to disable
> code, use #if 0, but better drop it right away and add a comment about
> what might need changing.
> 
deleted.
> 
>>+       result = cpufreq_frequency_table_cpuinfo(policy, cf750gx_v_f_table);
>>+       if (result)
>>+               goto err_freqfree;
>>+
>>+       cpufreq_frequency_table_get_attr(cf750gx_v_f_table, policy->cpu);
>>+
>>+       cf750gx_v_pll_switch_nb.notifier_call = cf750gx_pll_switch_cb;
>>+       cf750gx_v_pll_switch_nb.next = (struct notifier_block *)
>>+               &cf750gx_v_switch_call_data;
>>+       cf750gx_v_pll_switch_nb.priority = 0;
>>+
>>+       result = pllif_register_pll_switch_cb(&cf750gx_v_pll_switch_nb);
>>+
>>+       cf750gx_v_pll_lock_nb.notifier_call = cf750gx_pll_lock_cb;
>>+       cf750gx_v_pll_lock_nb.next =
>>+               (struct notifier_block *)&cf750gx_v_lock_call_data;
> 
> 
> These casts look wrong, cf750gx_v_lock_call_data is not a notifier_block.
> What are you trying to do here?
> 
Just a little sneaky. I should document in the kernel doc though.
> 
>>+       cf750gx_v_pll_lock_nb.priority = 0;
>>+
>>+       result = pllif_register_pll_lock_cb(&cf750gx_v_pll_lock_nb);
>>+
>>+       return result;
>>+
>>+err_freqfree:
>>+       return result;
>>+}
> 
> 
> The first 'return result' is redundant, drop it.
> 
done.
> 
>>+
>>+static int cf750gx_cpu_exit(struct cpufreq_policy *policy)
>>+{
>>+       dprintk("%s()\n", __func__);
>>+
>>+       /*
>>+        * Wait for any active requests to ripple through before exiting
>>+        */
>>+       wait_for_completion(&cf750gx_v_exit_completion);
> 
> 
> This "wait for anything" use of wait_for_completion looks wrong, 
> because once any other function has done the 'complete', you won't
> wait here any more.
> 
> What exactly are you trying to accomplish with this?
> 
Originall I had something like:

	while(some_bit_is_still_set)
		sleep

I think you suggested I use a completion because it is in
fact simpler than a sleep. Now that I think about it also seems
intuitive to give the system a hint as to when something will
be done. 'complete' just means there is no timer pending (unless,
of course, I screwed up the code).
> 
>>+static int __init cf750gx_init(void)
>>+{
>>+int ret;
>>+unsigned int freq, i, j, rng, bus_clock;
>>+unsigned short min_ratio, max_ratio;
>>+struct cpufreq_frequency_table *tbp;
>>+const struct pll_750fgx_t *pll_defaults;
> 
> 
> whitespace.
> 
> 
>>+       dprintk("%s()\n", __func__);
>>+
>>+       if (!cpu_has_feature(CPU_FTR_DUAL_PLL_750FX))
>>+               return 0;
> 
> 
> Is this purely a feature of the CPU or does it need logic
> in the board design? If you need external hardware for it,
> you need to check the device tree for the presence of that
> hardware.
> 
Purely a feature of the CPU. From what I know, voltage scaling
is an important part of reducing power comsumption. That would
be platform specific code. Anyone know if this is possible for
any 750GX based system? As far as I know it is not possible on
mine?
> 
>>+       if (cf750gx_v_freq_table == NULL) {
>>+               ret = -ENOMEM;
>>+               goto ErrSimple;
>>+       }
> 
> 
> ret = -ENOMEM;
> if (!cf750gx_freq_table)
> 	goto err_simple;
> 
done
> 
> 	Arnd <><
> 
> 

