Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYILO3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYILO3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYILO3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:29:00 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751273AbYILO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:28:59 -0400
Message-ID: <48CA7CA8.2000107@sgi.com>
Date: Fri, 12 Sep 2008 07:28:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080908183852.GA3713@elte.hu> <48C84E9E.7080507@sgi.com> <200809121455.02180.rusty@rustcorp.com.au>
In-Reply-To: <200809121455.02180.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 11 September 2008 08:47:58 Mike Travis wrote:
>> Here's an initial proposal for abstracting cpumask_t to be either
>> an array of 1 or a pointer to an array...   Hopefully this will
>> minimize the amount of code changes while providing the capabilities
>> this change is attempting to do.
>>
>> Comments most welcome. ;-)
> 
> I think this is still "wrong way go back".
> 
> I'm yet to be convinced that we really need to allocate cpumasks in any fast 
> paths.  And if not, we should simply allocate them everywhere.  I'd rather 
> see one #ifdef around a place where we can show a perf issue.
> 
> Get rid of CPU_MASK_ALL et al in favour of cpu_mask_all.  And cpu_mask_any_one 
> instead of CPU_MASK_CPU0 since that's usually what they want.
> 
> API looks like so (look Ma, no typedefs!)
> 
> 	struct cpumask *cpus;
> 
> 	cpus = cpumask_alloc();
> 	if (!cpus)
> 		return -ENOMEM;
> 
> 	cpumask_init_single(cpunum);
> 	OR
> 	cpumask_init(cpu_mask_all);
> 	...
> 	cpumask_free(cpus);
> 
> Unmistakable and really hard to screw up.  You can even be clever and not 
> reveal the struct cpumask definition so noone can declare one by accident...
> 
> Cheers,
> Rusty.

Using a typedef came from Linus, and the idea is basically if NR_CPUS fits
into a long, then it's carried as an array of one (ie., local variable).
If it's bigger, then it's a pointer to a remote array.  The references can
all be pointers (*cpumask), though most of the references use the cpu_XXX
operators which already treat the references correctly (in my proposal,
that is).  That way, small systems can optimize out the indirect reference
and the overhead becomes zero.

Also, cpumask_alloc/free() becomes nop's for small systems.

But I like the idea of dumping some of the initializers.  I should have
made CPU0 "cpumask_of_cpu(0)".  I'll have to look at where they are used to
see if this is feasible.

Thanks!
Mike
