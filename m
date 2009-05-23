Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZEWM6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZEWM6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZEWM6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:58:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51652 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZEWM6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:58:34 -0400
Date: Sat, 23 May 2009 14:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] sparseirq: Enable early irq_desc allocation.
Message-ID: <20090523125748.GB23042@elte.hu>
References: <20090521165647.GA320@linux-sh.org> <4A15B8F2.9000804@kernel.org> <20090522014008.GA2806@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522014008.GA2806@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, May 21, 2009 at 01:26:26PM -0700, Yinghai Lu wrote:
> > can you check tip?
> > we change _cpu to node already.
> > 
> > also only sh have after_bootmem now.
> > arch/sh/mm/init.c:int after_bootmem = 0;
> > arch/sh/mm/init.c:      after_bootmem = 1;
> > arch/sh/mm/ioremap_64.c:        extern int after_bootmem;
> > arch/sh/mm/ioremap_64.c:        if (after_bootmem) {
> > include/linux/mm.h:extern int after_bootmem;
> > 
> > for x86 we have bootmem_state ...
> > arch/x86/include/asm/page_types.h:enum bootmem_state {
> > arch/x86/include/asm/page_types.h:extern enum bootmem_state bootmem_state;
> > arch/x86/kernel/setup.c:        bootmem_state = DURING_BOOTMEM;
> > arch/x86/mm/init.c:enum bootmem_state bootmem_state = BEFORE_BOOTMEM;
> > arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> > arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> > arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM && !start) {
> > arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM &&
> > arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
> > 
> > Andrew,
> > do we need to move bootmem_state back to linux/mm.h?
> 
> No need, I just switched to slab_is_available() in the respin. Here is
> v2, against -tip:

thanks.

I'm a bit unhappy about allocators here (and this is not your 
fault). There's not two but _three_ states for allocation: bootmem, 
pagealloc, kmalloc. There is a (short) stage during bootup where 
kmalloc is not enabled yet and bootmem is already deactivated. If we 
ever use slab_is_available() in such a state it will blow up.

Fixing all this allocator bootstrapping mess we have in Linux is a 
lot larger project though.

	Ingo
