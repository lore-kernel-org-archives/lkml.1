Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYILEzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYILEzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 00:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYILEzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 00:55:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55932 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYILEzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 00:55:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
Date: Fri, 12 Sep 2008 14:55:00 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080908183852.GA3713@elte.hu> <48C84E9E.7080507@sgi.com>
In-Reply-To: <48C84E9E.7080507@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121455.02180.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 08:47:58 Mike Travis wrote:
> Here's an initial proposal for abstracting cpumask_t to be either
> an array of 1 or a pointer to an array...   Hopefully this will
> minimize the amount of code changes while providing the capabilities
> this change is attempting to do.
>
> Comments most welcome. ;-)

I think this is still "wrong way go back".

I'm yet to be convinced that we really need to allocate cpumasks in any fast 
paths.  And if not, we should simply allocate them everywhere.  I'd rather 
see one #ifdef around a place where we can show a perf issue.

Get rid of CPU_MASK_ALL et al in favour of cpu_mask_all.  And cpu_mask_any_one 
instead of CPU_MASK_CPU0 since that's usually what they want.

API looks like so (look Ma, no typedefs!)

	struct cpumask *cpus;

	cpus = cpumask_alloc();
	if (!cpus)
		return -ENOMEM;

	cpumask_init_single(cpunum);
	OR
	cpumask_init(cpu_mask_all);
	...
	cpumask_free(cpus);

Unmistakable and really hard to screw up.  You can even be clever and not 
reveal the struct cpumask definition so noone can declare one by accident...

Cheers,
Rusty.
