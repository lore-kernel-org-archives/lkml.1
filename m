Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZKFSbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZKFSbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbZKFSbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:31:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759584AbZKFSbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:31:37 -0500
Message-ID: <4AF46B90.8010905@sgi.com>
Date: Fri, 06 Nov 2009 10:31:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dimm <dmitry.adamushko@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 2/2, v2 ] x86-microcode: refactor microcode output
References: <1257192776.5941.11.camel@dimm>
In-Reply-To: <1257192776.5941.11.camel@dimm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



dimm wrote:
> [ resending ]
> 
> 
> patch-2: see the summary in the 1st message.
> 
> summarize_cpu_info() perhaps require some more polishing.
> 
> 
> (Not-yet-)signed-off-by: Dmitry Adaushko <dmitry.adamushko@gmail.com>
> 
> 
> ---
> 
> diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
> index 68fd54c..38011a3 100644
> --- a/arch/x86/include/asm/microcode.h
> +++ b/arch/x86/include/asm/microcode.h
> @@ -26,8 +26,10 @@ struct microcode_ops {
>  	 * are being called.
>  	 * See also the "Synchronization" section in microcode_core.c.
>  	 */
> -	int (*apply_microcode) (int cpu);
> +	int (*apply_microcode) (int cpu, int verbose);
>  	int (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
> +
> +	int (*version_snprintf) (char *buf, int len, struct cpu_signature *csig);
>  };
>  
>  struct ucode_cpu_info {
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index c205d37..0928fb3 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -81,10 +81,14 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
>  		return -1;
>  	}
>  	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
> -	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
>  	return 0;
>  }
>  
> +static int version_snprintf(char *buf, int len, struct cpu_signature *csig)
> +{
> +	return snprintf(buf, len, "patch_level=0x%x\n", csig->rev);
> +}
> +
>  static int get_matching_microcode(int cpu, void *mc, int rev)
>  {
>  	struct microcode_header_amd *mc_header = mc;
> @@ -129,7 +133,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
>  	return 1;
>  }
>  
> -static int apply_microcode_amd(int cpu)
> +static int apply_microcode_amd(int cpu, int verbose)
>  {
>  	u32 rev, dummy;
>  	int cpu_num = raw_smp_processor_id();
> @@ -153,8 +157,8 @@ static int apply_microcode_amd(int cpu)
>  		return -1;
>  	}
>  
> -	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
> -	       cpu, rev);
> +	if (verbose)
> +		printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
>  
>  	return 0;
>  }
> @@ -347,6 +351,7 @@ static struct microcode_ops microcode_amd_ops = {
>  	.request_microcode_fw             = request_microcode_fw,
>  	.collect_cpu_info                 = collect_cpu_info_amd,
>  	.apply_microcode                  = apply_microcode_amd,
> +	.version_snprintf		  = version_snprintf,
>  	.microcode_fini_cpu               = microcode_fini_cpu_amd,
>  };
>  
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index b7ead3a..fb18304 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -138,20 +138,33 @@ static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
>  	return ret;
>  }
>  
> +struct cpu_info_array_ctx {
> +	struct cpu_signature	cpu_sig;
> +	int			err;
> +};
> +
> +static void collect_cpu_info_array(void *arg)
> +{
> +	int cpu = smp_processor_id();
> +	struct cpu_info_array_ctx *ctx = arg;
> +
> +	ctx[cpu].err = microcode_ops->collect_cpu_info(cpu, &ctx[cpu].cpu_sig);
> +}
> +
>  struct apply_microcode_ctx {
> -	int err;
> +	int err, verbose;
>  };
>  
>  static void apply_microcode_local(void *arg)
>  {
>  	struct apply_microcode_ctx *ctx = arg;
>  
> -	ctx->err = microcode_ops->apply_microcode(smp_processor_id());
> +	ctx->err = microcode_ops->apply_microcode(smp_processor_id(), ctx->verbose);
>  }
>  
> -static int apply_microcode_on_target(int cpu)
> +static int apply_microcode_on_target(int cpu, int verbose)
>  {
> -	struct apply_microcode_ctx ctx = { .err = 0 };
> +	struct apply_microcode_ctx ctx = { .err = 0, .verbose = verbose };
>  	int ret;
>  
>  	ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
> @@ -161,6 +174,68 @@ static int apply_microcode_on_target(int cpu)
>  	return ret;
>  }
>  
> +static int summarize_cpu_range(cpumask_var_t range, struct cpu_signature *csig)

Should be  'struct cpumask *range'

cpumask_var_t is only to declare a local cpumask variable.  All cpumasks are now
passed by reference (as a pointer).

With this patch the console still printed for each cpu:

[    2.131142] mce: CPU supports 22 MCE banks
[    2.131177]  ssCC PCss ssPP ssss ssss ss
[    2.211971] mce: CPU supports 22 MCE banks
[    2.212005]  ssCC PCss ssPP ssss ssss ss
[    2.292800] mce: CPU supports 22 MCE banks
[    2.292834]  ssCC PCss ssPP ssss ssss ss
[    2.375624] mce: CPU supports 22 MCE banks
[    2.375658]  ssCC PCss ssPP ssss ssss ss
[    2.456453] mce: CPU supports 22 MCE banks
[    2.456487]  ssCC PCss ssPP ssss ssss ss
[    2.537282] mce: CPU supports 22 MCE banks
[    2.537316]  ssCC PCss ssPP ssss ssss ss                                                                                                                      
....


> +{
> +	char *cpu_str, *ver_str;
> +	int ret = -1;
> +
> +	cpu_str = kmalloc(128, GFP_KERNEL);
> +	ver_str = kmalloc(128, GFP_KERNEL);
> +	if (!cpu_str || !ver_str)
> +		goto out;
> +
> +	cpulist_scnprintf(cpu_str, 128, range);
> +	microcode_ops->version_snprintf(ver_str, 128, csig);
> +
> +	printk(KERN_INFO "microcode: CPU%s: %s\n", cpu_str, ver_str);
> +	ret = 0;
> +out:
> +	if (cpu_str)
> +		kfree(cpu_str);
> +	if (ver_str)
> +		kfree(ver_str);
> +
> +	return ret;
> +}
> +
> +static void summarize_cpu_info(void)
> +{
> +	struct cpu_info_array_ctx *ctx_array;
> +	cpumask_var_t cpulist;
> +	int base, cpu, ret;
> +
> +	if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
> +		return;
> +
> +	ctx_array = kmalloc(nr_cpu_ids * sizeof(*ctx_array), GFP_KERNEL);
> +	if (!ctx_array)
> +		goto out;
> +
> +	ret = on_each_cpu(collect_cpu_info_array, ctx_array, 1);
> +	if (ret)
> +		goto out;
> +
> +	base = cpumask_first(cpu_online_mask);
> +	cpu  = base;
> +	cpumask_set_cpu(cpu, cpulist);
> +
> +	while ((cpu = cpumask_next(cpu, cpu_online_mask)) < nr_cpu_ids) {
> +		if (memcmp(&ctx_array[base].cpu_sig, &ctx_array[cpu].cpu_sig,
> +				sizeof(ctx_array[base].cpu_sig)) != 0) {
> +			summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
> +			cpumask_clear(cpulist);
> +			base = cpu;
> +		}
> +		cpumask_set_cpu(cpu, cpulist);
> +	}
> +	summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
> +
> +out:
> +	free_cpumask_var(cpulist);
> +	if (ctx_array)
> +		kfree(ctx_array);
> +}
> +
>  #ifdef CONFIG_MICROCODE_OLD_INTERFACE
>  static int do_microcode_update(const void __user *buf, size_t size)
>  {
> @@ -175,7 +250,7 @@ static int do_microcode_update(const void __user *buf, size_t size)
>  			error = -1;
>  			break;
>  		} else if (ustate == UCODE_OK)
> -			apply_microcode_on_target(cpu);
> +			apply_microcode_on_target(cpu, 0);
>  	}
>  
>  	return error;
> @@ -203,6 +278,8 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
>  	if (do_microcode_update(buf, len) == 0)
>  		ret = (ssize_t)len;
>  
> +	printk(KERN_INFO "microcode: microcode versions after update...\n");
> +	summarize_cpu_info();
>  	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
> @@ -257,7 +334,7 @@ static int reload_for_cpu(int cpu)
>  
>  	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
>  	if (ustate == UCODE_OK)
> -		apply_microcode_on_target(cpu);
> +		apply_microcode_on_target(cpu, 1);
>  	mutex_unlock(&microcode_mutex);
>  
>  	return (ustate == UCODE_ERROR)? -EINVAL : 0;
> @@ -340,12 +417,12 @@ static enum ucode_state microcode_resume_cpu(int cpu)
>  		return UCODE_NFOUND;
>  
>  	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
> -	apply_microcode_on_target(cpu);
> +	apply_microcode_on_target(cpu, 1);
>  
>  	return UCODE_OK;
>  }
>  
> -static enum ucode_state microcode_init_cpu(int cpu)
> +static enum ucode_state microcode_init_cpu(int cpu, int verbose)
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  	enum ucode_state ustate;
> @@ -360,7 +437,7 @@ static enum ucode_state microcode_init_cpu(int cpu)
>  
>  	if (ustate == UCODE_OK) {
>  		pr_debug("microcode: CPU%d updated upon init\n", cpu);
> -		apply_microcode_on_target(cpu);
> +		apply_microcode_on_target(cpu, verbose);
>  	}
>  
>  	return ustate;
> @@ -379,7 +456,7 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
>  	if (err)
>  		return err;
>  
> -	if (microcode_init_cpu(cpu) == UCODE_ERROR)
> +	if (microcode_init_cpu(cpu, 0) == UCODE_ERROR)
>  		err = -EINVAL;
>  
>  	return err;
> @@ -416,7 +493,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
>  	WARN_ON(cpu != 0);
>  
>  	if (uci->mc)
> -		microcode_ops->apply_microcode(cpu);
> +		microcode_ops->apply_microcode(cpu, 1);
>  
>  	return 0;
>  }
> @@ -440,7 +517,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  		if (action == CPU_ONLINE_FROZEN)
>  			microcode_resume_cpu(cpu);
>  		else
> -			microcode_init_cpu(cpu);
> +			microcode_init_cpu(cpu, 1);
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
>  		pr_debug("microcode: CPU%d added\n", cpu);
> @@ -491,8 +568,14 @@ static int __init microcode_init(void)
>  	get_online_cpus();
>  	mutex_lock(&microcode_mutex);
>  
> +	printk(KERN_INFO "microcode: original microcode versions...\n");
> +	summarize_cpu_info();
> +
>  	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
>  
> +	printk(KERN_INFO "microcode: microcode versions after update...\n");
> +	summarize_cpu_info();
> +
>  	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
> index 6589765..96c5cf5 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -165,12 +165,14 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
>  	/* get the current revision from MSR 0x8B */
>  	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
>  
> -	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
> -			cpu_num, csig->sig, csig->pf, csig->rev);
> -
>  	return 0;
>  }
>  
> +static int version_snprintf(char *buf, int len, struct cpu_signature *csig)
> +{
> +	return snprintf(buf, len, "sig=0x%x, pf=0x%x, revision=0x%x\n", csig->sig, csig->pf, csig->rev);
> +}
> +
>  static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
>  {
>  	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
> @@ -297,7 +299,7 @@ get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
>  	return 0;
>  }
>  
> -static int apply_microcode(int cpu)
> +static int apply_microcode(int cpu, int verbose)
>  {
>  	struct microcode_intel *mc_intel;
>  	struct ucode_cpu_info *uci;
> @@ -332,12 +334,14 @@ static int apply_microcode(int cpu)
>  			cpu_num, mc_intel->hdr.rev);
>  		return -1;
>  	}
> -	printk(KERN_INFO "microcode: CPU%d updated to revision "
> +
> +	if (verbose)
> +		printk(KERN_INFO "microcode: CPU%d updated to revision "
>  			 "0x%x, date = %04x-%02x-%02x \n",
> -		cpu_num, val[1],
> -		mc_intel->hdr.date & 0xffff,
> -		mc_intel->hdr.date >> 24,
> -		(mc_intel->hdr.date >> 16) & 0xff);
> +			cpu_num, val[1],
> +			mc_intel->hdr.date & 0xffff,
> +			mc_intel->hdr.date >> 24,
> +			(mc_intel->hdr.date >> 16) & 0xff);
>  
>  	return 0;
>  }
> @@ -468,6 +472,7 @@ static struct microcode_ops microcode_intel_ops = {
>  	.request_microcode_fw             = request_microcode_fw,
>  	.collect_cpu_info                 = collect_cpu_info,
>  	.apply_microcode                  = apply_microcode,
> +	.version_snprintf		  = version_snprintf,
>  	.microcode_fini_cpu               = microcode_fini_cpu,
>  };
>  
> 
