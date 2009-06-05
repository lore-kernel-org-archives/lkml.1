Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZFEJxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZFEJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZFEJxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:53:40 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57170 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFEJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JIRy1FdqkZWvb2vq6uqIVLpDR07tLyOK2ip/NxPTBss0zwEksip5JySuQPrHAjNht7
         5gerTdqHrc4ybxjK7OwvL7IbzjfPMG590hbR6N/7VFUekgOV6XfaS245vcPAMmA2Cwyr
         o6ckPWSBWzBah6jXssHZhFVGH9qSecFvQqH4U=
Date: Fri, 5 Jun 2009 17:55:54 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM,
       michaele@au1.ibm.com, mingo@elte.hu, heicars2@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090605095554.GD8354@cr0.nay.redhat.com>
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org> <4A266546.5080601@linux.vnet.ibm.com> <4A26961E.7040207@linux.vnet.ibm.com> <20090604090839.GB7030@cr0.nay.redhat.com> <4A28E3F8.5050908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28E3F8.5050908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 11:23:04AM +0200, Peter Oberparleiter wrote:
> Amerigo Wang wrote:
>> On Wed, Jun 03, 2009 at 05:26:22PM +0200, Peter Oberparleiter wrote:
>>> Peter Oberparleiter wrote:
>>>> Andrew Morton wrote:
>>>>> On Tue, 02 Jun 2009 13:44:02 +0200
>>>>> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>>>>> +	/* Duplicate gcov_info. */
>>>>>> +	active = num_counter_active(info);
>>>>>> +	dup = kzalloc(sizeof(struct gcov_info) +
>>>>>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
>>>>> How large can this allocation be?
>>>> Hm, good question. Having a look at my test system, I see coverage 
>>>> data files of up to 60kb size. With counters making up the largest 
>>>> part of those, I'd guess the allocation size can be around ~55kb. I 
>>>> assume that makes it a candidate for vmalloc?
>>> A further run with debug output showed that the maximum size is
>>> actually around 4k, so in my opinion, there is no need to switch
>>> to vmalloc.
>>
>> Unless you want virtually continious memory, you don't need to
>> bother vmalloc().
>>
>> kmalloc() and get_free_pages() are all fine for this.
>
> kmalloc() requires contiguous pages to serve an allocation request  
> larger than a single page. The longer a kernel runs, the more fragmented  
> the pool of free pages gets and the probability to find enough  
> contiguous free pages is significantly reduced.
>
> In this case (having had a 3rd look), I found allocations of up to  
> ~50kb, so to be sure, I'll switch that particular allocation to 
> vmalloc().
>

Well, at least get_free_pages() is fine, 50Kb is about 16 pages on x86,
so the order is 4, not big for get_free_pages()...

And note that vmalloc() needs extra efforts to do page mapping...
