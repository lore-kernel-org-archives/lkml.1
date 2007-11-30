Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbXK3RFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbXK3RFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXK3RFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:05:22 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:33123 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729AbXK3RFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:05:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAE/RT0dMROHU/2dsb2JhbACBWw
Date: Fri, 30 Nov 2007 12:05:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
Message-ID: <20071130170516.GA31586@Krystal>
References: <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost> <20071116143019.GA16082@Krystal> <1195495485.27759.115.camel@localhost> <20071128140953.GA8018@Krystal> <1196268856.18851.20.camel@localhost> <20071129023421.GA711@Krystal> <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal> <1196444801.18851.127.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1196444801.18851.127.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:52:08 up 26 days, 21:57,  5 users,  load average: 1.56, 1.27,
	1.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> On Fri, 2007-11-30 at 11:11 -0500, Mathieu Desnoyers wrote:
> > +static inline swp_entry_t page_swp_entry(struct page *page)
> > +{
> > +       swp_entry_t entry;
> > +       VM_BUG_ON(!PageSwapCache(page));
> > +       entry.val = page_private(page);
> > +       return entry;
> > +}
> 
> This probably needs to be introduced (and used) in a separate patch.
> Please fix up those other places in the code that can take advantage of
> it.
> 
Sure,

> >  #ifdef CONFIG_MIGRATION
> >  static inline swp_entry_t make_migration_entry(struct page *page, int
> > write)
> >  {
> > Index: linux-2.6-lttng/mm/swapfile.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/swapfile.c  2007-11-30 09:18:38.000000000
> > -0500
> > +++ linux-2.6-lttng/mm/swapfile.c       2007-11-30 10:21:50.000000000
> > -0500
> > @@ -1279,6 +1279,7 @@ asmlinkage long sys_swapoff(const char _
> >         swap_map = p->swap_map;
> >         p->swap_map = NULL;
> >         p->flags = 0;
> > +       trace_mark(mm_swap_file_close, "filp %p", swap_file);
> >         spin_unlock(&swap_lock);
> >         mutex_unlock(&swapon_mutex);
> >         vfree(swap_map);
> > @@ -1660,6 +1661,8 @@ asmlinkage long sys_swapon(const char __
> >         } else {
> >                 swap_info[prev].next = p - swap_info;
> >         }
> > +       trace_mark(mm_swap_file_open, "filp %p filename %s",
> > +               swap_file, name); 
> 
> You print out the filp a number of times here, but how does that help in
> a trace?  If I was trying to figure out which swapfile, I'd probably
> just want to know the swp_entry_t->type, then I could look at this:
> 
> dave@foo:~/garbage$ cat /proc/swaps 
> Filename                                Type            Size    Used    Priority
> /dev/sda2                               partition       1992052 649336  -1
> 
> to see the ordering.
> 

Given a trace including :
- Swapfiles initially used
- multiple swapon/swapoff
- swap in/out events

We would like to be able to tell which swap file the information has
been written to/read from at any given time during the trace.

Therefore, I dump the swap file information at the beginning of the
trace (see the ltt_dump_swap_files function) and also follow each
swapon/swapoff.

The minimal information that has to be saved at each swap read/write
seems to be the struct file * that is used by the operation. We can then
map back to the file used by knowing the mapping between struct file *
and associated file names (dump/swapon/swapoff instrumentation).

The swp_entry_t->type does not seem to map to any specific information
in /proc/swaps ? (or I may have missed a detail) Even if it does, it is
limited to a specific point in time and does not follow swapon/swapoff
events.

You are talking about ordering in /proc/swaps : I wonder what happens if
we add/remove swap files from the array : I guess the swp_entry_t
ordering may become mixed up with the order of the /proc/swaps output,
since it is based on the swap_info array which will fill empty spots
upon swapon (again, unless I missed a clever detail).

Mathieu

> -- Dave
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
