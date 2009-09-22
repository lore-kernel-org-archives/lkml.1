Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZIVRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZIVRHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZIVRHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:07:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:45856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZIVRHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:07:50 -0400
Message-ID: <4AB90403.70806@kernel.org>
Date: Tue, 22 Sep 2009 10:06:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@elte.hu" <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: fix cpumask_of_pcibus() to handle nid of -1
References: <1253597220.2519.4.camel@sbs-t61>
In-Reply-To: <1253597220.2519.4.camel@sbs-t61>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On my two socket NHM-EP system, with CONFIG_DEBUG_PER_CPU_MAPS=y I see:
> 
>   cpumask_of_node(-1): no node_to_cpumask_map!
>   Pid: 5635, comm: irqbalance Not tainted 2.6.31-07068-g43c1266-dirty #145
>   Call Trace:
>    [<ffffffff81031033>] cpumask_of_node+0x4f/0x58
>    [<ffffffff811b5a8c>] local_cpus_show+0x1f/0x48
>    [<ffffffff812c3c65>] dev_attr_show+0x20/0x44
>    [<ffffffff810fcade>] sysfs_read_file+0xb2/0x131
>    [<ffffffff810b2702>] vfs_read+0xab/0x147
>    [<ffffffff810b2862>] sys_read+0x47/0x6f
>    [<ffffffff8100af6b>] system_call_fastpath+0x16/0x1b
> 
> Fix x86 version of cpumask_of_pcibus() to handle node id of "-1"
> (default value indicating that I/O isn't tied to any particular node).
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index f76a162..b101e8c 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -143,7 +143,9 @@ static inline int __pcibus_to_node(const struct pci_bus *bus)
>  static inline const struct cpumask *
>  cpumask_of_pcibus(const struct pci_bus *bus)
>  {
> -	return cpumask_of_node(__pcibus_to_node(bus));
> +	int node = __pcibus_to_node(bus);
> +
> +	return (node == -1) ? cpu_all_mask : cpumask_of_node(node);
>  }
>  #endif
>  
> 

cpu_all_mask or cpu_online_mask?

YH
