Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903Ab0AHSoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0AHSoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927Ab0AHSoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:44:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38206 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0AHSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:44:07 -0500
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] sparseirq: use radix_tree instead of ptrs array
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	<1262951595-1729-4-git-send-email-yinghai@kernel.org>
	<20100108121414.GB4967@lenovo>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 08 Jan 2010 10:43:53 -0800
In-Reply-To: <20100108121414.GB4967@lenovo> (Cyrill Gorcunov's message of "Fri\, 8 Jan 2010 15\:14\:14 +0300")
Message-ID: <m1k4vsphcm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Fri, Jan 08, 2010 at 03:53:14AM -0800, Yinghai Lu wrote:
>> use radix_tree irq_desc_tree instead of irq_desc_ptrs.
>> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> 
>> ---
>>  kernel/irq/handle.c |   47 ++++++++++++++++++++++-------------------------
>>  1 file changed, 22 insertions(+), 25 deletions(-)
>> 
>> Index: linux-2.6/kernel/irq/handle.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/irq/handle.c
>> +++ linux-2.6/kernel/irq/handle.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/kernel_stat.h>
>>  #include <linux/rculist.h>
>>  #include <linux/hash.h>
>> +#include <linux/radix-tree.h>
>>  #include <trace/events/irq.h>
>>  
>>  #include "internals.h"
>> @@ -127,7 +128,23 @@ static void init_one_irq_desc(int irq, s
>>   */
>>  DEFINE_RAW_SPINLOCK(sparse_irq_lock);
>>  
>> -static struct irq_desc **irq_desc_ptrs __read_mostly;
>> +static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
>> +
>> +static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	radix_tree_insert(&irq_desc_tree, irq, desc);
>> +}
>> +
>> +struct irq_desc *irq_to_desc(unsigned int irq)
>> +{
>> +	return radix_tree_lookup(&irq_desc_tree, irq);
>> +}
>> +
>> +void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	radix_tree_delete(&irq_desc_tree, irq);
>> +	radix_tree_insert(&irq_desc_tree, irq, desc);
>> +}
>>  
> ...
>
> Hi Yinghai,
>
> should not we printk\warn if radix_tree_insert() is get failed?
> This is hardly (if ever) happen on machines with small number
> of interrupts allocated but anyway.
>
> Or I miss something?

It looks to me like we can use radix_tree_lookup_slot and
radix_tree_replace_slot here.  Since we don't have to allocate
memory radix_tree_replace_slot can not fail.  Using a case
that can never fail seems better than worry about a case that
can rarely fail.

Eric
