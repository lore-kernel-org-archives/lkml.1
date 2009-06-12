Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbZFLEVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbZFLEVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZFLEVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:21:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37029 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZFLEVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:21:39 -0400
Date: Fri, 12 Jun 2009 13:47:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       Dave Jones <davej@redhat.com>
Subject: linux-next: manual merge of the rr tree with the cpufreq-current
 tree
Message-Id: <20090612134717.bf81d333.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/x86/kernel/cpu/cpufreq/powernow-k8.c between commits
ec50b17b706931fb5d2854893cfa4b3f96f19276 ("[CPUFREQ] reduce scope of
ACPI_PSS_BIOS_BUG_MSG[]") and 97f1bb65966b4276581988755238a1b326fce475
("[CPUFREQ] powernow-k8: get drv data for correct CPU") from the
cpufreq-current tree and commit fd9641cb9b0cd9296a83242164d53517351b6aaa
("cpumask: avoid playing with cpus_allowed in powernow-k8.c") from the rr
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 20c7b99,0e1f6c4..0000000
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@@ -1247,14 -1224,41 +1236,40 @@@ static int powernowk8_verify(struct cpu
  	return cpufreq_frequency_table_verify(pol, data->powernow_table);
  }
  
+ struct init_on_cpu {
+ 	struct powernow_k8_data *data;
+ 	int rc;
+ };
+ 
+ static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
+ {
+ 	struct init_on_cpu *init_on_cpu = _init_on_cpu;
+ 
+ 	if (pending_bit_stuck()) {
+ 		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+ 		init_on_cpu->rc = -ENODEV;
+ 		return;
+ 	}
+ 
+ 	if (query_current_values_with_pending_wait(init_on_cpu->data)) {
+ 		init_on_cpu->rc = -ENODEV;
+ 		return;
+ 	}
+ 
+ 	if (cpu_family == CPU_OPTERON)
+ 		fidvid_msr_init();
+ 
+ 	init_on_cpu->rc = 0;
+ }
+ 
  /* per CPU init entry point to the driver */
  static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
  {
 +	static const char ACPI_PSS_BIOS_BUG_MSG[] =
 +		KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
 +		KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
  	struct powernow_k8_data *data;
- 	cpumask_t oldmask;
+ 	struct init_on_cpu init_on_cpu;
  	int rc;
  
  	if (!cpu_online(pol->cpu))
@@@ -1383,11 -1372,23 +1383,21 @@@ static int __devexit powernowk8_cpu_exi
  	return 0;
  }
  
+ static void query_values_on_cpu(void *_err)
+ {
+ 	int *err = _err;
+ 	struct powernow_k8_data *data = __get_cpu_var(powernow_data);
+ 
+ 	*err = query_current_values_with_pending_wait(data);
+ }
+ 
  static unsigned int powernowk8_get(unsigned int cpu)
  {
 -	struct powernow_k8_data *data;
 +	struct powernow_k8_data *data = per_cpu(powernow_data, cpu);
- 	cpumask_t oldmask = current->cpus_allowed;
  	unsigned int khz = 0;
+ 	unsigned int first;
+ 	int err;
+ 
 -	first = cpumask_first(cpu_core_mask(cpu));
 -	data = per_cpu(powernow_data, first);
  
  	if (!data)
  		return -EINVAL;
