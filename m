Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbYDPTUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbYDPTUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764195AbYDPTUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:20:00 -0400
Received: from saeurebad.de ([85.214.36.134]:42331 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764156AbYDPTT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:19:58 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Linux MM" <linux-mm@kvack.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][patch 2/5] mm: Node-setup agnostic free_bootmem()
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
	<20080416113719.092060936@skyscraper.fehenstaub.lan>
	<86802c440804161054h6f0cfc3dmde49006afb7889b2@mail.gmail.com>
Date: Wed, 16 Apr 2008 21:19:33 +0200
In-Reply-To: <86802c440804161054h6f0cfc3dmde49006afb7889b2@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 16 Apr 2008 10:54:57 -0700")
Message-ID: <873aplfvzu.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Wed, Apr 16, 2008 at 4:36 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> Make free_bootmem() look up the node holding the specified address
>>  range which lets it work transparently on single-node and multi-node
>>  configurations.
>>
>>  If the address range exceeds the node range, it well be marked free
>>  across node boundaries, too.
>>
>>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>>  CC: Ingo Molnar <mingo@elte.hu>
>>  CC: Andi Kleen <andi@firstfloor.org>
>>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>  CC: Christoph Lameter <clameter@sgi.com>
>>  CC: Andrew Morton <akpm@linux-foundation.org>
>>  ---
>>   mm/bootmem.c |   10 +++++++++-
>>   1 files changed, 9 insertions(+), 1 deletions(-)
>>
>>  Index: tree-linus/mm/bootmem.c
>>  ===================================================================
>>  --- tree-linus.orig/mm/bootmem.c
>>  +++ tree-linus/mm/bootmem.c
>>  @@ -421,7 +421,32 @@ int __init reserve_bootmem(unsigned long
>>
>>   void __init free_bootmem(unsigned long addr, unsigned long size)
>>   {
>>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>>  +       bootmem_data_t *bdata;
>>  +       unsigned long pos = addr;
>>  +       unsigned long partsize = size;
>>  +
>>  +       list_for_each_entry(bdata, &bdata_list, list) {
>>  +               unsigned long remainder = 0;
>>  +
>>  +               if (pos < bdata->node_boot_start)
>>  +                       continue;
>>  +
>>  +               if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
>>  +                       remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
>>  +                       partsize -= remainder;
>>  +               }
>>  +
>>  +               free_bootmem_core(bdata, pos, partsize);
>>  +
>>  +               if (!remainder)
>>  +                       return;
>>  +
>>  +               pos = PFN_PHYS(bdata->node_low_pfn + 1);
>>  +       }
>>  +       printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
>>  +                       "state: pos=%lx, partsize=%lx\n", addr, size,
>>  +                       pos, partsize);
>>  +       BUG();
>>   }
>>
>>   unsigned long __init free_all_bootmem(void)
>>
>>  --
>
> Yes, it should work well with cross nodes case.
>
> but please add boundary check on free_bootmem_node too.

Alright, I will.

	Hannes
