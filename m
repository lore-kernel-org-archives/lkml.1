Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbZJOXt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbZJOXt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935626AbZJOXt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:49:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59044 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935608AbZJOXt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:49:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 08:46:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] swap_info: change to array of pointers
Message-Id: <20091016084621.7199411d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910152324220.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150146210.3291@sister.anvils>
	<20091015111107.b505b676.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910152324220.4447@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 23:41:19 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > On Thu, 15 Oct 2009 01:48:01 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > > --- si1/mm/swapfile.c	2009-10-14 21:25:58.000000000 +0100
> > > +++ si2/mm/swapfile.c	2009-10-14 21:26:09.000000000 +0100
> > > @@ -49,7 +49,7 @@ static const char Unused_offset[] = "Unu
> > >  
> > >  static struct swap_list_t swap_list = {-1, -1};
> > >  
> > > -static struct swap_info_struct swap_info[MAX_SWAPFILES];
> > > +static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> > >  
> > 
> > Could you add some comment like this ?
> > ==
> > nr_swapfile is never decreased.
> > swap_info[type] pointer will never be invalid if it turns to be valid once.
> > 
> > 
> > for (i = 0; i < nr_swapfiles; i++) {
> > 	smp_rmp();
> > 	sis = swap_info[type];
> > 	....
> > } 
> > Then, we can execute above without checking sis is valid or not.
> > smp_rmb() is required when we do above loop without swap_lock().
> 
> I do describe this (too briefly?) in the comment on smp_wmb() where
> swap_info[type] is set and nr_swapfiles raised, in swapon (see below).
> And make a quick same-line comment on the corresponding smp_rmb()s.
> 
> Those seem more useful to me than such a comment on the
> static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> 
yes.



> I was about to add (now, in writing this mail) that /proc/swaps is
> the only thing that reads them without swap_lock; but that's not
> true, of course, swap_duplicate and swap_free (or their helpers)
> make preliminary checks without swap_lock - but the difference
> there is that (unless the pagetable has become corrupted) they're
> dealing with a swap entry which was previously valid, so can by
> this time rely upon swap_info[type] and nr_swapfiles to be safe.
> 
Ah, a fact which confusing me very much at frist look was
  
  - nr_swapfiles nerver decreases
  - then, swap_info[type] will be never freed once allocated

I hope this should be commented upon this.

static struct swap_info_struct *swap_info[MAX_SWAPFILES];

Regards,
-Kame

> > swapon_mutex() will be no help.
> > 
> > Whether sis is used or not can be detelcted by sis->flags.
> > 
> > > @@ -1675,11 +1674,13 @@ static void *swap_start(struct seq_file
> > >  	if (!l)
> > >  		return SEQ_START_TOKEN;
> > >  
> > > -	for (i = 0; i < nr_swapfiles; i++, ptr++) {
> > > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > > +	for (type = 0; type < nr_swapfiles; type++) {
> > > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > > +		si = swap_info[type];
> > 
> > 		if (!si) ?
> > 
> > > +		if (!(si->flags & SWP_USED) || !si->swap_map)
> > >  			continue;
> > >  		if (!--l)
> > > -			return ptr;
> > > +			return si;
> > >  	}
> ...
> > >  static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
> > >  {
> > > -	struct swap_info_struct *ptr;
> > > -	struct swap_info_struct *endptr = swap_info + nr_swapfiles;
> > > +	struct swap_info_struct *si = v;
> > > +	int type;
> > >  
> > >  	if (v == SEQ_START_TOKEN)
> > > -		ptr = swap_info;
> > > -	else {
> > > -		ptr = v;
> > > -		ptr++;
> > > -	}
> > > +		type = 0;
> > > +	else
> > > +		type = si->type + 1;
> > >  
> > > -	for (; ptr < endptr; ptr++) {
> > > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > > +	for (; type < nr_swapfiles; type++) {
> > > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > > +		si = swap_info[type];
> > > +		if (!(si->flags & SWP_USED) || !si->swap_map)
> ...
> > > @@ -1799,23 +1800,45 @@ SYSCALL_DEFINE2(swapon, const char __use
> ...
> > > -	if (type >= nr_swapfiles)
> > > -		nr_swapfiles = type+1;
> > > -	memset(p, 0, sizeof(*p));
> > >  	INIT_LIST_HEAD(&p->extent_list);
> > > +	if (type >= nr_swapfiles) {
> > > +		p->type = type;
> > > +		swap_info[type] = p;
> > > +		/*
> > > +		 * Write swap_info[type] before nr_swapfiles, in case a
> > > +		 * racing procfs swap_start() or swap_next() is reading them.
> > > +		 * (We never shrink nr_swapfiles, we never free this entry.)
> > > +		 */
> > > +		smp_wmb();
> > > +		nr_swapfiles++;
> > > +	} else {
> > > +		kfree(p);
> > > +		p = swap_info[type];
> > > +		/*
> > > +		 * Do not memset this entry: a racing procfs swap_next()
> > > +		 * would be relying on p->type to remain valid.
> > > +		 */
> > > +	}
> ...
> 

