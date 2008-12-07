Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYLGQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYLGQOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYLGQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:14:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbYLGQOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:14:07 -0500
Message-ID: <493BF648.6060504@redhat.com>
Date: Sun, 07 Dec 2008 18:14:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t
 on stack
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com>
In-Reply-To: <493BF144.9080106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Rusty Russell wrote:
>> We're getting rid on on-stack cpumasks for large NR_CPUS.
>>
>> 1) Use cpumask_var_t and alloc_cpumask_var (a noop normally).  Fallback
>>    code is inefficient but never happens in practice.
>
> Wow, code duplication from Rusty. Things must be bad.
>
> Since we're in a get_cpu() here, how about a per_cpu static cpumask 
> instead? I don't mind the inefficient fallback, just the duplication.
>

Btw, for the general case, instead of forcing everyone to duplicate, how 
about:

cpumask_var_t cpus;

with_cpumask(cpus) {
   ... code to populate cpus
   smp_call_function_some(...);
} end_with_cpumask(cpus);

Where with_cpumask() allocates cpus, and uses a mutex + static fallback 
on failure.

May need a couple of variants (spinlock + GFP_NOWAIT, mutex with 
sleeping allocation).

-- 
error compiling committee.c: too many arguments to function

