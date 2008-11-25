Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKYQys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKYQys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKYQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:54:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYKYQyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:54:39 -0500
Message-ID: <492C2D11.2030308@redhat.com>
Date: Tue, 25 Nov 2008 18:51:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: suparna@in.ibm.com, Zach Brown <zach.brown@oracle.com>,
       linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu>
In-Reply-To: <20081125145949.GD14147@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>   
>> Perhaps a variant of syslet, that is kernel-only, and does:
>>
>> - always allocate a new kernel stack at io_submit() time, but not a 
>>   new thread
>>     
>
> such a N:M threading design is a loss - sooner or later we arrive to a 
> point where people actually start using it and then we want to 
> load-balance and schedule these entities.
>   

It's only N:M as long as its nonblocking.  If it blocks it becomes 1:1 
again.  If it doesn't, it's probably faster to do things on the same 
cache as the caller.

> So i'd suggest the kthread based async engine i wrote for syslets. It 
> worked well and for kernel-only entities it schedules super-fast - it 
> can do up to 20 million events per second on a 16-way box i'm testing 
> on. The objections about syslets were not related to the scheduling of 
> it but were mostly about the userspace API/ABI: you dont have to use 
> that.

I'd love to have something :)

I guess any cache and latency considerations could be fixed if
- we schedule a syslet for the first time when the thread that launched 
it exits to userspace
- we queue it on the current cpu's runqueue

In that case, for the nonblocking case syslets and fibrils would have 
very similar performance.

-- 
error compiling committee.c: too many arguments to function

