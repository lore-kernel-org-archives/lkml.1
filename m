Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZH0Qqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZH0Qqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZH0Qqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:46:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:21537 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZH0Qqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:46:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cZmaYD6SDa8Ph9OiOtGa0WiXhVS8WG+cOFeA38hN/X6fCiLp7rjLFy29vIcRatpv9O
         iFHZl0vZ13M2mLzJ8ph0WOqUi8smlZ2B/6UMbAOiJLgpcwCdLxaoW8q+pjJQ3NF9yYW6
         zNoo+ucLLEkEms6sHmqpIOgQ/7tIWy1Sg/yiw=
MIME-Version: 1.0
In-Reply-To: <20090827122144.GA20443@localhost>
References: <4A9677C1.3090804@gmail.com> <20090827122144.GA20443@localhost>
Date: Fri, 28 Aug 2009 00:46:46 +0800
X-Google-Sender-Auth: 4165a942f4ff2e90
Message-ID: <3d0408630908270946n7302e3c5u94f133d8ebbe8c36@mail.gmail.com>
Subject: Re: [PATCH] Make radix_tree_preload alloc one more slot
From: "Yan, Zheng " <yanzheng@21cn.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Huang Shijie <shijie8@gmail.com>,
       linux-kernel@vger.kernel.org, Zhu Yanhai <yanhai.zhu@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/27 Wu Fengguang <fengguang.wu@intel.com>:
>
> Hi Yanhai,
>
> [Nick CCed]
>
> On Thu, Aug 27, 2009 at 08:10:41PM +0800, Zhu Yanhai wrote:
>> The operations against radix tree always use paths with RADIX_TREE_MAX_PATH
>> + 1 slots, but radix_tree_preload only pre-allocs RADIX_TREE_MAX_PATH
>> slots at present, which causes radix_tree_node_alloc tries to do
>> kmem_cache_alloc at the last slot even if we don't have gfp_mask &
>> __GFP_WAIT in hand.
>
> Are you sure?  The comments read:
>
>        /*
>         * The radix tree path needs to be one longer than the maximum path
>         * since the "list" is null terminated.
>         */
>        struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
>
> Thanks,
> Fengguang
>
>
>> Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
>>
>> ---
>>  lib/radix-tree.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
>> index 23abbd9..72225a8 100644
>> --- a/lib/radix-tree.c
>> +++ b/lib/radix-tree.c
>> @@ -79,7 +79,7 @@ static struct kmem_cache *radix_tree_node_cachep;
>>   */
>>  struct radix_tree_preload {
>>       int nr;
>> -     struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
>> +     struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH + 1];
>>  };
>>  static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
>>
>> --
>> 1.6.2.2

here is test case.
---
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/radix-tree.h>

static void __exit exit_test(void)
{
}

static int __init init_test(void)
{
        struct radix_tree_root radix_tree;
        int foo;

        INIT_RADIX_TREE(&radix_tree, GFP_KERNEL);
        radix_tree_preload(GFP_KERNEL);
        preempt_disable();
        radix_tree_insert(&radix_tree, (unsigned long)-2, &foo);
        preempt_enable();
        radix_tree_preload_end();
        radix_tree_delete(&radix_tree, (unsigned long)-2);
        return -1;
}

module_init(init_test)
module_exit(exit_test)
MODULE_LICENSE("GPL");
-- end --

I got following oops.
---
BUG: sleeping function called from invalid context at
/home/zhyan/linux-2.6/mm/slub.c:1697
in_atomic(): 1, irqs_disabled(): 0, pid: 2791, name: insmod
Pid: 2791, comm: insmod Not tainted 2.6.31-rc7 #1
Call Trace:
 [<c042b26a>] __might_sleep+0x101/0x108
 [<c04b3976>] kmem_cache_alloc+0x39/0x141
 [<c05453c7>] ? radix_tree_node_alloc+0x4c/0x5d
 [<c05453c7>] radix_tree_node_alloc+0x4c/0x5d
 [<c054549a>] radix_tree_insert+0xc2/0x174
 [<f90cd03f>] init_test+0x3f/0x89 [test]
 [<c0401141>] do_one_initcall+0x4f/0x11f
 [<f90cd000>] ? init_test+0x0/0x89 [test]
 [<c044e504>] ? __blocking_notifier_call_chain+0x45/0x51
 [<c045d833>] sys_init_module+0xac/0x1bc
 [<c0403458>] sysenter_do_call+0x12/0x2d
-- end --

Thanks.
