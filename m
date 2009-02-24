Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZBXMlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZBXMlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZBXMlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:41:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZBXMlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:41:05 -0500
Date: Tue, 24 Feb 2009 13:40:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224124042.GA31295@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3DE76.5010606@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> > Hm, i think there still must be some basic misunderstanding 
> > somewhere here. Let me describe the design i described in the 
> > previous mail in more detail.
> > 
> > In one of your changelogs you state:
> > 
> > |    On NUMA, embedding allocator can't be used as different 
> > |    units can't be made to fall in the correct NUMA nodes.
> > 
> > This is a direct consequence of the unit/chunk abstraction,
> 
> Not at all.  That's an optimization for !NUMA.  The remap 
> allocator is what can be done on NUMA.  Chunking or not 
> doesn't make any difference in this regard.  The only 
> difference between chunking and not chunking is whether 
> separately allocated percpu offsets have more or less holes 
> inbetween them, which is irrelevant for all purposes.

It's not an optimization, it's a pessimisation :)

Please read what i wrote to you. We want the percpu static and 
dynamic areas to be _one and the same thing_. (With just the 
different that static allocations have a handy compile-time 
offset shortcut - but the access is still the same.)

Right now, with your latest code we still have this:

   * Use this to get to a cpu's version of the per-cpu object
   * dynamically allocated. Non-atomic access to the current  CPU's
   * version should probably be combined with get_cpu()/put_cpu().
   */
  #define per_cpu_ptr(ptr, cpu)   SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))

This slows down per_cpu_ptr() and makes the dynamic percpu case 
a second-class citizen because most actual usages are for the 
current CPU, still have to go via the per_cpu_offset() 
indirection.

I.e. we have things like:

        const int cpu = get_cpu();

        u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);

Instead of a straight:

        u8 *scratch = *this_cpu_ptr(ipcomp_scratches);

We cannot do that optimization due to the NUMA and SMP 
assymetry. If NUMA and SMP had the same linear structure, as i 
suggested we do, we could do it.

Currently you rely on per_cpu_offset() indirection basically as 
a soft-TLB entry covering all dynamic allocations. That sucks.

Ok?

	Ingo
