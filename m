Return-Path: <linux-kernel-owner+w=401wt.eu-S1764729AbZAPJfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764729AbZAPJfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZAPJe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:34:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42225 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZAPJez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:34:55 -0500
Date: Fri, 16 Jan 2009 10:34:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
Message-ID: <20090116093442.GE4305@elte.hu>
References: <49704DF6.8040205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49704DF6.8040205@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -104,7 +104,7 @@ static struct microcode_ops *microcode_ops;
>  /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
>  static DEFINE_MUTEX(microcode_mutex);
>  
> -struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
> +struct ucode_cpu_info *ucode_cpu_info;
>  EXPORT_SYMBOL_GPL(ucode_cpu_info);
>  
>  #ifdef CONFIG_MICROCODE_OLD_INTERFACE
> @@ -471,6 +471,13 @@ static int __init microcode_init(void)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(0);
>  	int error;
> +	size_t size = sizeof(*ucode_cpu_info) * nr_cpu_ids;
> +
> +	ucode_cpu_info = kmalloc(size, GFP_KERNEL);
> +	if (!ucode_cpu_info) {
> +		WARN(1, "CPU: cannot allocate microcode info structure\n");
> +		return -ENOMEM;
> +	}
>  
>  	if (c->x86_vendor == X86_VENDOR_INTEL)
>  		microcode_ops = init_intel_microcode();

look how this code continues:

        else if (c->x86_vendor == X86_VENDOR_AMD)
                microcode_ops = init_amd_microcode();

        if (!microcode_ops) {
                printk(KERN_ERR "microcode: no support for this CPU vendor\n");
                return -ENODEV;
        }

see the memory leak? Again, this patch too is trivially broken.

> commit beec9183a43f8a42f5b790326a3b120a3b513590
> Author: Mike Travis <travis@sgi.com>
> Date:   Fri Jan 16 00:22:33 2009 -0800
> 
>     xen: reduce static memory usage

this one looks good in a quick check but please send it to Jeremy first or 
get his Ack.

	Ingo
