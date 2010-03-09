Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0CIUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:33:43 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34729 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0CIUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:33:42 -0500
Date: Tue, 9 Mar 2010 14:33:19 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
In-Reply-To: <20100309122253.3f3d4a53.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1003091431330.28897@router.home>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <20100309122253.3f3d4a53.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Andrew Morton wrote:

> > __zone_pcp_update() iterates over NR_CPUS instead of limiting the
> > access to the possible cpus. This might result in access to
> > uninitialized areas as the per cpu allocator only populates the per
> > cpu memory for possible cpus.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  mm/page_alloc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -3224,7 +3224,7 @@ static int __zone_pcp_update(void *data)
> >  	int cpu;
> >  	unsigned long batch = zone_batchsize(zone), flags;
> >
> > -	for (cpu = 0; cpu < NR_CPUS; cpu++) {
> > +	for_each_possible_cpu(cpu) {
> >  		struct per_cpu_pageset *pset;
> >  		struct per_cpu_pages *pcp;
> >
>
> I'm having trouble working out whether we want to backport this into
> 2.6.33.x or earlier.  Help?

Nope. This problem was created as a result of the dynamic allocation of
pagesets from percpu memory that went in during the merge window.
(99dcc3e5a94ed491fbef402831d8c0bbb267f995)

