Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0CIUfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:35:16 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37435 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0CIUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:35:13 -0500
Date: Tue, 9 Mar 2010 15:33:26 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
In-Reply-To: <20100309122253.3f3d4a53.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003091530230.11928@localhost>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <20100309122253.3f3d4a53.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Andrew Morton wrote:

> On Mon, 8 Mar 2010 10:21:04 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
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
>
> I'm having trouble working out whether we want to backport this into
> 2.6.33.x or earlier.  Help?

  given the above aesthetic mod, shouldn't that same change be applied
to *all* explicit loops of that form?  after all, checkpatch.pl warns
against it:

=====
# use of NR_CPUS is usually wrong
# ignore definitions of NR_CPUS and usage to define arrays as likely right
                if ($line =~ /\bNR_CPUS\b/ &&
                    $line !~ /^.\s*\s*#\s*if\b.*\bNR_CPUS\b/ &&
                    $line !~ /^.\s*\s*#\s*define\b.*\bNR_CPUS\b/ &&
                    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
                    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
                    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
                {
                        WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
                }
=====

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
