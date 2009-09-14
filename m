Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZINCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZINCli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZINClf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:41:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:50130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZINClf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:41:35 -0400
Date: Mon, 14 Sep 2009 04:45:10 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       peterz@infradead.org, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-ID: <20090914044510.511d2ac9@infradead.org>
In-Reply-To: <20090913163007.a1b967c2.akpm@linux-foundation.org>
References: <20090911174019.1ed02737@infradead.org>
	<20090913163007.a1b967c2.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Sep 2009 16:30:07 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> We can't just fix up the existing code?

we could, it'd be just replacing menu.c.
(since the new one started out with menu.c anyway)
I don't mind either way, will replace. 

> > +#define BUCKETS 12
> > +#define RESOLUTION 1024
> > +#define DECAY 4
> > +#define MAX_INTERESTING 50000
> 
> Interesting!  Unobvious what it does though.

at least I documented it:
   * the actual factor is if there is (disk) IO outstanding or not.
   * (as a special twist, we consider every sleep longer than 50 milliseconds
   * as perfect; there is no power gains for sleeping longer than this)

> 
> That's DIV_ROUND_UP().

ok

> > +	new_factor = data->correction_factor[data->bucket]
> > +			* (DECAY - 1) / DECAY;
> 
> This code is available on 32-bit.  I wouldn't be surprised if we see
> some udivdi2-isn't-there problems with some compiler versions.  We'll
> see.

at least not on the ones I tried. DECAY is "4" which means it'll be
shifts anyway (that's not entirely accidental)

> > +
> > +unsigned long this_cpu_load(void)
> > +{
> > +	int this_cpu = smp_processor_id();
> > +	struct rq *this_rq = cpu_rq(this_cpu);
> > +	return this_rq->cpu_load[0];
> > +}
> 
> hm, how come we don't get smp_processor_id-in-preemptible warnings. 
> Are all current callers pinned to a CPU?

the idle loop is pinned by definition, and also runs with irqs off

"all current callers".. this is a new function, with menutng being the
only caller. I'm fine with requiring all callers to be pinned, it's
*this* cpu's load after all ;-)



> 
> 
> some spelling fixlets:

never been my strong point (esp when jetlagged); thanks!


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
