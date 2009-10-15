Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbZJOWl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbZJOWl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbZJOWl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:41:57 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:14576 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbZJOWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:41:57 -0400
X-Trace: 271685631/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEANtB10pPRQOG/2dsb2JhbACBUtdIhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="271685631"
Date: Thu, 15 Oct 2009 23:41:19 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] swap_info: change to array of pointers
In-Reply-To: <20091015111107.b505b676.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0910152324220.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150146210.3291@sister.anvils>
 <20091015111107.b505b676.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Oct 2009 01:48:01 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > --- si1/mm/swapfile.c	2009-10-14 21:25:58.000000000 +0100
> > +++ si2/mm/swapfile.c	2009-10-14 21:26:09.000000000 +0100
> > @@ -49,7 +49,7 @@ static const char Unused_offset[] = "Unu
> >  
> >  static struct swap_list_t swap_list = {-1, -1};
> >  
> > -static struct swap_info_struct swap_info[MAX_SWAPFILES];
> > +static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> >  
> 
> Could you add some comment like this ?
> ==
> nr_swapfile is never decreased.
> swap_info[type] pointer will never be invalid if it turns to be valid once.
> 
> 
> for (i = 0; i < nr_swapfiles; i++) {
> 	smp_rmp();
> 	sis = swap_info[type];
> 	....
> } 
> Then, we can execute above without checking sis is valid or not.
> smp_rmb() is required when we do above loop without swap_lock().

I do describe this (too briefly?) in the comment on smp_wmb() where
swap_info[type] is set and nr_swapfiles raised, in swapon (see below).
And make a quick same-line comment on the corresponding smp_rmb()s.

Those seem more useful to me than such a comment on the
static struct swap_info_struct *swap_info[MAX_SWAPFILES];

I was about to add (now, in writing this mail) that /proc/swaps is
the only thing that reads them without swap_lock; but that's not
true, of course, swap_duplicate and swap_free (or their helpers)
make preliminary checks without swap_lock - but the difference
there is that (unless the pagetable has become corrupted) they're
dealing with a swap entry which was previously valid, so can by
this time rely upon swap_info[type] and nr_swapfiles to be safe.

> swapon_mutex() will be no help.
> 
> Whether sis is used or not can be detelcted by sis->flags.
> 
> > @@ -1675,11 +1674,13 @@ static void *swap_start(struct seq_file
> >  	if (!l)
> >  		return SEQ_START_TOKEN;
> >  
> > -	for (i = 0; i < nr_swapfiles; i++, ptr++) {
> > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > +	for (type = 0; type < nr_swapfiles; type++) {
> > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > +		si = swap_info[type];
> 
> 		if (!si) ?
> 
> > +		if (!(si->flags & SWP_USED) || !si->swap_map)
> >  			continue;
> >  		if (!--l)
> > -			return ptr;
> > +			return si;
> >  	}
...
> >  static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
> >  {
> > -	struct swap_info_struct *ptr;
> > -	struct swap_info_struct *endptr = swap_info + nr_swapfiles;
> > +	struct swap_info_struct *si = v;
> > +	int type;
> >  
> >  	if (v == SEQ_START_TOKEN)
> > -		ptr = swap_info;
> > -	else {
> > -		ptr = v;
> > -		ptr++;
> > -	}
> > +		type = 0;
> > +	else
> > +		type = si->type + 1;
> >  
> > -	for (; ptr < endptr; ptr++) {
> > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > +	for (; type < nr_swapfiles; type++) {
> > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > +		si = swap_info[type];
> > +		if (!(si->flags & SWP_USED) || !si->swap_map)
...
> > @@ -1799,23 +1800,45 @@ SYSCALL_DEFINE2(swapon, const char __use
...
> > -	if (type >= nr_swapfiles)
> > -		nr_swapfiles = type+1;
> > -	memset(p, 0, sizeof(*p));
> >  	INIT_LIST_HEAD(&p->extent_list);
> > +	if (type >= nr_swapfiles) {
> > +		p->type = type;
> > +		swap_info[type] = p;
> > +		/*
> > +		 * Write swap_info[type] before nr_swapfiles, in case a
> > +		 * racing procfs swap_start() or swap_next() is reading them.
> > +		 * (We never shrink nr_swapfiles, we never free this entry.)
> > +		 */
> > +		smp_wmb();
> > +		nr_swapfiles++;
> > +	} else {
> > +		kfree(p);
> > +		p = swap_info[type];
> > +		/*
> > +		 * Do not memset this entry: a racing procfs swap_next()
> > +		 * would be relying on p->type to remain valid.
> > +		 */
> > +	}
...
