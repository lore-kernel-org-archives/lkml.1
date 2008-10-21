Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYJUM0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYJUM0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJUM0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:26:31 -0400
Received: from ozlabs.org ([203.10.76.45]:60140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYJUM03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:26:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 18/35] cpumask: add nr_cpumask_bits
Date: Tue, 21 Oct 2008 23:26:07 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20081020170319.539427000@polaris-admin.engr.sgi.com> <20081020170322.090531000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081020170322.090531000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810212326.10278.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2008 04:03:37 Mike Travis wrote:
> When nr_cpu_ids is set to CONFIG_NR_CPUS then references to nr_cpu_ids
> will return the maximum index of the configured NR_CPUS (+1) instead
> of the maximum index of the possible number of cpus (+1).  This results
> in extra unused memory being allocated by functions that are setting up
> arrays of structs to keep track of per cpu items.

1) I like the name in this context: it's a beacon of sanity after NR_CPUS and
   nr_cpu_ids.  But it's not so clearly a win when general code uses it:

	if (cpumask_first(mymask) == nr_cpumask_bits) ...

   vs:
   
	if (cpumask_first(mymask) == nr_cpu_ids) ...

2) This breaks anyone who tests that the iterators etc. return == nr_cpu_ids.
   One of the other patches tried to change them from NR_CPUS to nr_cpu_ids,
   that should now be revisited & reaudited.

3) Noone should be naively allocating "* nr_cpu_ids" arrays, they should be
   using per-cpu pointers.  Not doing so wastes memory on non-contiguous
   processor systems.

4) It should be a constant not be dependent on CONFIG_CPUMASK_OFFSTACK, but
   rather as it was on NR_CPUS > BITS_PER_LONG.  I think that's the sweet
   spot, and should also make your 2MB "gain" vanish.

That's why I suggested a max_possible_cpu() function, and using that for those 
who really want to do allocations, who should be audited anyway, see (3).  I 
don't want it as prominent as nr_cpu_ids, which is usually the Right Thing, 
and always safe.

Cheers,
Rusty.
PS.  I have part of a patch for this...
