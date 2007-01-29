Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbXA2TAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbXA2TAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXA2TAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:00:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:16451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbXA2TAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:00:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,253,1167638400"; 
   d="scan'208"; a="193336390:sNHT49564508"
Message-ID: <45BE443B.3080407@intel.com>
Date: Mon, 29 Jan 2007 11:00:11 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable
 to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com> <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2007 19:00:12.0293 (UTC) FILETIME=[B4287B50:01C743D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Auke Kok <auke-jan.h.kok@intel.com> writes:
> 
>> Hi,
>>
>> I've established a regression in the MSI vector/irq allocation routine for both
>> i386 and x86_64. Our test labs repeatedly modprobe/rmmod the e1000 driver for
>> serveral minutes which allocates msi vectors and frees them. These tests have
>> been running fine until 2.6.19.
[snip]
>> I mostly suspect commit 7bd007e480672c99d8656c7b7b12ef0549432c37 at the
>> moment. Perhaps Eric Biederman can help?
> 
> Does this patch fix it for you?  It looks like i386 vector allocate
> did not have logic to look through the set of vectors more than once.

Yes. A few hundred cycles of loading/unloading snd_hda_intel with enable_msi=1 
didn't break it on i386.

I sure hope this can get into 2.6.20!

Auke



> The code in this patch is a simplified version of what we have
> on x86_64.
> 
> Eric
> 
> 
> diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
> index 2424cc9..6a3875f 100644
> --- a/arch/i386/kernel/io_apic.c
> +++ b/arch/i386/kernel/io_apic.c
> @@ -1227,26 +1227,32 @@ static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 }
>  
>  static int __assign_irq_vector(int irq)
>  {
> -	static int current_vector = FIRST_DEVICE_VECTOR, offset = 0;
> -	int vector;
> +	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
> +	int vector, offset, i;
>  
>  	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
>  
>  	if (irq_vector[irq] > 0)
>  		return irq_vector[irq];
>  
> -	current_vector += 8;
> -	if (current_vector == SYSCALL_VECTOR)
> -		current_vector += 8;
> -
> -	if (current_vector >= FIRST_SYSTEM_VECTOR) {
> -		offset++;
> -		if (!(offset % 8))
> -			return -ENOSPC;
> -		current_vector = FIRST_DEVICE_VECTOR + offset;
> -	}
> -
>  	vector = current_vector;
> +	offset = current_offset;
> +next:
> +	vector += 8;
> +	if (vector >= FIRST_SYSTEM_VECTOR) {
> +		offset = (offset + 1) % 8;
> +		vector = FIRST_DEVICE_VECTOR + offset;
> +	}
> +	if (vector == current_vector)
> +		return -ENOSPC;
> +	if (vector == SYSCALL_VECTOR)
> +		goto next;
> +	for (i = 0; i < NR_IRQ_VECTORS; i++)
> +		if (irq_vector[i] == vector)
> +			goto next;
> +
> +	current_vector = vector;
> +	current_offset = offset;
>  	irq_vector[irq] = vector;
>  
>  	return vector;
