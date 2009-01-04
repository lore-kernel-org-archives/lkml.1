Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZADMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZADMWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZADMWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:22:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56079 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZADMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:22:08 -0500
Message-ID: <4960A9E8.3090309@colorfullife.com>
Date: Sun, 04 Jan 2009 13:22:00 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <49604BAD.5010405@cn.fujitsu.com> <4960603F.2030002@colorfullife.com> <496073AB.2030400@cn.fujitsu.com>
In-Reply-To: <496073AB.2030400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> I have not posted it. -:)
>   
Could you post it?

Paul: What would break if we stop processing rcu entries in (cpu) order?

The head->func(head) in rcu_do_batch() is probably a nightmare for the 
branch target predictor.

What about:
- shrinking struct rcu_head to just a pointer (let's start with the goodie)
- Adding a register_rcu_callback() function.
It allocates the per-cpu storage for the rcu grace period lists.
Seperate lists for each registered callback - thus no need to copy the 
callback target into each rcu_head structure.
It returns a pointer/handle to these lists.
- call_rcu gets that handle instead of the plain function pointer.
- rcu_do_batch enumerates all registered callbacks. Thus first all 
callback_struct->func(head) calls for the first registered callback, 
then the calls for the 2nd callback, etc.
Better for the icache, better for the branch predictor.

Paul: Do you have a test case that is suitable for benchmarking rcu?
Any workloads were rcu appears significantly in oprofile?
And: Do you know how many rcu entries are typically alive? How much 
memory is used for the function pointers?

--
    Manfred

