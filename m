Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZE0Dz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZE0Dz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZE0DzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:55:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49226 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZE0DzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:55:13 -0400
Date: Wed, 27 May 2009 13:55:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20090527135507.52d8d694.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/x86/kernel/cpu/cpufreq/powernow-k8.c between commit
df1829770db415dc5a5ed5ada3bd70176c6f0a01 ("[CPUFREQ] powernow-k8 cleanup
msg if BIOS does not export ACPI _PSS cpufreq data") from Linus' tree and
commit acff715b1f07d1e8366f75ef918233db7a849445 ("cpumask: avoid playing
with cpus_allowed in powernow-k8.c") from the rr tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 35ff069,e9c6f77..0000000
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@@ -1249,16 -1211,35 +1245,38 @@@ static int powernowk8_verify(struct cpu
  	return cpufreq_frequency_table_verify(pol, data->powernow_table);
  }
  
+ static long __cpuinit powernowk8_cpu_init_on_cpu(void *_data)
+ {
+ 	struct powernow_k8_data *data = _data;
+ 
+ 	if (smp_processor_id() != data->cpu) {
+ 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", data->cpu);
+ 		return -EIO;
+ 	}
+ 
+ 	if (pending_bit_stuck()) {
+ 		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+ 		return -ENODEV;
+ 	}
+ 
+ 	if (query_current_values_with_pending_wait(data))
+ 		return -ENODEV;
+ 
+ 	if (cpu_family == CPU_OPTERON)
+ 		fidvid_msr_init();
+ 
+ 	return 0;
+ }
+ 
 +static const char ACPI_PSS_BIOS_BUG_MSG[] =
 +	KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
 +	KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
 +
  /* per CPU init entry point to the driver */
  static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
  {
  	struct powernow_k8_data *data;
- 	cpumask_t oldmask;
  	int rc;
 -	static int print_once;
  
  	if (!cpu_online(pol->cpu))
  		return -ENODEV;
