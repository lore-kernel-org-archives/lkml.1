Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZAKQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZAKQuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZAKQt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:49:59 -0500
Received: from relay3.sgi.com ([192.48.171.31]:35605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751547AbZAKQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:49:58 -0500
Message-ID: <496A232A.5070801@sgi.com>
Date: Sun, 11 Jan 2009 08:49:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, mingo@elte.hu,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask change causes sparc build bustage
References: <20090111.003103.39502700.davem@davemloft.net>	<20090111205008.db0a410e.sfr@canb.auug.org.au> <20090111.040640.188129980.davem@davemloft.net>
In-Reply-To: <20090111.040640.188129980.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Sun, 11 Jan 2009 20:50:08 +1100
> 
>> On Sun, 11 Jan 2009 00:31:03 -0800 (PST) David Miller <davem@davemloft.net> wrote:
>>> I'm surprised linux-next builds didn't catch this.
>> So am I.  http://kisskb.ellerman.id.au/kisskb/compiler/5/ shows my latest
>> builds of both linux-next and Linus' tree are OK for defconfig and
>> allnoconfig (allmodconfig fails for a different reason).
>>
>> What is different about the failing config (compiler)?  Are there other
>> configs it would be sensible to build test?
> 
> Maybe you don't have NUMA enabled in the test build configs.
> I hit it during an allmodconfig.
> 
> Anyways this fixes it, someone please apply:
> 
> sparc64: Fix cpumask related build failure.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
> index b8a65b6..5bc0b8f 100644
> --- a/arch/sparc/include/asm/topology_64.h
> +++ b/arch/sparc/include/asm/topology_64.h
> @@ -47,6 +47,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
>  	(pcibus_to_node(bus) == -1 ? \
>  	 CPU_MASK_ALL : \
>  	 node_to_cpumask(pcibus_to_node(bus)))
> +#define cpumask_of_pcibus(bus)	\
> +	(pcibus_to_node(bus) == -1 ? \
> +	 CPU_MASK_ALL_PTR : \
> +	 cpumask_of_node(pcibus_to_node(bus)))
>  
>  #define SD_NODE_INIT (struct sched_domain) {		\
>  	.min_interval		= 8,			\

Ouch.  Sorry you had to find this.  I thought Rusty had pushed all the arch
changes required for cpumask_of_pcibus() quite some time ago.

Thanks for fixing it.  In actuality though, it should return cpu_mask_all
instead of CPU_MASK_ALL_PTR but that's a small nit.

Thanks,
Mike
