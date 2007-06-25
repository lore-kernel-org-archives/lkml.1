Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbXFYWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbXFYWF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXFYWFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:05:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbXFYWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:05:20 -0400
Message-ID: <46803C1D.2040009@redhat.com>
Date: Mon, 25 Jun 2007 18:05:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Loic Prylli <loic@myri.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] MTRR: Fix race causing set_mtrr to go into infinite loop
References: <468035BC.9080008@myri.com>
In-Reply-To: <468035BC.9080008@myri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 05:38 PM, Loic Prylli wrote:

[cc: Andi]

> Processors synchronization in set_mtrr requires the .gate field
> to be set after .count field is properly initialized. Without an explicit
> barrier, the compiler was reordering those memory stores. That was sometimes
> causing a processor (in ipi_handler) to see the .gate change and
> decrement .count before the latter is set by set_mtrr() (which
> then hangs in a infinite loop with irqs disabled).
> 
> Signed-off-by: Loic Prylli <loic@myri.com>
> ---
>  arch/i386/kernel/cpu/mtrr/main.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
> index 55b0051..75dc6d5 100644
> --- a/arch/i386/kernel/cpu/mtrr/main.c
> +++ b/arch/i386/kernel/cpu/mtrr/main.c
> @@ -229,6 +229,8 @@ static void set_mtrr(unsigned int reg, unsigned long base,
>  	data.smp_size = size;
>  	data.smp_type = type;
>  	atomic_set(&data.count, num_booting_cpus() - 1);
> +	/* make sure data.count is visible before unleashing other CPUs */
> +	smp_wmb();
>  	atomic_set(&data.gate,0);
>  
>  	/*  Start the ball rolling on other CPUs  */
> @@ -242,6 +244,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
>  
>  	/* ok, reset count and toggle gate */
>  	atomic_set(&data.count, num_booting_cpus() - 1);
> +	smp_wmb();
>  	atomic_set(&data.gate,1);
>  
>  	/* do our MTRR business */
> @@ -260,6 +263,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
>  		cpu_relax();
>  
>  	atomic_set(&data.count, num_booting_cpus() - 1);
> +	smp_wmb();
>  	atomic_set(&data.gate,0);
>  
>  	/*
