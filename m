Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYDMK6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYDMK6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbYDMK6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:58:30 -0400
Received: from saeurebad.de ([85.214.36.134]:51574 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbYDMK6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:58:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<86802c440804121859x42847c2cx37b8cd909b14c6b5@mail.gmail.com>
Date: Sun, 13 Apr 2008 12:57:22 +0200
In-Reply-To: <86802c440804121859x42847c2cx37b8cd909b14c6b5@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 12 Apr 2008 18:59:56 -0700")
Message-ID: <87zlry6mzx.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> Make free_bootmem() look up the node holding the specified address
>>  range which lets it work transparently on single-node and multi-node
>>  configurations.
>>
>>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>>  CC: Andi Kleen <ak@suse.de>
>>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>  CC: Ingo Molnar <mingo@elte.hu>
>>  CC: Christoph Lameter <clameter@sgi.com>
>>  CC: Andrew Morton <akpm@linux-foundation.org>
>>  ---
>>
>>  Patch tested on x86_32 uma.
>>
>>  Index: linux-2.6/mm/bootmem.c
>>  ===================================================================
>>  --- linux-2.6.orig/mm/bootmem.c
>>  +++ linux-2.6/mm/bootmem.c
>>  @@ -421,7 +421,15 @@ int __init reserve_bootmem(unsigned long
>>
>>   void __init free_bootmem(unsigned long addr, unsigned long size)
>>   {
>>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>>  +       bootmem_data_t *bdata;
>>  +
>>  +       list_for_each_entry (bdata, &bdata_list, list) {
>>  +               if (addr < bdata->node_boot_start)
>>  +                       continue;
>
> could have chance that bootmem with reserved_early that is crossing
> the nodes.

Upstream reserve_bootmem_core() would BUG() on a caller trying to cross
nodes, so I don't see where this chance could come from.

	Hannes
