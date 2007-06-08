Return-Path: <linux-kernel-owner+w=401wt.eu-S937401AbXFHCFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937401AbXFHCFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbXFHCEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:04:53 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:33452 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764091AbXFHCEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:04:52 -0400
Date: Thu, 07 Jun 2007 20:04:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Make i386 kernel show the segfaults in kernel dmesg,
 like x86_64.
In-reply-to: <fa.FB3wQKN6ltiEi81XcB14YVcLGgE@ifi.uio.no>
To: Masoud Asgharifard Sharbiani <masouds@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-id: <4668B939.1070304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FB3wQKN6ltiEi81XcB14YVcLGgE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Masoud Asgharifard Sharbiani wrote:
> Hello,
> This patch makes the i386 behave the same way that x86_64 does when a
> segfault happens. A line gets printed to the kernel log so that tools
> that need to check for failures can behave more uniformly between
> different kernels. Like x86_64, it can be disabled by setting
> debug.exception-trace sysctl variable to 0 (or by doing
> echo 0 > /proc/sys/debug/exception-trace)
> 
> Same behaviour can be extended to other architectures, if needed.
> cheers,
> Masoud.
> 
> Signed-off-by: Masoud Sharbiani <masouds@google.com>
> 
> diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
> index 29d7d61..6aa56db 100644
> --- a/arch/i386/mm/fault.c
> +++ b/arch/i386/mm/fault.c
> @@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned long address)
>  	return 0;
>  }
>  
> +int exception_trace = 1;
> +
>  /*
>   * This routine handles page faults.  It determines the address,
>   * and the problem, and then passes it off to one of the appropriate
> @@ -464,7 +466,14 @@ bad_area_nosemaphore:
>  		 */
>  		if (is_prefetch(regs, address, error_code))
>  			return;
> -
> +		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
> +			printk(
> +		       "%s%s[%d]: segfault at %08lx eip %08lx esp %08lx error %lx\n",
> +					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
> +					tsk->comm, tsk->pid, address, regs->eip,
> +					regs->esp, error_code);

Shouldn't we use printk_ratelimit() here, to prevent some nasty person 
from creating some rapidly-segfaulting process that floods the kernel 
logs? (Same with the x86_64 version if it doesn't already..)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

