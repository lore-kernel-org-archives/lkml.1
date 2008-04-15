Return-Path: <linux-kernel-owner+w=401wt.eu-S1765301AbYDOOBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765301AbYDOOBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765029AbYDOOBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:01:37 -0400
Received: from saeurebad.de ([85.214.36.134]:57306 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764829AbYDOOBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:01:35 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ak@suse.de, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	<20080415071120.GB15499@elte.hu> <87hce3i8mq.fsf@saeurebad.de>
	<4804B091.8010406@tiscali.nl>
Date: Tue, 15 Apr 2008 16:01:21 +0200
In-Reply-To: <4804B091.8010406@tiscali.nl> (Roel Kluin's message of "Tue, 15
	Apr 2008 15:41:37 +0200")
Message-ID: <87d4ori5e6.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roel Kluin <12o3l@tiscali.nl> writes:

> Johannes Weiner wrote:
>
>> How about the following (untested, even uncompiled, but you should get
>> the idea) proposal which would replace the patch discussed in this
>> thread:
>> 
>> --- tree-linus.orig/mm/bootmem.c
>> +++ tree-linus/mm/bootmem.c
>> @@ -421,7 +421,25 @@ int __init reserve_bootmem(unsigned long
>>  
>>  void __init free_bootmem(unsigned long addr, unsigned long size)
>>  {
>> -	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>> +	bootmem_data_t *bdata;
>> +
>> +	list_for_each_entry(bdata, &bdata_list, list) {
>> +		unsigned long remainder = 0;
>> +
>> +		if (addr < bdata->node_boot_start)
>> +			continue;
>> +
>> +		if (PFN_DOWN(addr + size) > bdata->node_low_pfn)
>> +			remainder = PFN_DOWN(addr + size) - bdata->node_low_pfn;
>> +
>> +		size -= PFN_PHYS(remainder);
>> +		free_bootmem_core(bdata, addr, size)
> Missing semicolon here -----------------------------^

Yes.  Intentional compiler trap for untested code *cough*

>> +
>> +		if (!remainder)
>> +			break;
>> +
>> +		addr = PFN_PHYS(bdata->node_low_pfn + 1);
>> +	}
>>  }
>
> This should do the same as (untested):
>
> void __init free_bootmem(unsigned long addr, unsigned long size)
> {
> 	bootmem_data_t *bdata;
>
> 	list_for_each_entry(bdata, &bdata_list, list) {
> 		unsigned long remainder;
                ^^^^^^^^
>
> 		if (addr < bdata->node_boot_start)
> 			continue;
>
> 		remainder = PFN_DOWN(addr + size) - bdata->node_low_pfn;
>
> 		if (remainder <= 0) {

Boom.

> 			free_bootmem_core(bdata, addr, size);
> 			return;
> 		}
>
> 		size -= PFN_PHYS(remainder);
> 		free_bootmem_core(bdata, addr, size);
> 		addr = PFN_PHYS(bdata->node_low_pfn + 1);
> 	}
> }

	Hannes
