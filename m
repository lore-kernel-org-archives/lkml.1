Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXBAAR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXBAAR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161114AbXBAAR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:17:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60556 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbXBAARz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:17:55 -0500
Date: Wed, 31 Jan 2007 16:14:14 -0800
From: Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?Q?Pawe=5F=5F?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <ak@suse.de>
Subject: Re: Linux 2.6.20-rc7
Message-Id: <20070131161414.06e98e4a.akpm@osdl.org>
In-Reply-To: <200702010037.48472.pluto@agmk.net>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<45C05150.6000802@agmk.net>
	<Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
	<200702010037.48472.pluto@agmk.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 00:37:48 +0100
Pawe__ Sikora <pluto@agmk.net> wrote:

> On Wednesday 31 of January 2007 17:04:29 Linus Torvalds wrote:
> > On Wed, 31 Jan 2007, Pawe__ Sikora wrote:
> > > The 2.6.20-rcX have the same nasty bug as 2.6.19.x.
> > >
> > > [ an oops inside kmem_get_pages ]
> > > http://bugzilla.kernel.org/show_bug.cgi?id=7889
> >
> > Pabel, can you detail more exactly which kernels don't work, and which do?
> 
> 2.6.18 works, 2.6.19-rc1 doesn't work.
> git bisect found this bad commit:
> 
> commit e80ee884ae0e3794ef2b65a18a767d502ad712ee
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Wed Oct 4 02:15:23 2006 -0700
> 
>     [PATCH] mm: micro optimise zone_watermark_ok
> 
>     Having min be a signed quantity means gcc can't turn high latency divides
>     into shifts.  There happen to be two such divides for GFP_ATOMIC (ie.
>     networking, ie.  important) allocations, one of which depends on the 
> other.
>      Fixing this makes code smaller as a bonus.
> 
>     Shame on somebody (probably me).
> 
>     Signed-off-by: Nick Piggin <npiggin@suse.de>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> ------------------------- mm/page_alloc.c -----------------------
> @@ -900,7 +900,8 @@ int zone_watermark_ok(struct zone *z, int order, unsigned 
> long mark,
>  		      int classzone_idx, int alloc_flags)
>  {
>  	/* free_pages my go negative - that's OK */
> -	long min = mark, free_pages = z->free_pages - (1 << order) + 1;
> +	unsigned long min = mark;
> +	long free_pages = z->free_pages - (1 << order) + 1;
>  	int o;
> 
>  	if (alloc_flags & ALLOC_HIGH)
> 
> 
> > Apparently it only happens with MEMORY_HOTPLUG (and possibly with just an
> > SMP kernel on UP), which probably explains why it's been around without
> > people really complaining very loudly.
> 
> reverting mentioned commit removes the oops.
> 

urgh.  zone->free_pages is very small - probably zero.  We shouldn't have
got here at all, so something else is wrong.

But local `free_pages' can go negative in normal operation.  I guess
that'll cause us to incorrectly return `true' from zone_watermark_ok, thus
ignoring the watermarks.

The below, I guess.  But we still don't know why this got called against an
empty zone.




Subject: zone_watermark_ok: signedness fix
From: Andrew Morton <akpm@osdl.org>

Local `free_pages' can go negative in normal operation.  I guess that'll cause
us to incorrectly return `true' from zone_watermark_ok, thus ignoring the
watermarks.

Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~zone_watermark_ok-signedness-fix mm/page_alloc.c
--- a/mm/page_alloc.c~zone_watermark_ok-signedness-fix
+++ a/mm/page_alloc.c
@@ -1013,7 +1013,7 @@ int zone_watermark_ok(struct zone *z, in
 		      int classzone_idx, int alloc_flags)
 {
 	/* free_pages my go negative - that's OK */
-	unsigned long min = mark;
+	long min = mark;
 	long free_pages = zone_page_state(z, NR_FREE_PAGES)
 				- (1 << order) + 1;
 	int o;
_

