Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629Ab0ARGad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0ARGad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 01:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140Ab0ARGaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 01:30:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57868 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0ARGaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 01:30:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iKvSJAyNPEas63ccf3rPdUrVx6TdZXbcS5qah7XscwhCbD3IOcWwUabyVhkcHqMvBK
         1ofIE1vq30zWmSsCBhvbAjQQG7PG19fZkp/KDFFZpFThSUGUdJsEvTmjZuNibEExrk1w
         739Vt7ayzHe6DnId6jTjNQvajU6Vk2S1HjHqo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com>
	 <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com>
Date: Sun, 17 Jan 2010 22:30:14 -0800
X-Google-Sender-Auth: 71fb4d7ed701b646
Message-ID: <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes 
	detected by ACPI.
From: Yinghai Lu <yinghai@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 1:53 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 15 Jan 2010, Haicheng Li wrote:
>
>> This is to fix the bug discussed in email thread:
>> http://patchwork.kernel.org/patch/69499/.
>>
>
> It would be better to include a brief synopsis of the problem in the
> changelog instead of a citation, otherwise it obfuscates the issue it
> solves.
>
>> Currently node_possible_map won't include the offlined node that has neither
>> CPU onlined nor MEM onlined at booting time. As a result, nr_node_ids won't be
>> equal to possible nodes.
>>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: H. Peter Anvin <hpa@zytor.com>
>> CC: Andi Kleen <andi@firstfloor.org>
>> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
>> ---
>>  arch/x86/mm/srat_64.c |   10 ++--------
>>  1 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
>> index a271241..a5bc297 100644
>> --- a/arch/x86/mm/srat_64.c
>> +++ b/arch/x86/mm/srat_64.c
>> @@ -238,7 +238,7 @@ update_nodes_add(int node, unsigned long start, unsigned
>> long end)
>>  void __init
>>  acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>>  {
>> -     struct bootnode *nd, oldnode;
>> +     struct bootnode *nd;
>>       unsigned long start, end;
>>       int node, pxm;
>>       int i;
>> @@ -277,7 +277,6 @@ acpi_numa_memory_affinity_init(struct
>> acpi_srat_mem_affinity *ma)
>>               return;
>>       }
>>       nd = &nodes[node];
>> -     oldnode = *nd;
>>       if (!node_test_and_set(node, nodes_parsed)) {
>>               nd->start = start;
>>               nd->end = end;
>> @@ -291,13 +290,8 @@ acpi_numa_memory_affinity_init(struct
>> acpi_srat_mem_affinity *ma)
>>       printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>>              start, end);
>>
>> -     if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>> +     if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
>>               update_nodes_add(node, start, end);
>> -             /* restore nodes[node] */
>> -             *nd = oldnode;
>> -             if ((nd->start | nd->end) == 0)
>> -                     node_clear(node, nodes_parsed);
>> -     }
>>
>>       node_memblk_range[num_node_memblks].start = start;
>>       node_memblk_range[num_node_memblks].end = end;
>
> There're a couple of issues with this patch:
>
>  - it breaks CONFIG_MEMORY_HOTPLUG_SPARSE kernels when the SRAT reports
>   more than one entry for a single node id and the later entry does not
>   specify an address range, and

not sure this one.

>
>  - carrying the bit for the node over in nodes_parsed is inappropriate
>   since other x86 code depends on that map including only nodes with
>   memory such as e820_register_active_regions() and nodes_cover_memory().

assume if e820 is right, even srat table have a range for hot plug
aka the e820 have hole already. then e820_register_active_regions()
and nodes_cover_memory
should be ok even bootnode have some pre reserved range.

YH
