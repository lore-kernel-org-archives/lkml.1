Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZCDGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZCDGb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCDGbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:31:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:35276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZCDGbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:31:19 -0500
Message-ID: <49AE2028.8040402@kernel.org>
Date: Wed, 04 Mar 2009 15:31:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage - bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
References: <1236085632.5958.8.camel@marge.simson.net>	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>	 <49ADE077.1060606@kernel.org>  <1236138205.6119.12.camel@marge.simson.net> <1236147277.6049.3.camel@marge.simson.net>
In-Reply-To: <1236147277.6049.3.camel@marge.simson.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 06:31:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

Mike Galbraith wrote:
> On Wed, 2009-03-04 at 04:43 +0100, Mike Galbraith wrote:
>> On Wed, 2009-03-04 at 10:59 +0900, Tejun Heo wrote:
>>
>>> I can't reproduce the problem here.
>> Guess I'll have to sharpen a stick or two then.
> 
> With monkey-see-monkey-do-stick, box becomes happy camper again.
> 
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index c29f301..bc9972a 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -256,6 +256,11 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
>  			    + ((size_t)pageno << PAGE_SHIFT));
>  }
>  
> +static void __init embed_populate_pte(unsigned long addr)
> +{
> +	populate_extra_pte(addr);
> +}
> +
>  static ssize_t __init setup_pcpu_embed(size_t static_size)
>  {
>  	unsigned int cpu;
> @@ -284,10 +289,15 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
>  	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
>  		pcpue_unit_size >> PAGE_SHIFT, pcpue_ptr, static_size);
>  
> +#if 0
>  	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
>  				      pcpue_unit_size,
>  				      pcpue_unit_size - static_size, pcpue_ptr,
>  				      NULL);
> +#else
> +	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
> +				      0, 0, NULL, embed_populate_pte);
> +#endif
>  }

That isn't quite correct but is still very interesting that it fixes
the build issue.  Super weird.  I'm almost done setting up 11.0 system.
I'll dig into it as soon as I'm done with sata_nv -stable issue.

Thanks for drilling it down.

-- 
tejun
