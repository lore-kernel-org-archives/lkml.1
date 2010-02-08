Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0BHCsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 21:48:13 -0500
Received: from mga10.intel.com ([192.55.52.92]:40414 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756990Ab0BHCsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 21:48:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,425,1262592000"; 
   d="scan'208";a="770925040"
Message-ID: <4B6F7B66.5060404@linux.intel.com>
Date: Mon, 08 Feb 2010 10:48:06 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Suresh.b.siddha@intel.com, lenb@kernel.org, trenn@suse.de,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@intel.com>,
       "Lv, Jane" <jane.lv@intel.com>, "Li, Haicheng" <haicheng.li@intel.com>
Subject: Re: [PATCH] x86, acpi: map hotadded cpu to correct node.
References: <C8EDE645B81E5141A8C6B2F73FD9265117C58A3504@shzsmsx501.ccr.corp.intel.com> <20100203220328.GG7510@basil.fritz.box> <4B6AAA39.6000300@linux.intel.com>
In-Reply-To: <4B6AAA39.6000300@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

any comments on this patch? in fact, it's a straightforward bug fix: with existing
CPU hotadd code, new added CPUs won't be mapped to its own node. especially for hotadding
a new node with CPU and MEM, new added memories can be mapped to this new node, but new added
CPUs are always mapped to old nodes. This patch is to fix this obvious bug. thanks.

-haicheng

Haicheng Li wrote:
> x86: map hotadded cpu to correct node.
> 
> When hotadd new cpu to system, if its affinitive node is online, should 
> map the cpu to its own node. otherwise, let kernel select one online 
> node for the new cpu later.
> 
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  arch/x86/kernel/acpi/boot.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 67e929b..92a4861 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -49,6 +49,7 @@ EXPORT_SYMBOL(acpi_disabled);
> 
>  #ifdef    CONFIG_X86_64
>  # include <asm/proto.h>
> +# include <asm/numa_64.h>
>  #endif                /* X86 */
> 
>  #define BAD_MADT_ENTRY(entry, end) (                        \
> @@ -482,6 +483,25 @@ int acpi_register_gsi(struct device *dev, u32 gsi, 
> int trigger, int polarity)
>   */
>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
> 
> +static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
> +{
> +#ifdef CONFIG_ACPI_NUMA
> +    int nid;
> +
> +    nid = acpi_get_node(handle);
> +    if (!node_online(nid))
> +        return;
> +#ifdef CONFIG_X86_64
> +    apicid_to_node[physid] = nid;
> +    numa_set_node(cpu, nid);
> +#else /* CONFIG_X86_32 */
> +    apicid_2_node[physid] = nid;
> +    cpu_to_node_map[cpu] = nid;
> +#endif
> +
> +#endif
> +}
> +
>  static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
>  {
>      struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> @@ -540,6 +560,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle 
> handle, int *pcpu)
>      }
> 
>      cpu = cpumask_first(new_map);
> +    acpi_map_cpu2node(handle, cpu, physid);
> 
>      *pcpu = cpu;
>      retval = 0;
