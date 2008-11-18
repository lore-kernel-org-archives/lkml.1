Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbYKRFUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYKRFUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYKRFUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:20:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYKRFUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:20:06 -0500
Message-ID: <49224FBC.2000702@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 13:16:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Airlie <airlied@gmail.com>, David Miller <davem@davemloft.net>,
       menage@google.com, jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com> <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com> <20081116231301.c6b0da95.akpm@linux-foundation.org> <200811181540.00011.nickpiggin@yahoo.com.au>
In-Reply-To: <200811181540.00011.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 17 November 2008 18:13, Andrew Morton wrote:
>> On Mon, 17 Nov 2008 15:43:59 +0900 "KOSAKI Motohiro" 
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>>>> (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
>>>>> I would prefer to find a way to say that one cannot select gfp_mask
>>>>> with this API.
>>>> I think gfp_mask must be passed explicitly.
>>> Agreed.
>> It would only make sense if __vmalloc() can be called in atomic contexts.
>>
>> __vmalloc() cannot be called from irq contexts due to it taking
>> non-irq-safe spinlocks.
>>
>> __vmalloc() kinda looks like it could be called from non-irq atomic
>> contexts with GFP_ATOMIC, but I think it lies.  For example,
>> pud_alloc_one/pmd_alloc_one/etc use hard-wired GFP_KERNEL.
> 
> vmalloc/vfree / vmap/vunmap I think could now be made to be usable even
> in irq context, I think. Freeing up vmalloc space with global tlb flush
> can't be done from interrupt context, but now with the lazy unmapping,
> you only have to mark the area as freed (and possibly kick off a thread
> to do the actual unmapping).
> 
> I didn't actually add that, because yes it would increase overheads a
> bit, and I would still prefer to wait for a real nice problem it solves
> before adding such a capability...
> 
> 
>> In which case this new allocation function can only be called from
>> contexts where GFP_KERNEL can be used, hence we don't need to pass that
>> in - it would be misleading to do so.
>>
>> In fact it's not immediately clear why __vmalloc() takes a gfp_t
>> argument either?
> 
> Possibly a bugcheck for !GFP_WAIT || !GFP_FS || !GFP_IO, or a might_sleep()
> or something would be a good idea to add...
> 
> 
> 

Thanks.
Now, new patch for it is: http://lkml.org/lkml/2008/11/17/137

Lai.


