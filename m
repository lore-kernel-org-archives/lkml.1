Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZBVT2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZBVT2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZBVT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:28:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34716 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZBVT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:28:02 -0500
Date: Sun, 22 Feb 2009 20:27:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090222192748.GB21320@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499FA8D1.8030806@kernel.org>
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

> > So i think the best (and simplest) approach is to:
> > 
> >  - allocate the static percpu area using bootmem-alloc, but 
> >    using a 2MB alignment parameter and a 2MB aligned size. Then 
> >    we can remap it to some convenient and undisturbed virtual 
> >    memory area, using 2MB TLBs. [*]
> > 
> >  - The 'partial' bit of the 2MB page (the one that is outside 
> >    the 4K-uprounded portion of __per_cpu_end - __per_cpu_start) 
> >    can then be freed via bootmem and is available as regular 
> >    pages to the rest of the kernel.
> 
> Heh... that's exactly where the problem is.  If you remap and 
> free what's left.  The remapped area and the freed area will 
> use two separate 2MB TLBs instead of one.  It's probably worse 
> than simply using 4k mappings.

Uhm, no. We'll have one extra 2MB TLB and that's it. Both the 
low linear 2MB TLB and the high remapped alias 2MB TLB will 
cover on average of 256 4K pages. A very good deal still.

We dont want to split up the static percpu area into zillions of 
small 4K TLBs - we'll rather use +1 large-TLB.

If we used 4K ptes we'd waste up to 512 TLB entries. (largely 
simplified as the number of large TLB entries smaller than that 
of 4K TLB, but still the arguments holds in terms of TLB reach.)

So there is no "TLB problem" whatsoever that i can see ...

	Ingo
