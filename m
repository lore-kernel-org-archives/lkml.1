Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYASVwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYASVwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYASVwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:52:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34307 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569AbYASVwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:52:42 -0500
Message-ID: <47927127.4030004@sgi.com>
Date: Sat, 19 Jan 2008 13:52:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com> <20080119145243.GA27974@elte.hu> <20080119151522.GA7774@elte.hu> <20080119152357.GA11706@elte.hu>
In-Reply-To: <20080119152357.GA11706@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> and then it crashes with:
>>
>>  [    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
>>  [    0.000000] KERN_NOTICE cpu_to_node(0): usage too early!
>>  PANIC: early exception 06 rip 10:ffffffff81f77f30 error 0 cr2 f06f53
>>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.24-rc8 #422
>>  [    0.000000]
>>  [    0.000000] Call Trace:
>>  [    0.000000]  [<ffffffff81f76b4a>] ? setup_node_bootmem+0x1a0/0x1b8
>>  [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
>>  [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
>>  [    0.000000]  [<ffffffff81f77103>] ? numa_initmem_init+0x343/0x471
>>
>> moral: PLEASE do not use BUG() on in early init code, unless 
>> absolutely necessary.
> 
> the right fix is below.
> 
> 	Ingo
> 
> ---
>  include/asm-x86/topology.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/include/asm-x86/topology.h
> ===================================================================
> --- linux.orig/include/asm-x86/topology.h
> +++ linux/include/asm-x86/topology.h
> @@ -70,10 +70,10 @@ static inline int cpu_to_node(int cpu)
>  	if(x86_cpu_to_node_map_early_ptr) {
>  		printk("KERN_NOTICE cpu_to_node(%d): usage too early!\n",
>  			(int)cpu);
> -		BUG();
> +		dump_stack();
>  	}
>  #endif
> -	if(per_cpu_offset(cpu))
> +	if (per_cpu_offset(cpu))
>  		return per_cpu(x86_cpu_to_node_map, cpu);
>  	else
>  		return NUMA_NO_NODE;

Thanks.  I had pulled this from the patch as ak suggested.  But it seems
that it's finding real errors that need to be fixed.

Thanks,
Mike
