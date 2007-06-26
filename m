Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXFZBmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXFZBmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXFZBlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 21:41:52 -0400
Received: from dsl.myri.com ([64.172.73.26]:1966 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751272AbXFZBlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 21:41:52 -0400
Message-ID: <46806E8D.90403@myri.com>
Date: Mon, 25 Jun 2007 21:40:29 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTRR: Fix race causing set_mtrr to go into infinite loop
References: <468035BC.9080008@myri.com> <46803C1D.2040009@redhat.com> <200706260034.41940.ak@suse.de>
In-Reply-To: <200706260034.41940.ak@suse.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2007 6:34 PM, Andi Kleen wrote:
> On Tuesday 26 June 2007 00:05:17 Chuck Ebbert wrote:
>   
>> On 06/25/2007 05:38 PM, Loic Prylli wrote:
>>
>> [cc: Andi]
>>
>>     
>>> Processors synchronization in set_mtrr requires the .gate field
>>> to be set after .count field is properly initialized. Without an explicit
>>> barrier, the compiler was reordering those memory stores. That was sometimes
>>> causing a processor (in ipi_handler) to see the .gate change and
>>> decrement .count before the latter is set by set_mtrr() (which
>>> then hangs in a infinite loop with irqs disabled).
>>>       
>
> Hmm, perhaps we should just put the smp_wmb into atomic_set().
> Near all other atomic operations have memory barriers too. I think
> that would be the better fix.
>
> -Andi
>   


In Documentation/atomic_ops.txt atomic_set/atomic_read are described as
nothing more than a type-safe assignement or reading, without any extra
semantics. For other atomic operations, the rule is that any atomic
operation that doesn't return a value doesn't come with a barrier (and
any operation that returns the atomic value must have memory barriers).

So I guess you are suggesting to change the doc and the implementation
for all arches.

I should admit I did not knew a number of atomic operations did not
imply memory-barriers before. But maybe the extra cost might not be
completely negligible, especially if, for consistency with other
"barrier-implied" atomic operations, a new memory barrier is put before
and after,

Are you suggested changing just atomic_set(), or also other barrier-free
atomic operations :"atomic_dec", "atomic_inc", "atomic_add", "atomic_sub" ?

Independently of what is done to atomic, what about not making the .gate
field an atomic_t, but a simple "int" in the mttr code, since the only
operations done on it are atomic_read and atomic_set?


Loic

