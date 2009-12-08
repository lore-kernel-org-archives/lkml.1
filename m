Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZLHLYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZLHLYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZLHLYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:24:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:49083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZLHLYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:24:31 -0500
Message-ID: <4B1E378A.5050101@kernel.org>
Date: Tue, 08 Dec 2009 20:24:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org> <1260268453.3935.1106.camel@laptop>
In-Reply-To: <1260268453.3935.1106.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 07:34 PM, Peter Zijlstra wrote:
> On Tue, 2009-12-08 at 18:12 +0900, Tejun Heo wrote:
>>> So its only needed in order to flush a workqueue from CPU_DOWN_PREPARE?
>>> And all you need it to place a new kthread on a !active cpu?
>>
>> Yes, that's all I need. 

Let me augment the above sentence.  Yes, that's all I need *during
CPU_DOWN*.  During CPU_UP, I need to migrate back left running workers
which survived from the last CPU_DOWN.  In the original patch, the
down path is worker_maybe_bind_and_lock() and the latter path is
trustee_unset_rogue().

> Then you don't need most of that patch, you don't need to touch the
> migration stuff since a new kthread isn't running.
> 
> All you need to do is make a kthread_bind/set_cpus_allowed variant that
> checks against cpu_online_mask instead of cpu_active_mask.

kthread_bind() doesn't check against cpu_online_mask.  Isn't
set_cpus_allowed() variant which checks against cpu_online_mask is
what's implemented by the patch (+ PF_THREAD_BOUND bypass)?

> It might even make sense to have kthread_bind() always check with
> cpu_online_mask as the kernel really ought to know what its doing
> anyway.

Oh... yeah, it was a bit strange that the function doesn't check
against cpu onliness but if that is removed what would be the point of
kthread_bind() when set_cpus_allowed() provides pretty much the same
capability?

> You also don't need to play trickery with PF_THREAD_BOUND, since a new
> kthread will not have that set.

Yeap, but when the cpu comes back online, those kthreads need to be
rebound to the cpu.

> In fact, your patch is against a tree that still has cpu_online_mask in
> all those places, so you wouldn't have needed any of that, confused.. ?!

To migrate back the workers from CPU_ONLINE callback.

Thanks.

-- 
tejun
