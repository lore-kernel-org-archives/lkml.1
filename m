Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab0CJWtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:49:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47986
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757387Ab0CJWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:48:56 -0500
Date: Wed, 10 Mar 2010 14:49:16 -0800 (PST)
Message-Id: <20100310.144916.143963072.davem@davemloft.net>
To: yinghai@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B981B22.5080103@kernel.org>
References: <1268256267-3769-7-git-send-email-yinghai@kernel.org>
	<20100310.140440.246391326.davem@davemloft.net>
	<4B981B22.5080103@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 10 Mar 2010 14:20:18 -0800

> On 03/10/2010 02:04 PM, David Miller wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Wed, 10 Mar 2010 13:24:27 -0800
>> 
>>> use early_res/fw_memmap to replace lmb, so could use early_res replace bootme
>>> later.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> 
>> This doesn't boot, it looks like early_res is not initialized
>> early enough, the backtrace is:
>> 
>> [    0.000000] Remapping the kernel... done.
>> [    0.000000] Kernel panic - not syncing: can not find more space for early_res array
>> [    0.000000] Call Trace:
>> [    0.000000]  [0000000000882c48] __check_and_double_early_res+0xc0/0x1c8
>> [    0.000000]  [0000000000882f18] reserve_early+0x10/0x38
>> [    0.000000]  [000000000087b894] prom_early_alloc+0x48/0x7c
>> [    0.000000]  [000000000087b3e4] get_one_property+0x28/0x50
>> [    0.000000]  [000000000087b588] prom_create_node+0x44/0xe8
>> [    0.000000]  [000000000087b6d0] prom_build_tree+0x1c/0xac
>> [    0.000000]  [000000000087b7b4] prom_build_devicetree+0x54/0x80
>> [    0.000000]  [000000000087fd34] paging_init+0x69c/0x1268
>> [    0.000000]  [00000000008786f4] start_kernel+0x88/0x374
>> [    0.000000]  [000000000070589c] tlb_fixup_done+0x98/0xa0
>> [    0.000000]  [0000000000000000] (null)
> 
> looks like we need to increase MAX_EARLY_RES_X in kernel/early_res.c

Ummm, hoestly, how do you know?

Is there a debugging statement that triggered and printed a message
above which told you this?  No, nothing like that happened.

The truth is you have no idea whatsoever because early_res has been
written in a way that errors are hard to diagnose.

It's definitely not a size issue, there are only 4 ranges that exist
in this machine.

I don't know what the actual problem is and I don't have time to debug
it right now, please try to figure it out and send me patches to try.

Actually that points out another regression of early_res, it lacks a
"xxx=debug" command line option like LMB does, which would have
allowed me to debug this very easily.

Also, there are other problems with your changes.

For example, the transformation you make in
arch/sparc/mm/init_64.c:alloc_node_data() is absolutely not
equivalent.

NUMA nodes can have memory in discontiguous regions, the LMB node
based allocator gets it right, whereas your code could allocate memory
on the wrong node.

Only the "nid_range()" callback passed to lmb_alloc_nid() is able to
determine nodes properly.

This is yet another regression of your early_res code.

The more and more I look at the early_res code the more I see
that:

1) LMB could do everything early_res does

2) early_res cannot do everything LMB can

Can you seriously start looking at using LMB instead of this new
stuff which seems at every element to be a step backwards?

Thank you.
