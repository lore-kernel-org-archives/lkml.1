Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZDEVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZDEVjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 17:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbZDEVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 17:39:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285AbZDEVj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 17:39:27 -0400
Date: Sun, 5 Apr 2009 23:38:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Levon <levon@movementarian.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH] x86, oprofile: fix P4 oprofile CPU setup bug
Message-ID: <20090405213828.GA1059@elte.hu>
References: <1238958725.3522.1.camel@ht.satnam> <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain> <1238962495.3301.0.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238962495.3301.0.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> > Of course, this is all ancient code, so whatever. But I really 
> > think this patch is actively bad - it just hides the issue 
> > rather than fixing anything.
> 
> Subject: [PATCH] x86: fix BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/3319
> 
> Fixed this bug on P4 HT machine:
> [  474.968698] BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/3319
> [  474.968711] caller is get_stagger+0xe/0x2c
> [  474.968716] Pid: 3319, comm: oprofiled Not tainted 2.6.29 #8
> [  474.968720] Call Trace:
> [  474.968730]  [<c03dee3a>] ? printk+0x14/0x16
> [  474.968737]  [<c021bcb8>] debug_smp_processor_id+0xa4/0xb8
> [  474.968742]  [<c034d64d>] get_stagger+0xe/0x2c
> [  474.968747]  [<c034daa7>] p4_fill_in_addresses+0x33/0x2d4
> [  474.968751]  [<c034cc06>] nmi_setup+0xce/0x194
> [  474.968756]  [<c034acf9>] oprofile_setup+0x35/0x90
> [  474.968760]  [<c034bc55>] event_buffer_open+0x47/0x63
> [  474.968766]  [<c0179a8d>] __dentry_open+0x148/0x237
> [  474.968770]  [<c0179c20>] nameidata_to_filp+0x31/0x48
> [  474.968775]  [<c034bc0e>] ? event_buffer_open+0x0/0x63
> [  474.968780]  [<c018493e>] do_filp_open+0x335/0x660
> [  474.968786]  [<c0161f85>] ? lru_cache_add_lru+0x2c/0x2e
> [  474.968792]  [<c0171808>] ? page_add_new_anon_rmap+0x5d/0x6a
> [  474.968797]  [<c017985d>] do_sys_open+0x47/0xc1
> [  474.968801]  [<c0179923>] sys_open+0x23/0x2b
> [  474.968806]  [<c01029f4>] sysenter_do_call+0x12/0x26
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/oprofile/op_model_p4.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
> index 4c4a51c..8db034d 100644
> --- a/arch/x86/oprofile/op_model_p4.c
> +++ b/arch/x86/oprofile/op_model_p4.c
> @@ -379,12 +379,18 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
>  static unsigned int get_stagger(void)
>  {
>  #ifdef CONFIG_SMP
> -	int cpu = smp_processor_id();
> +	int cpu = get_cpu();
>  	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
>  #endif
>  	return 0;
>  }
>  
> +static inline void put_stagger(void)
> +{
> +#ifdef CONFIG_SMP
> +	put_cpu();
> +#endif
> +}

Hm, you only seem to be looking at solving that warning message, and 
your interest does not seem to go outside of that scope at all. Your 
first fix was to make the message go away, your second fix minimally 
(tried to address) the review from Linus and did a mechanic change 
to make the message go away.

This second change was actually subtly worse than the first one: 
because it spread the uncleanliness elsewhere. The getting of 
'stagger' is in no way central to the code, it does not denote 
critical sections at all.

It is an internal detail that should not matter to preemptability. 
Now you changed it to get/put the preemption count, but the code was 
not improved at all - we just got more churn.

The real fix would be to go to the right abstraction level and 
realize how these MSRs are set up by the oprofile code, and put all 
the MSR reads and writes into one non-preempt section.

Could you please test the patch below? (Totally untested and 
everything.) Please dont just check whether the warning went away, 
but also whether Oprofile still works correctly on your P4/HT box.

I would not be surprised if this patch was a Oprofile fix for HT 
P4's where two CPU siblings share the PMU resources - but i dont 
have the hardware to test it.

Robert, Thomas, what do you think?

Thanks,

	Ingo

--------------------->

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 5 Apr 2009 23:19:00 +0200
Subject: [PATCH] x86, oprofile: fix P4 oprofile CPU setup bug

Impact: fix stagger setting and preemption warning

Jaswinder Singh Rajput reported that this warning triggers on
his P4 box if he starts oprofile:

[  474.968698] BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/3319
[  474.968711] caller is get_stagger+0xe/0x2c
[  474.968716] Pid: 3319, comm: oprofiled Not tainted 2.6.29 #8
[  474.968720] Call Trace:
[  474.968730]  [<c03dee3a>] ? printk+0x14/0x16
[  474.968737]  [<c021bcb8>] debug_smp_processor_id+0xa4/0xb8
[  474.968742]  [<c034d64d>] get_stagger+0xe/0x2c
[  474.968747]  [<c034daa7>] p4_fill_in_addresses+0x33/0x2d4
[  474.968751]  [<c034cc06>] nmi_setup+0xce/0x194
[  474.968756]  [<c034acf9>] oprofile_setup+0x35/0x90
[  474.968760]  [<c034bc55>] event_buffer_open+0x47/0x63
[  474.968766]  [<c0179a8d>] __dentry_open+0x148/0x237
[  474.968770]  [<c0179c20>] nameidata_to_filp+0x31/0x48
[  474.968775]  [<c034bc0e>] ? event_buffer_open+0x0/0x63
[  474.968780]  [<c018493e>] do_filp_open+0x335/0x660
[  474.968786]  [<c0161f85>] ? lru_cache_add_lru+0x2c/0x2e
[  474.968792]  [<c0171808>] ? page_add_new_anon_rmap+0x5d/0x6a
[  474.968797]  [<c017985d>] do_sys_open+0x47/0xc1
[  474.968801]  [<c0179923>] sys_open+0x23/0x2b
[  474.968806]  [<c01029f4>] sysenter_do_call+0x12/0x26

This warning at first sight looks like a false positive - the call
to p4_fill_in_addresses() does not have to be preemptible in itself:
we set up MSR parameters of one of the CPUs, which parameters are
symmetric on all CPUs so this function can be called on any other CPU.

But the 'stagger' value depends on the _current_ CPU's value, so here
we set up CPU0's stagger to the wrong value ... 50% of the time.

This code is fragile for another reason as well: should we ever rely
on running on the CPU whole MSR parameters we are changing this code
could break.

So put the whole MSR parametering and setup loop(s) in nmi_setup()
under a single get_cpu()/put_cpu() critical section, and change the
'0' hack to this_cpu.

Reported-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1238962495.3301.0.camel@ht.satnam>
---
 arch/x86/oprofile/nmi_int.c |   47 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c638685..6b3b734 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -140,6 +140,7 @@ static struct notifier_block profile_exceptions_nb = {
 
 static int nmi_setup(void)
 {
+	int this_cpu;
 	int err = 0;
 	int cpu;
 
@@ -152,27 +153,49 @@ static int nmi_setup(void)
 		return err;
 	}
 
-	/* We need to serialize save and setup for HT because the subset
+	/*
+	 * We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
 	 */
 
-	/* Assume saved/restored counters are the same on all CPUs */
-	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	/*
+	 * Assume saved/restored counters are the same on all CPUs,
+	 * and copy the MSR parameter settings of this CPU to the other
+	 * CPUs. Do this all in a critical section: we are running under
+	 * the Oprofile start_mutex which allows preemption.
+	 *
+	 * Non-preemption is not needed per se under the current Oprofile
+	 * implementation, but it is generally wise for any CPU setup work:
+	 */
+	this_cpu = get_cpu();
+
+	model->fill_in_addresses(&per_cpu(cpu_msrs, this_cpu));
+
 	for_each_possible_cpu(cpu) {
-		if (cpu != 0) {
-			memcpy(per_cpu(cpu_msrs, cpu).counters,
-				per_cpu(cpu_msrs, 0).counters,
-				sizeof(struct op_msr) * model->num_counters);
-
-			memcpy(per_cpu(cpu_msrs, cpu).controls,
-				per_cpu(cpu_msrs, 0).controls,
-				sizeof(struct op_msr) * model->num_controls);
-		}
+		/* Skip this CPU, we set up the parameters above: */
+		if (cpu == this_cpu)
+			continue;
 
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+			per_cpu(cpu_msrs, this_cpu).counters,
+			sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+			per_cpu(cpu_msrs, this_cpu).controls,
+			sizeof(struct op_msr) * model->num_controls);
 	}
+
+	/*
+	 * Now that we've set up each CPU's PMU parameters,
+	 * call each CPU and save the old MSR values, then load
+	 * the new settings:
+	 */
 	on_each_cpu(nmi_save_registers, NULL, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
+
+	put_cpu();
+
 	return 0;
 }
 
