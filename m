Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYKQExj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYKQExj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYKQExb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:53:31 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36086 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYKQExa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:53:30 -0500
Message-ID: <4920F73C.1030005@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 10:16:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dave Airlie <airlied@gmail.com>, David Miller <davem@davemloft.net>,
       laijs@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, jens.axboe@oracle.com, jack@suse.cz,
       jes@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com> <20081115205229.765f7ee3@infradead.org> <20081116.001926.150424480.davem@davemloft.net> <20081116105725.12458b13@infradead.org> <21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com> <20081116135130.5e8b4e13@infradead.org>
In-Reply-To: <20081116135130.5e8b4e13@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 17 Nov 2008 07:39:55 +1000
> "Dave Airlie" <airlied@gmail.com> wrote:
> 
>> On Mon, Nov 17, 2008 at 4:57 AM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>>> On Sun, 16 Nov 2008 00:19:26 -0800 (PST)
>>> David Miller <davem@davemloft.net> wrote:
>>>
>>>> From: Arjan van de Ven <arjan@infradead.org>
>>>> Date: Sat, 15 Nov 2008 20:52:29 -0800
>>>>
>>>>> On Sun, 16 Nov 2008 12:33:15 +0800
>>>>> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>>>>
>>>>>> some subsystem needs vmalloc() when required memory is large.
>>>>>> but current kernel has not APIs for this requirement.
>>>>>> this patch introduces simple_malloc() and simple_free().
>>>>> I kinda really don't like this approach. vmalloc() (and
>>>>> especially, vfree()) is a really expensive operation, and
>>>>> vmalloc()'d memory is also slower (due to tlb pressure).
>>>>> Realistically, people should try hard to use small datastructure
>>>>> instead....
>>>> This is happening in many places, already, for good reason.
>>>>
>>>> There are lots of places where we can't (core hash tables, etc.)
>>>> and we want NUMA spreading and reliable allocation, and thus
>>>> vmalloc it is.
>>> vmalloc() isn't 100% evil; for truely long term stuff it's
>>> sometimes a quite reasonable solution.
>>>
>>> There are some issues with it still: the vmalloc() space is shared
>>> with ioremap, modules and others and it's not all that big on 32
>>> bit; on x86 you could well end up with only 64Mb total (after
>>> taking out the various ioremap's etc).
>>>
>>> Yes there's places where it's then totally fine to dip into this
>>> space at boot/init time. You mention a few very good users.
>>> (There's still the tlb miss cost on use but on modern cpus a tlb
>>> miss is actually quite cheap)
>>>
>>> But this doesn't make vmalloc() the magic bullet that solves the "oh
>>> Linux can't allocate large chunks of memory" problem. Specifically
>>> in driver space for things that get ported from other OSes.
>> So we keep the duplicated code? or we just audit new callers.... I
>> think this patch
>> makes it easier to spot new callers doing something stupid. As davem
>> said we duplicate
>> this code all over the place, so for that reason along a simple
>> wrapper makes things a lot
>> easier, and also possibly a lot easier to change in the future to a
>> new non-sucky API.
>>
>> So I'm all for it maybe with a non simple name.
>>
> 
> I would go further than this.
> 
> Make the code just use vmalloc(). Period.
> 

But vmalloc() is always chunks of pages, not always desirable.

> But then make vmalloc() smart and try do a direct mapping allocation
> first, before falling back to a virtual mapping. (and based on size it
> wouldn't even try it for just big things)

If only slab/slub could do vmalloc() based caches, but vmalloc() is not the
common case worth optimizing for.

-- 
	Balbir
