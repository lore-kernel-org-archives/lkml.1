Return-Path: <linux-kernel-owner+w=401wt.eu-S1764244AbXK3TK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764244AbXK3TK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbXK3TKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:10:11 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:36837 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbXK3TKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:10:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANbuT0dMROHU/2dsb2JhbACBWw
Date: Fri, 30 Nov 2007 14:10:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
Message-ID: <20071130191006.GB3955@Krystal>
References: <20071116143019.GA16082@Krystal> <1195495485.27759.115.camel@localhost> <20071128140953.GA8018@Krystal> <1196268856.18851.20.camel@localhost> <20071129023421.GA711@Krystal> <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal> <1196444801.18851.127.camel@localhost> <20071130170516.GA31586@Krystal> <1196448122.19681.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1196448122.19681.16.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:58:46 up 27 days, 4 min,  7 users,  load average: 5.95, 6.11,
	3.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> On Fri, 2007-11-30 at 12:05 -0500, Mathieu Desnoyers wrote:
> > 
> > 
> > Given a trace including :
> > - Swapfiles initially used
> > - multiple swapon/swapoff
> > - swap in/out events
> > 
> > We would like to be able to tell which swap file the information has
> > been written to/read from at any given time during the trace.
> 
> Oh, tracing is expected to be on at all times?  I figured someone would
> encounter a problem, then turn it on to dig down a little deeper, then
> turn it off.
> 

Yep, it can be expected to be on at all times, especially on production
systems using "flight recorder" tracing to record information in a
circular buffer, then dumping the buffers when some triggers (error
conditions) happens.

> As for why I care what is in /proc/swaps.  Take a look at this:
> 
> struct swap_info_struct *
> get_swap_info_struct(unsigned type)
> {
>         return &swap_info[type];
> }
> 
> Then, look at the proc functions: 
> 
> static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
> {
>         struct swap_info_struct *ptr;
>         struct swap_info_struct *endptr = swap_info + nr_swapfiles;
> 
>         if (v == SEQ_START_TOKEN)
>                 ptr = swap_info;
> ...
> 
> I guess if that swap_info[] has any holes, we can't relate indexes in
> there right back to /proc/swaps, but maybe we should add some
> information so that we _can_.
> 

The if (!(ptr->flags & SWP_USED) test in swap_next seems to skip the
unused swap_info entries.

Why should we care about get_swap_info_struct always returning a "used"
swap info struct ?

> -- Dave
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
