Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZBXOMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZBXOMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZBXOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:12:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbZBXOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:12:40 -0500
Date: Tue, 24 Feb 2009 15:12:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224141217.GA17287@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224124042.GA31295@elte.hu> <49A3F5C5.4060107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3F5C5.4060107@kernel.org>
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

> What's missing is unification of static and dynamic accessors 
> and thus the faster accessors - percpu_read() and friends - 
> for dynamic ones. This will be the next round of patches.

Ok, good - we are in agreement then and i'll wait for those 
patches.

And i think i finally decoded the real source of the disconnect
:-)

It's still about this restriction:

+       /*
+        * If large page isn't supported, there's no benefit in doing
+        * this.  Also, embedding allocation doesn't play well with
+        * NUMA.
+        */
+       if (!cpu_has_pse || pcpu_need_numa())
+               return -EINVAL;

This is what makes no sense (why force the static percpu area 
into 4K mappings on NUMA).

You do it because i think you misunderstood my original 2MB TLB 
static area suggestion. setup_pcpu_embed() does this now:

+       pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
+                                      PAGE_SIZE);

That is not NUMA-friendly indeed.

What should be done instead is to up the unit size to 2MB as i 
suggested, and to allocate 2MB sized and 2MB aligned 
numa-correct area for each CPU, via bootmem.

To quote my original mail:

> > - allocate the static percpu area using bootmem-alloc, but
> >   using a 2MB alignment parameter and a 2MB aligned size. Then
> >   we can remap it to some convenient and undisturbed virtual
> >   memory area, using 2MB TLBs. [*]

I.e. each individual 2MB allocated largepage can then be 
remapped as a 2MB TLB to the high (vmalloc) area. Followed by 
ordinary 4K mappings for regular percpu_alloc() pages.

( and the partial, unused pages within this initial chunk are 
  returned to bootmem. )

That will be NUMA-friendly and i suspect we should also use it 
on SMP just to get that aspect of the code tested better.

Do _not_ allocate the units together in one bootmem allocation 
because that's not NUMA-friendly.

Ok?

	Ingo
