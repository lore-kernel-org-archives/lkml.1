Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbZGQFdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbZGQFdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbZGQFdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:33:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:63707 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbZGQFds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HNblnoKM6CzzXjh/4i+q3pUQblOWa9q7eNjfn2vygXSUtmXyd24M3F89xZFqoFLCLQ
         KTChtzROnvWyWpwKt98QHj7297R0P3t8KuXWTjJzq0cbywzgq3dBzsXV1m4lXxSxCeT0
         vzD/NVa+BMOrozx47GlOtP3EPxFjOifjmoCFU=
MIME-Version: 1.0
In-Reply-To: <20090717135847.38B3.E1E9C6FF@jp.fujitsu.com>
References: <3877989d0907160218l4a28791v90ad22cc048c3440@mail.gmail.com>
	 <20090717135847.38B3.E1E9C6FF@jp.fujitsu.com>
Date: Fri, 17 Jul 2009 13:33:47 +0800
Message-ID: <3877989d0907162233x6e5874e5r3b679454160a6077@mail.gmail.com>
Subject: Re: [RFC patch] delete improper hot pluggable code of memory affinity
From: Luming Yu <luming.yu@gmail.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without a fix like my proposal, I have seen NUMA configure disabled by
kernel (due to the code the patch deletes) on a system with Enabled
bit set , and Hotplug-able bit cleared, and
CONFIG_MEMORY_HOTPLUG_SPARSE disabled.

On Fri, Jul 17, 2009 at 1:16 PM, Yasunori Goto<y-goto@jp.fujitsu.com> wrote:
>
> Hi, Luming-san.
>
>> The current kernel code *wrongly* interprets Hot Pluggable bit of
>> Memory Affinity Structure (SRAT table in ACPI spec).
>
> I'm not sure your patch is correct or not yet, but I would like
> to tell you a critical point about the definition of
> Memory Affinity Structure.
>
> The spec says the Enable bit of Memory Affinity Structure means that
> the contents of its memory affinity structure is only VALID.
> It doesn't mean memory is really connected at the area.
> It means only that OS can read the entry.
>
> When the enabled bit and hot pluggable bit is set on,
> it may mean that the area may be hot-added after boot up.
> So, kernel must check e820 or efi to confirm that memory is
> really connected.
>
> If you already know it, sorry for noise....
> Just for your information.
>
> Thanks.
>
>
>
>> if Hot Pluggable bit is set and CONFIG_MEMORY_HOTPLUG_SPARSE is NOT
>> set, the memory Affinity will
>> be ignored. And a faked Node will be used...
>>
>> An alternative is to enable CONFIG_MEMORY_HOTPLUG_SPARSE *always*
>> along with acpi_numa_memory_affinity_init.
>> Please decide which one is appropriate.
>>
>> The downside of this patch is *some useful info* is lost and a follow
>> up patch is needed.
>>
>> **The patch is enclosed in text attachment*
>> **Using web client to send the patch* *
>> **below is for review, please apply attached  patch*/
>>
>> Thanks,
>> Luming
>>
>>
>> Signed-off-by: Yu Luming <luming.yu@intel.com>
>>
>>  srat_64.c |   16 ----------------
>>  1 file changed, 16 deletions(-)
>>
>>
>> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
>> index 2dfcbf9..82423e5 100644
>> --- a/arch/x86/mm/srat_64.c
>> +++ b/arch/x86/mm/srat_64.c
>> @@ -172,11 +172,6 @@ acpi_numa_processor_affinity_init(struct
>> acpi_srat_cpu_affinity *pa)
>>              pxm, apic_id, node);
>>  }
>>
>> -#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
>> -static inline int save_add_info(void) {return 1;}
>> -#else
>> -static inline int save_add_info(void) {return 0;}
>> -#endif
>>  /*
>>   * Update nodes_add[]
>>   * This code supports one contiguous hot add area per node
>> @@ -249,9 +244,6 @@ acpi_numa_memory_affinity_init(struct
>> acpi_srat_mem_affinity *ma)
>>       }
>>       if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
>>               return;
>> -
>> -     if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
>> -             return;
>>       start = ma->base_address;
>>       end = start + ma->length;
>>       pxm = ma->proximity_domain;
>> @@ -291,14 +283,6 @@ acpi_numa_memory_affinity_init(struct
>> acpi_srat_mem_affinity *ma)
>>       e820_register_active_regions(node, start >> PAGE_SHIFT,
>>                                    end >> PAGE_SHIFT);
>>
>> -     if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>> -             update_nodes_add(node, start, end);
>> -             /* restore nodes[node] */
>> -             *nd = oldnode;
>> -             if ((nd->start | nd->end) == 0)
>> -                     node_clear(node, nodes_parsed);
>> -     }
>> -
>>       node_memblk_range[num_node_memblks].start = start;
>>       node_memblk_range[num_node_memblks].end = end;
>>       memblk_nodeid[num_node_memblks] = node;
>
> --
> Yasunori Goto
>
>
>
