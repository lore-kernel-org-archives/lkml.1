Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZCJJCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZCJJCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZCJJB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:01:58 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:21699 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753347AbZCJJB4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:01:56 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KGA92E-01-6X1-01
Date: Tue, 10 Mar 2009 10:01:17 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cpu architecture debug code
Message-ID: <20090310090117.GC20716@alberich.amd.com>
References: <1236494945.2807.2.camel@ht.satnam> <1236582769.2585.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236582769.2585.4.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Mar 2009 09:01:26.0434 (UTC) FILETIME=[CB2AB020:01C9A15E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:42:49PM +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-03-08 at 12:19 +0530, Jaswinder Singh Rajput wrote:
> > The following changes since commit cb553adb4e83bc5314b5a0c397e546a215b19307:
> >   Ingo Molnar (1):
> >         Merge branch 'tracing/printk'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > 
> > Jaswinder Singh Rajput (1):
> >       x86: cpu architecture debug code
> > 

I still doubt that this is going to be useful (I don't see use cases for it).
Nevertheless I have some comments.

> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index c381330..6427a84 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -9,7 +9,7 @@ endif
>  
>  obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
>  obj-y			+= proc.o capflags.o powerflags.o common.o
> -obj-y			+= vmware.o hypervisor.o
> +obj-y			+= vmware.o hypervisor.o cpu_debug.o
>  
>  obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
>  obj-$(CONFIG_X86_64)	+= bugs_64.o

There is no kernel config option and this code will always be
compiled in. Why?

> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> new file mode 100755
> index 0000000..e50d73b
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> @@ -0,0 +1,692 @@

   ...

> +static int cpu_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct cpu_private *priv = seq->private;
> +
> +	if (priv == NULL)
> +		return -EINVAL;
> +
> +	switch (cpu_base[priv->type].flag) {
> +	case CPU_TSS:
> +		smp_call_function_single(priv->cpu, print_stdreg, seq, 1);
> +		break;
> +	case CPU_CR:
> +		smp_call_function_single(priv->cpu, print_cr, seq, 1);
> +		break;
> +	case CPU_DT:
> +		smp_call_function_single(priv->cpu, print_dt, seq, 1);
> +		break;
> +	default:
> +		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
> +		break;
> +	}
> +	seq_printf(seq, "\n");

(As one example.) Please don't print empty lines.

General thoughts/questions:

Your code is not cpu-hotpluggable. The complete debugfs subtree shows up
for all CPUs - including CPUs that are offline. Was this your intention?

How does this (especially dumping of register state) fit into other
kernel debugging facilities, ie.
 - kgdb
 - sysrq


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


