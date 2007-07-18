Return-Path: <linux-kernel-owner+w=401wt.eu-S1764729AbXGRGyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764729AbXGRGyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXGRGyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:54:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59504 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXGRGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:54:15 -0400
Date: Wed, 18 Jul 2007 12:24:04 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, heiko.carstens@de.ibm.com,
       kiran@scalex86.org, clameter@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/10] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Message-ID: <20070718065404.GA1982@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070716134855.GA1858@APFDCB5C> <20070716135347.GD2040@APFDCB5C> <20070717082331.GA12231@in.ibm.com> <961aa3350707171018i58a47b7asb4a92e1bcd146adf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350707171018i58a47b7asb4a92e1bcd146adf@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Wed, Jul 18, 2007 at 02:18:41AM +0900, Akinobu Mita wrote:
> >> So it is natural to deliver CPU_UP_CANCELED event only to the functions
> >> that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
> >> the function that have returned NOTIFY_BAD. This is what this patch is 
> >doing.
> >
> >Yes, this makes sense.
> 
> Thank you for making sure of it.
> 
> >[...] However, it might break slab.
> >If I am not mistaken, slab code initializes multiple objects in
> >CPU_UP_PREPARE and relies on the CPU_UP_CANCELLED to destroy the
> >objects which successfully got initialized before the some object's
> >initialization went bad.
> 
> My testing machine is ordinary dual core non numa box. So it might not
> trigger the problem that you are warried about under heavy slab alloc
> failure injection.
> 
> At first glance I couln't find the problem in cpu hottplug code in slab.c 
> yet,
> but found some memory leak path. (it doesn't break slab though)

That's what I meant. I shouldn't have used the word "break" :-)
In case of slab, freeing up of resources on an error during CPU_UP_PREPARE,
is currently handled in CPU_UP_CANCELLED.

But, like you reasoned out, it makes more sense for such a subsystem
to free up all the correctly allocated resources before sending a
NOTIFY_BAD, rather than handling it in CPU_UP_CANCELLED. And slab 
needed that fix, which you've provided, before we send the notification
to (nr_calls - 1) callers.

So could you add this patch to series? 

Thanks and Regards
gautham.
> 
> Index: 2.6-git/mm/slab.c
> ===================================================================
> --- 2.6-git.orig/mm/slab.c
> +++ 2.6-git/mm/slab.c
> @@ -1221,13 +1221,18 @@ static int __cpuinit cpuup_callback(stru
> 				shared = alloc_arraycache(node,
> 					cachep->shared * cachep->batchcount,
> 					0xbaadf00d);
> -				if (!shared)
> +				if (!shared) {
> +					kfree(nc);
> 					goto bad;
> +				}
> 			}
> 			if (use_alien_caches) {
>                                 alien = alloc_alien_cache(node, 
>                                 cachep->limit);
> -                                if (!alien)
> -                                        goto bad;
> +                                if (!alien) {
> +					kfree(shared);
> +					kfree(nc);
> +					goto bad;
> +				}
>                         }
> 			cachep->array[cpu] = nc;
> 			l3 = cachep->nodelists[node];

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
