Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZJ3TkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZJ3TkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZJ3TkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:40:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754894AbZJ3TkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:40:19 -0400
Message-ID: <4AEB4125.3030504@sgi.com>
Date: Fri, 30 Oct 2009 12:40:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] x86_64: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233756.941535000@alcatraz.americas.sgi.com>	 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>	 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet> <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
In-Reply-To: <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64: Limit the number of microcode messages

Presented as an example of summarizing startup information,
but as others have pointed out this particular message can be
removed completely from the console log.

Summarize microcode messages to the form:

[    8.961953] microcode: CPU0-23: sig=0x206e5, pf=0x4, revision=0xffff0016
[    8.969494] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

(Note: I need a better method for triggering the summary message.)

Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/microcode_intel.c |   75 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

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
+	kfree(cpusigs);
+	cpusigs_error = 0;
+}
+
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
@@ -165,9 +211,36 @@
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+	if (!cpusigs && !cpusigs_error) {
+		if (!alloc_cpumask_var(&cpusigslist, GFP_KERNEL))
+			cpusigs_error = 1;
+		else {
+			int size = sizeof(*cpusigs) * nr_cpu_ids;
+			cpusigs = kmalloc(size, GFP_KERNEL);
+			if (!cpusigs) {
+				free_cpumask_var(cpusigslist);
+				cpusigs_error = 1;
+			}
+		}
+	}
+
+	/* will only print microcode revision of first cpu if cannot do all */
+	if (cpusigs_error && cpu_num == 0)
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
 

