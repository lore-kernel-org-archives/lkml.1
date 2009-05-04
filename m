Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZEDS3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZEDS3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZEDS3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:29:31 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:58966
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751911AbZEDS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:29:30 -0400
X-BigFish: VPS9(zzzz1202hzzz32i6bh15fn43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KJ4U0Q-02-RC0-01
Date: Mon, 4 May 2009 20:28:59 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: x86: changed output in /proc/cpuinfo for siblings
Message-ID: <20090504182859.GA29045@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 May 2009 18:29:20.0994 (UTC) FILETIME=[3DE82C20:01C9CCE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7ad728f98162cb1af06a85b2a5fc422dddd4fb78
(cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t)
changed the output of /proc/cpuinfo for siblings:

Example on an AMD Phenom:

  physical id   : 0
  siblings : 1
  core id	   : 3
  cpu cores  : 4

Before that commit it was:

  physical id	: 0
  siblings : 4
  core id	   : 3
  cpu cores  : 4

Instead of cpu_core_mask it now uses cpu_sibling_mask to count siblings.
This is due to the following hunk of above commit:

  --- a/arch/x86/kernel/cpu/proc.c
  +++ b/arch/x86/kernel/cpu/proc.c
  @@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinf
          if (c->x86_max_cores * smp_num_siblings > 1) {
                  seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
                  seq_printf(m, "siblings\t: %d\n",
  -                          cpus_weight(per_cpu(cpu_core_map, cpu)));
  +                          cpumask_weight(cpu_sibling_mask(cpu)));
                  seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
                  seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
                  seq_printf(m, "apicid\t\t: %d\n", c->apicid);

Was this the intention or just a mistake?
In the latter case attached patch reverts this hunk.


Regards,

Andreas

---
x86: show number of core_siblings instead of thread_siblings in /proc/cpuinfo

Commit 7ad728f98162cb1af06a85b2a5fc422dddd4fb78 (cpumask: x86: convert
cpu_sibling_map/cpu_core_map to cpumask_var_t) changed the value for
siblings in /proc/cpuinfo to be the number of thread_siblings instead
of core_siblings.

Revert the respective hunk to restore the old behavior.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..d5e3039 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_sibling_mask(cpu)));
+			   cpumask_weight(cpu_core_mask(cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);


