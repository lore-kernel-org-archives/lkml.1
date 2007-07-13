Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXGMAJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXGMAJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXGMAJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:09:34 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:49746 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXGMAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:09:33 -0400
Date: Thu, 12 Jul 2007 17:09:30 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
Subject: [patch] Avoid too many remote cpu references due to /proc/stat
Message-ID: <20070713000930.GB11942@localdomain>
References: <20070713000615.GA11942@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713000615.GA11942@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 05:06:15PM -0700, Ravikiran G Thirumalai wrote:
> Too many remote cpu references due to /proc/stat.
> 
> On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> On every call to kstat_irqs, the process brings in per-cpu data from all
> online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> /proc/stat is parsed by common commands like top, who etc, causing
> lots of cacheline transfers
> 
> This statistic seems useless. Other 'big iron' arches disable this.
> Can we disable computing/reporting this statistic?  This piece of
> statistic is not human readable on x86_64 anymore,
> 
> If not, can we optimize computing this statistic so as to avoid
> too many remote references (patch to follow)

Optimize show_stat to collect per-irq information just once.

On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
On every call to kstat_irqs, the process brings in per-cpu data from all
online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
Considering the fact that we already compute this value per-cpu, we can
save on the remote references as below.

Signed-off-by: Alok N Kataria <alok.kataria@calsoftinc.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6.22/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.22.orig/fs/proc/proc_misc.c	2007-07-11 14:32:33.013197741 -0700
+++ linux-2.6.22/fs/proc/proc_misc.c	2007-07-12 16:28:24.871389279 -0700
@@ -443,6 +443,11 @@ static int show_stat(struct seq_file *p,
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 sum = 0;
+	unsigned int *per_irq_sum;
+
+	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	if (!per_irq_sum)
+		return -ENOMEM;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -461,8 +466,11 @@ static int show_stat(struct seq_file *p,
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		for (j = 0 ; j < NR_IRQS ; j++)
-			sum += kstat_cpu(i).irqs[j];
+		for (j = 0 ; j < NR_IRQS ; j++) {
+			unsigned int temp = kstat_cpu(i).irqs[j];
+			sum += temp;
+			per_irq_sum[j] += temp;
+		}
 	}
 
 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu\n",
@@ -500,7 +508,7 @@ static int show_stat(struct seq_file *p,
 
 #if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64)
 	for (i = 0; i < NR_IRQS; i++)
-		seq_printf(p, " %u", kstat_irqs(i));
+		seq_printf(p, " %u", per_irq_sum[i]);
 #endif
 
 	seq_printf(p,
@@ -515,6 +523,7 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
+	kfree(per_irq_sum);
 	return 0;
 }
 
