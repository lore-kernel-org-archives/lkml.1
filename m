Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbXJPAUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbXJPAUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXJPAUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:20:10 -0400
Received: from waste.org ([66.93.16.53]:56005 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXJPAUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:20:08 -0400
Date: Mon, 15 Oct 2007 19:18:50 -0500
From: Matt Mackall <mpm@selenic.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 1/11] maps3: add proportional set size accounting in smaps
Message-ID: <20071016001850.GA19691@waste.org>
References: <2.290135367@selenic.com> <alpine.DEB.0.9999.0710151633150.16611@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0710151633150.16611@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 04:36:38PM -0700, David Rientjes wrote:
> On Mon, 15 Oct 2007, Matt Mackall wrote:
> 
> > Index: l/fs/proc/task_mmu.c
> > ===================================================================
> > --- l.orig/fs/proc/task_mmu.c	2007-10-14 13:35:31.000000000 -0500
> > +++ l/fs/proc/task_mmu.c	2007-10-14 13:36:56.000000000 -0500
> > @@ -122,6 +122,27 @@ struct mem_size_stats
> >  	unsigned long private_clean;
> >  	unsigned long private_dirty;
> >  	unsigned long referenced;
> > +
> > +	/*
> > +	 * Proportional Set Size(PSS): my share of RSS.
> > +	 *
> > +	 * PSS of a process is the count of pages it has in memory, where each
> > +	 * page is divided by the number of processes sharing it.  So if a
> > +	 * process has 1000 pages all to itself, and 1000 shared with one other
> > +	 * process, its PSS will be 1500.               - Matt Mackall, lwn.net
> > +	 */
> > +	u64 	      pss;
> > +	/*
> > +	 * To keep (accumulated) division errors low, we adopt 64bit pss and
> > +	 * use some low bits for division errors. So (pss >> PSS_DIV_BITS)
> > +	 * would be the real byte count.
> > +	 *
> > +	 * A shift of 12 before division means(assuming 4K page size):
> > +	 * 	- 1M 3-user-pages add up to 8KB errors;
> > +	 * 	- supports mapcount up to 2^24, or 16M;
> > +	 * 	- supports PSS up to 2^52 bytes, or 4PB.
> > +	 */
> > +#define PSS_DIV_BITS	12
> >  };
> >  
> 
> I know this gets moved again in the eighth patch of the series, but the 
> #define still has no place inside the struct definition.

Agreed.
 
> The pss is going to need accessor functions, preferably inlined, and the 
> comment adjusted stating that all accesses should be through those 
> functions and not directly to the mem_size_stats struct.
> 
> 	static inline u64 pss_up(unsigned long pss)
> 	{
> 		return pss << PSS_DIV_BITS;
> 	}
> 
> 	static inline unsigned long pss_down(u64 pss)
> 	{
> 		return pss >> PSS_DIV_BITS;
> 	}

I think that's overkill for something that has exactly one use of each.

-- 
Mathematics is the supreme nostalgia of our time.
