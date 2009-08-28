Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZH1F55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZH1F55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZH1F54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:57:56 -0400
Received: from mga06.intel.com ([134.134.136.21]:8195 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751247AbZH1F54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:57:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,290,1249282800"; 
   d="scan'208";a="443454609"
Message-ID: <4A977210.5030201@linux.intel.com>
Date: Fri, 28 Aug 2009 13:58:40 +0800
From: Zhu Yanhai <yanhai.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "Yan, Zheng " <yanzheng@21cn.com>, Zhu Yanhai <zhu.yanhai@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Huang Shijie <shijie8@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Make radix_tree_preload alloc one more slot
References: <4A9677C1.3090804@gmail.com> <20090827122144.GA20443@localhost> <3d0408630908270946n7302e3c5u94f133d8ebbe8c36@mail.gmail.com> <20090828015032.GA13271@localhost> <3d0408630908271933v1d136b85he33e7d4b6e0bccf6@mail.gmail.com> <20090828033149.GA24838@localhost>
In-Reply-To: <20090828033149.GA24838@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 11:31 AM, Wu Fengguang wrote:
> On Fri, Aug 28, 2009 at 10:33:03AM +0800, Yan, Zheng  wrote:
>> 2009/8/28 Wu Fengguang <fengguang.wu@intel.com>:
>>> On Fri, Aug 28, 2009 at 12:46:46AM +0800, Yan, Zheng  wrote:
>>>> 2009/8/27 Wu Fengguang <fengguang.wu@intel.com>:
>>>>> Hi Yanhai,
>>>>>
>>>>> [Nick CCed]
>>>>>
>>>>> On Thu, Aug 27, 2009 at 08:10:41PM +0800, Zhu Yanhai wrote:
>>>>>> The operations against radix tree always use paths with RADIX_TREE_MAX_PATH
>>>>>> + 1 slots, but radix_tree_preload only pre-allocs RADIX_TREE_MAX_PATH
>>>>>> slots at present, which causes radix_tree_node_alloc tries to do
>>>>>> kmem_cache_alloc at the last slot even if we don't have gfp_mask &
>>>>>> __GFP_WAIT in hand.
>>>>> Are you sure?  The comments read:
>>>>>
>>>>>        /*
>>>>>         * The radix tree path needs to be one longer than the maximum path
>>>>>         * since the "list" is null terminated.
>>>>>         */
>>>>>        struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
>>>>>
>>>>> Thanks,
>>>>> Fengguang
>>>>>
>>>>>
>>>>>> Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
>>>>>>
>>>>>> ---
>>>>>>  lib/radix-tree.c |    2 +-
>>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>
>>>>>> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
>>>>>> index 23abbd9..72225a8 100644
>>>>>> --- a/lib/radix-tree.c
>>>>>> +++ b/lib/radix-tree.c
>>>>>> @@ -79,7 +79,7 @@ static struct kmem_cache *radix_tree_node_cachep;
>>>>>>   */
>>>>>>  struct radix_tree_preload {
>>>>>>       int nr;
>>>>>> -     struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
>>>>>> +     struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH + 1];
>>>>>>  };
>>>>>>  static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
>>>>>>
>>>>>> --
>>>>>> 1.6.2.2
>>>> here is test case.
>>>> ---
>>>> #include <linux/module.h>
>>>> #include <linux/kernel.h>
>>>> #include <linux/radix-tree.h>
>>>>
>>>> static void __exit exit_test(void)
>>>> {
>>>> }
>>>>
>>>> static int __init init_test(void)
>>>> {
>>>>         struct radix_tree_root radix_tree;
>>>>         int foo;
>>>>
>>>>         INIT_RADIX_TREE(&radix_tree, GFP_KERNEL);
>>>>         radix_tree_preload(GFP_KERNEL);
>>>>         preempt_disable();
>>>>         radix_tree_insert(&radix_tree, (unsigned long)-2, &foo);
>>>>         preempt_enable();
>>>>         radix_tree_preload_end();
>>>>         radix_tree_delete(&radix_tree, (unsigned long)-2);
>>>>         return -1;
>>>> }
>>>>
>>>> module_init(init_test)
>>>> module_exit(exit_test)
>>>> MODULE_LICENSE("GPL");
>>>> -- end --
>>>>
>>>> I got following oops.
>>>> ---
>>>> BUG: sleeping function called from invalid context at
>>>> /home/zhyan/linux-2.6/mm/slub.c:1697
>>>> in_atomic(): 1, irqs_disabled(): 0, pid: 2791, name: insmod
>>>> Pid: 2791, comm: insmod Not tainted 2.6.31-rc7 #1
>>>> Call Trace:
>>>>  [<c042b26a>] __might_sleep+0x101/0x108
>>>>  [<c04b3976>] kmem_cache_alloc+0x39/0x141
>>>>  [<c05453c7>] ? radix_tree_node_alloc+0x4c/0x5d
>>>>  [<c05453c7>] radix_tree_node_alloc+0x4c/0x5d
>>>>  [<c054549a>] radix_tree_insert+0xc2/0x174
>>>>  [<f90cd03f>] init_test+0x3f/0x89 [test]
>>>>  [<c0401141>] do_one_initcall+0x4f/0x11f
>>>>  [<f90cd000>] ? init_test+0x0/0x89 [test]
>>>>  [<c044e504>] ? __blocking_notifier_call_chain+0x45/0x51
>>>>  [<c045d833>] sys_init_module+0xac/0x1bc
>>>>  [<c0403458>] sysenter_do_call+0x12/0x2d
>>>> -- end --
>>> This is weird, I cannot reproduce this message. Here is my .config.
>>> I use SLAB but it also has the might_sleep_if(__GFP_WAIT) debug call.
>>> Thanks,
>>> Fengguang
>> I realize it's my fault, I use GFP_KERNEL to initialize the radix tree.
>> radix_tree_node_alloc does not use pre-loaded memory when the
>> radix tree is initialized with GFP_KERNEL. Yesterday when I saw the
> 
> Ah yes!
> 
>> Oops, I suspect it's an radix_tree_preload bug. I told Zhu Yanhai
>> my thought. Please forgive my rash act.
> 
> That's all right. So we can just do nothing? :)
I think so. False alert :)
> 
> Thanks,
> Fengguang
> 
> 

Thanks,
Zhu Yanhai
