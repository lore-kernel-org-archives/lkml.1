Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXGKAEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXGKAEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764709AbXGKACm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:02:42 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:45285 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764651AbXGKACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:02:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vbrlfZqcMxommBirezIH1M+fw8gPA0UMbvwzY4ICJE4o7AIKjC5f0LnRKJpJ89s6ERtx4orwLjhMclPlK7qhxv8qXMM0nZB4mUJSRRtXJtB1Gy3r1khDv8RwVv2Fcg431wTlMmsGygKdJ7iPGFWWWrAuThwXoqnPlDT+/gKqyN0=  ;
X-YMail-OSG: LHKRQv0VM1ng1pG1hHt7uOQdppJ9w2kG6YHmiS.xgOgJ6fLBDfu.2xdVTJCNjGa6ET_IQsz9lw--
Message-ID: <46941E0F.3040209@yahoo.com.au>
Date: Wed, 11 Jul 2007 10:02:23 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au> <20070710233938.GT11166@waste.org>
In-Reply-To: <20070710233938.GT11166@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, Jul 06, 2007 at 04:12:10PM +1000, Nick Piggin wrote:
> 
>>Mathieu Desnoyers wrote:
>>
>>>Thread Migration Preemption
>>>
>>>This patch adds the ability to protect critical sections from migration to
>>>another CPU without disabling preemption.
>>>
>>>This will be useful to minimize the amount of preemption disabling for the 
>>>-rt
>>>patch. It will help leveraging improvements brought by the local_t types in
>>>asm/local.h (see Documentation/local_ops.txt). Note that the updates done 
>>>to
>>>variables protected by migration_disable must be either atomic or 
>>>protected from
>>>concurrent updates done by other threads.
>>>
>>>Typical use:
>>>
>>>migration_disable();
>>>local_inc(&__get_cpu_var(&my_local_t_var));
>>>migration_enable();
>>>
>>>Which will increment the variable atomically wrt the local CPU.
>>>
>>>Comments (such as how to integrate this in the already almost full
>>>preempt_count) are welcome.
>>
>>This seems like way too much stuff to add just for this type of thing. Why
>>not just disable and reenable preempt? Surely local_inc is not going to take
>>so long that disabling preemption matters.
> 
> 
> I like this patch a lot. Even if we don't add the underlying mechanism
> right now, adding migration_disable as an alias for preempt_disable
> will much better document quite a number of the users.

I'd have no problem with that, and it might make it easier in future to
justify a more complex scheme.


>>The task struct is not something we should just be carefree putting crap
>>into because it is seemingly free :(
> 
> 
> Sadly, it is free at the moment. We can only fit 3 task_structs in an order-1 SLAB,
> with lots of slop.

Well apart from more cacheline access, that's why I say seemingly free. But
actually it uses up space we may like for something else in future and/or
makes it harder to shrink down if any effort ever goes into that.

-- 
SUSE Labs, Novell Inc.
