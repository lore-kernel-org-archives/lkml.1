Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZAJK6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZAJK6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZAJK5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:57:51 -0500
Received: from ozlabs.org ([203.10.76.45]:56014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZAJK5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:57:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/5] cpumask: convert misc driver functions
Date: Sat, 10 Jan 2009 21:27:36 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ursula Braun <ursula.braun@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
References: <20090107195832.265117000@polaris-admin.engr.sgi.com> <20090107195832.733912000@polaris-admin.engr.sgi.com>
In-Reply-To: <20090107195832.733912000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901102127.38503.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009 06:28:35 Mike Travis wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Impact: use new cpumask API.
> 
> Convert misc driver functions to use struct cpumask.
...
> @@ -593,15 +592,20 @@ static int __cpuinit iucv_cpu_notify(str
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		cpumask = iucv_buffer_cpumask;
> -		cpu_clear(cpu, cpumask);
> -		if (cpus_empty(cpumask))
> +		if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
> +			return NOTIFY_BAD;
> +		cpumask_copy(cpumask, &iucv_buffer_cpumask);
> +		cpumask_clear_cpu(cpu, cpumask);
> +		if (cpumask_empty(cpumask)) {
>  			/* Can't offline last IUCV enabled cpu. */
> +			free_cpumask_var(cpumask);
>  			return NOTIFY_BAD;
> +		}
>  		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
>  		if (cpus_empty(iucv_irq_cpumask))
>  			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
>  						 iucv_allow_cpu, NULL, 1);
> +		free_cpumask_var(cpumask);
>  		break;

Minor nit: this can be done better, actually:

@@ -596,9 +594,7 @@ static int __cpuinit iucv_cpu_notify(str
 	case CPU_DOWN_PREPARE_FROZEN:
 		if (!iucv_path_table)
 			break;
-		cpumask = iucv_buffer_cpumask;
-		cpu_clear(cpu, cpumask);
-		if (cpus_empty(cpumask))
+		if (cpumask_any_but(&iucv_buffer_cpumask, cpu) >= nr_cpu_ids)
 			/* Can't offline last IUCV enabled cpu. */
 			return NOTIFY_BAD;
 		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);

Cheers,
Rusty.
