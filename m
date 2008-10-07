Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYJGOPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYJGOPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYJGOPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:15:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbYJGOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:15:37 -0400
Message-ID: <48EB6EE4.8030703@linux-foundation.org>
Date: Tue, 07 Oct 2008 09:15:00 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, minyard@acm.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>	 <48EA8197.6080502@cosmosbay.com> <1223367480.26330.7.camel@lappy.programming.kicks-ass.net> <48EB2AE3.3080200@cosmosbay.com>
In-Reply-To: <48EB2AE3.3080200@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
>>> Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
>>> for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() done
>>> in sk_prot_free() can defer freeing to RCU...
>>
>> Be careful!, SLAB_DESTROY_BY_RCU just means the slab page gets
>> RCU-freed, this means that slab object pointers stay pointing to valid
>> memory, but it does _NOT_ mean those slab objects themselves remain
>> valid.
>>
>> The slab allocator is free to re-use those objects at any time -
>> irrespective of the rcu-grace period. Therefore you will have to be able
>> to validate that the object you point to is indeed the object you
>> expect, otherwise strange and wonderful things will happen.
>>
> Thanks for this clarification. I guess we really need a rcu head then :)

No you just need to make sure that the object you located is still active
(f.e. refcount > 0) and that it is really a match (hash pointers may be
updated asynchronously and therefore point to the object that has been reused
for something else).

Generally it is advisable to use SLAB_DESTROY_BY_RCU because it preserves the
cache hot advantages of the objects. Regular RCU freeing will let the object
expire for a tick or so which will result in the cacheline cooling down.


