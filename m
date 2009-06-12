Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbZFLTpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbZFLTpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZFLTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:45:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19850 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbZFLTpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:45:35 -0400
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Date: Fri, 12 Jun 2009 19:45:08 +0000
Subject: RE: linux-next: manual merge of the rr tree with the
 cpufreq-current tree
Thread-Topic: linux-next: manual merge of the rr tree with the
 cpufreq-current tree
Thread-Index: AcnrFUryg2IN6vupT+ik1uKdRzHS6gAaCi7g
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE15E025024C1@GVW0676EXC.americas.hpqcorp.net>
References: <20090612134717.bf81d333.sfr@canb.auug.org.au>
In-Reply-To: <20090612134717.bf81d333.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Thursday, June 11, 2009 10:47 PM
> To: Rusty Russell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; 
> Andrew Morton; Chumbalkar, Nagananda; Dave Jones
> Subject: linux-next: manual merge of the rr tree with the 
> cpufreq-current tree
> 
> Hi Rusty,
> 
> Today's linux-next merge of the rr tree got a conflict in
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c between commits
> ec50b17b706931fb5d2854893cfa4b3f96f19276 ("[CPUFREQ] reduce scope of
> ACPI_PSS_BIOS_BUG_MSG[]") and 97f1bb65966b4276581988755238a1b326fce475
> ("[CPUFREQ] powernow-k8: get drv data for correct CPU") from the
> cpufreq-current tree and commit fd9641cb9b0cd9296a83242164d53517351b6aaa
> ("cpumask: avoid playing with cpus_allowed in powernow-k8.c") from the rr
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Hi Stephen, the changes to powernowk8_get() may not work as intended. Please
see the reason, and also other comments below. FYI, Dave has a request on the
"cpufreq" list to rebase this patch: 
http://www.spinics.net/lists/cpufreq/msg00771.html


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 20c7b99,0e1f6c4..0000000
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@@ -1247,14 -1224,41 +1236,40 @@@ static int 
> powernowk8_verify(struct cpu
>   	return cpufreq_frequency_table_verify(pol, 
> data->powernow_table);
>   }
>   
> + struct init_on_cpu {
> + 	struct powernow_k8_data *data;
> + 	int rc;
> + };
> + 
> + static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
> + {
> + 	struct init_on_cpu *init_on_cpu = _init_on_cpu;
> + 
> + 	if (pending_bit_stuck()) {
> + 		printk(KERN_ERR PFX "failing init, change 
> pending bit set\n");
> + 		init_on_cpu->rc = -ENODEV;
> + 		return;
> + 	}
> + 
> + 	if (query_current_values_with_pending_wait(init_on_cpu->data)) {
> + 		init_on_cpu->rc = -ENODEV;
> + 		return;
> + 	}
> + 
> + 	if (cpu_family == CPU_OPTERON)
> + 		fidvid_msr_init();
> + 
> + 	init_on_cpu->rc = 0;
> + }
> + 
>   /* per CPU init entry point to the driver */
>   static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
>   {
>  +	static const char ACPI_PSS_BIOS_BUG_MSG[] =
>  +		KERN_ERR FW_BUG PFX "No compatible ACPI _PSS 
> objects found.\n"
>  +		KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
>   	struct powernow_k8_data *data;
> - 	cpumask_t oldmask;
> + 	struct init_on_cpu init_on_cpu;
>   	int rc;
>   
>   	if (!cpu_online(pol->cpu))
> @@@ -1383,11 -1372,23 +1383,21 @@@ static int __devexit 
> powernowk8_cpu_exi
>   	return 0;
>   }
>   
> + static void query_values_on_cpu(void *_err)
> + {
> + 	int *err = _err;
> + 	struct powernow_k8_data *data = __get_cpu_var(powernow_data);
> + 

"data" has only local scope. So, powernowk8_get() is not using this data.

Prior equivalent code used to sanity check "data" before calling the function 
below. The sanity check was introduced with this commit:
4211a30349e8d2b724cfb4ce2584604f5e59c299

> + 	*err = query_current_values_with_pending_wait(data);
> + }
> + 
>   static unsigned int powernowk8_get(unsigned int cpu)
>   {
>  -	struct powernow_k8_data *data;
>  +	struct powernow_k8_data *data = per_cpu(powernow_data, cpu);

The above line duplicates what query_values_on_cpu() is now supposed to do on
the given CPU. 

> - 	cpumask_t oldmask = current->cpus_allowed;
>   	unsigned int khz = 0;
> + 	unsigned int first;

The line above seems unnecessary, because smp_call_function_single() should
be called with "cpu", not "first".


> + 	int err;
> + 
>  -	first = cpumask_first(cpu_core_mask(cpu));
>  -	data = per_cpu(powernow_data, first);
>   
>   	if (!data)
>   		return -EINVAL;
> 

The above is not actually sanity checking "data" from query_values_on_cpu(). 

- naga -

