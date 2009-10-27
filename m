Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZJ0PVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZJ0PVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJ0PVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:21:00 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753009AbZJ0PU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:20:59 -0400
Message-ID: <4AE70FF0.10409@sgi.com>
Date: Tue, 27 Oct 2009 08:21:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233756.941535000@alcatraz.americas.sgi.com>	 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>	 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>	 <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>	 <20091025163704.GE20391@elte.hu> <4AE5EA71.2050304@sgi.com> <b647ffbd0910261311n4ac4471el7a32ac41104cf93b@mail.gmail.com>
In-Reply-To: <b647ffbd0910261311n4ac4471el7a32ac41104cf93b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Another approach is shown below.]

Dmitry Adamushko wrote:
> 2009/10/26 Mike Travis <travis@sgi.com>:
>>
>> Ingo Molnar wrote:
>>> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>>
>>>> 2009/10/24 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>:
>>>>> On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>>>>>>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>>>>> revision=0x%x\n",
>>>>>>> +       if (cpu_num < 4 || !limit_console_output(false))
>>>>>>> +               printk(KERN_INFO
>>>>>>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>>>>> revision=0x%x\n",
>>>>>>>                       cpu_num, csig->sig, csig->pf, csig->rev);
>>>>>>>
>>>>>> Hmm, I guess we wouldn't lose a lot by simply removing those messages
>>>>>> completely. Per-cpu pf/revision is available via /sys anyway.
>>>>> The reason for printing them is that the pf (possibly others?) can
>>>>> change by the update and so the log has this info handy.
>>>> We might store the old sig/pf/revision set as well, export them via
>>>> /sys or/and print them at update-to-new-microcode time.
>>>>
>>>> If it's really so useful to have this info in the log and, at the same
>>>> time, to avoid the flood of messages (which, I guess for the majority
>>>> of systems, are the same) at startup time, we might delay the printout
>>>> until the end of microcode_init(). Then do something like this:
>>>>
>>>> microcode cpu0: up to date version sig, pf, rev          // let's say,
>>>> it was updated by BIOS
>>>> microcode cpus [1 ... 16] : update from sig, pf, rev to sig, pf2, rev2.
>>>>
>>>> Anyway, my humble opinion, is that (at the very least) the current
>>>> patch should be accompanied by a similar version for amd.
>>> yeah. Since we load new microcode on all cpus it's enough to print it for
>>> the boot CPU or so.
>>>
>>> Having the precise microcode version printed (or exposed somewhere in
>>> /sys) is useful - sometimes when there's a weird crash in some prototype CPU
>>> one of the first questions from hw vendors is 'which precise microcode
>>> version was that?'.
>>>
>>>        Ingo
>> I would agree especially in the case where not all the cpus are exactly
>> the same.  But so far, I've only seen variations of the speed of the cpus
>> not it's generic type, in an SSI.  So the version of the microcode was
>> identical in all cases.
> 
> I guess that (at least) a bootup cpu can be updated by BIOS so that it
> may appear to be different.
> Perhaps, cases where some 'broken' cpus have been replaced for others
> with a different "revision" (but still compatible otherwise) might be
> rare but possible (say, big machines with hot-pluggable cpus) ?
> 
> btw., I was thinking of having something like this:
> 
> microcode: cpus [K...L]  platform-specific-format (e.g. for Intel :
> sig, pf, rev)
> microcode: updating...
> microcode: cpus [K...L]  platform-specific-format (e.g. for Intel :
> sig, pf, rev)
> 
> or even just,
> 
> microcode: cpus [ K...L] updated from platform-specific-format-1 to
> platform-specific-format-2
> 
> 
>> Thanks,
>> Mike
>>
> 
> 
> -- Dmitry

Here's another approach...

I wasn't sure how to trigger the printing of the summary, so I winged it.
Looking closer it would appear that perhaps adding a new "summarize"
function to the microcode_ops struct could trigger it?  Note this version
builds but I haven't yet tested it on a live system.

Thanks,
Mike

SGI x86_64 UV: Limit the number of microcode messages

Limit number of microcode messages of the form:

[   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001

Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/microcode_intel.c |   73 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/microcode_intel.c
+++ linux/arch/x86/kernel/microcode_intel.c
@@ -137,6 +137,52 @@
 
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
+static struct cpu_signature *cpusigs;
+static cpumask_var_t cpusigslist;
+static int cpusigs_error;
+
+static void summarize_cpu_info(void)
+{
+	char buf[128];
+	int cpu;
+	cpumask_var_t cpulist;
+
+	if (cpusigs_error || !alloc_cpumask_var(&cpulist, GFP_KERNEL)) {
+		printk(KERN_INFO "Can't print microcode summary\n");
+		return;
+	}
+
+	while ((cpu = cpumask_first(cpusigslist)) < nr_cpu_ids) {
+		struct cpu_signature *csig = &cpusigs[cpu];
+		int ncpu = cpu;
+
+		cpumask_clear(cpulist);
+		cpumask_set_cpu(cpu, cpulist);
+
+		/* gather all cpu info with same data */
+		while ((ncpu = cpumask_next(ncpu, cpusigslist)) < nr_cpu_ids)
+			if (csig->sig == cpusigs[ncpu].sig &&
+			    csig->pf  == cpusigs[ncpu].pf &&
+			    csig->rev == cpusigs[ncpu].rev)
+				cpumask_set_cpu(ncpu, cpulist);
+
+		cpulist_scnprintf(buf, sizeof(buf), cpulist);
+
+		printk(KERN_INFO
+			"microcode: CPU%s: sig=0x%x, pf=0x%x, revision=0x%x\n",
+			buf, csig->sig, csig->pf, csig->rev);
+
+		/* clear bits we just processed */
+		cpumask_xor(cpusigslist, cpusigslist, cpulist);
+	}
+
+	/* cleanup */
+	free_cpumask_var(cpulist);
+	free_cpumask_var(cpusigslist);
+	vfree(cpusigs);
+	cpusigs_error = 0;
+}
+
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
@@ -165,9 +211,34 @@
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+	if (!cpusigs && !cpusigs_error) {
+		if (!alloc_cpumask_var(&cpusigslist, GFP_KERNEL))
+			cpusigs_error = 1;
+		else {
+			cpusigs = vmalloc(sizeof(*cpusigs) * nr_cpu_ids);
+			if (!cpusigs) {
+				free_cpumask_var(cpusigslist);
+				cpusigs_error = 1;
+			}
+		}
+	}
+
+	if (cpusigs_error || cpu_num == 0)
+		printk(KERN_INFO
+			"microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
 			cpu_num, csig->sig, csig->pf, csig->rev);
 
+	else if (!cpusigs_error) {
+		cpusigs[cpu_num].sig = csig->sig;
+		cpusigs[cpu_num].pf = csig->pf;
+		cpusigs[cpu_num].rev = csig->rev;
+		cpumask_set_cpu(cpu_num, cpusigslist);
+
+		/* (XXX Need better method for when to print summary) */
+		if (cpu_num == (num_present_cpus() - 1))
+			summarize_cpu_info();
+	}
+
 	return 0;
 }
 
