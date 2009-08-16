Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZHPL15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZHPL15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 07:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZHPL15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 07:27:57 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:46902 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZHPL14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 07:27:56 -0400
Message-ID: <4A87ED93.5060104@colorfullife.com>
Date: Sun, 16 Aug 2009 13:29:23 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com> <20090816103127.GB8644@wotan.suse.de>
In-Reply-To: <20090816103127.GB8644@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 12:31 PM, Nick Piggin wrote:
> On Sat, Aug 15, 2009 at 06:32:14PM +0200, Manfred Spraul wrote:
>    
>> It depends. After disabling inlining, including all helper functions
>> that differ:
>>
>> My proposal: 301 bytes for update_queue.
>>
>> "simple", only negv: 226 bytes
>> "simple, negv+zero: 354 bytes
>> simple+complex: 526 bytes.
>>
>> Thus with only +-1 simple ops, your version uses less icache. If both
>> +-1 and 0 ops are used, your version uses more icache.
>>      
> Don't forget that in that case, your version is badly suboptimal
> due to the algorithmic complexity.
>    
I know, I mentioned it in the change log:
Waking up one "decrement by one" task is O(1) with your code and 
O(1+<number of waiting-for-zero tasks>) with my code.

This is the price paid for saving memory:
Your version keeps three pointers per semaphore (waiting-for-zero, 
oldest decrement, newest decrement)
My version keeps only two pointers (newest decrement, waiting-for-zero). 
The "oldest decrement" is reconstructed on the fly, and that operation 
is O(<number of waiting-for-zero tasks>).

--
     Manfred
