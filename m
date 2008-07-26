Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYGZA1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYGZA1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 20:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYGZA1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 20:27:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54089 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827AbYGZA1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 20:27:13 -0400
Message-ID: <488A6F5F.5000105@sgi.com>
Date: Fri, 25 Jul 2008 17:27:11 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64: Optimize percpu accesses
References: <20080725211117.586723000@polaris-admin.engr.sgi.com> <488A613E.50305@goop.org>
In-Reply-To: <488A613E.50305@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> This patchset provides the following:
>>
>>   * x86_64: Cleanup setup_percpu by fixing some minor potential
>>     problems as well as add some debugging aids.
>>
>>   * x86_64: Rebase per cpu variables to zero
>>
>>     Rebase per cpu variables to zero in preparation for the following
>>     patch to fold the pda into the per cpu area.
>>
>>   * x86_64: Fold pda into per cpu area
>>
>>     Declare the pda as a per cpu variable. This will allow the per cpu
>>     variables to be accessible on the x86_64 using %gs as the base of
>>     the percpu areas for each cpu:
>>
>>     %gs:per_cpu_xxxx
>>
>>   * x86_64: Reference zero-based percpu variables offset from gs
>>
>>     Actually implement the above operation for __get_cpu_var() and
>>     __put_cpu_var().  Since this is now a single instruction, we
>>     can remove the non-preemptible versions of x86_read_percpu()
>>     and x86_write_percpu().
>>   
> 
> No, I think you've misunderstood these calls.
> 
> get_cpu_var(x) evaluates to an lvalue of this cpu's 'x'.  It disables
> preemption, in the same manner as get_cpu().
> 
> put_cpu_var(x) does nothing more than re-enable preemption, to pair with
> get_cpu_var().
> 
> __get_cpu_var(x) is the same as get_cpu_var, but it assumes that
> preemption is already disabled.  There is no __put_cpu_var().
> 
> The important point is that an expression like "__get_cpu_var(x) = foo"
> does not evaluate to a single instruction, and is not preempt or
> interrupt -atomic.  That's the reason x86_X_percpu() exist, since
> they're a single instruction in an asm.  However, with %gs: based
> addressing they can be easily unified.
> 
>    J

Yes, you're right, I wrote that quickly without really reading it back.
My point is that now that x86_read_percpu() and x86_write_percpu() do
evaluate to a single instruction (by definition atomic), then it doesn't
need to be surrounded by the preempt_disable()/preempt_enable() calls.

It appears as if I'm implying that's the case for get/put_cpu_var().

Thanks,
Mike


