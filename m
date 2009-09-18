Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZIRHSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZIRHSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZIRHSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:18:00 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:52118 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbZIRHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:18:00 -0400
X-Trace: 259494929/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.69.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.69.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAMrQskpQKUVD/2dsb2JhbACBUtJshBwF
X-IronPort-AV: E=Sophos;i="4.44,408,1249254000"; 
   d="scan'208";a="259494929"
Date: Fri, 18 Sep 2009 08:17:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
In-Reply-To: <1253256805.4959.8.camel@penberg-laptop>
Message-ID: <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org> 
 <1253227412-24342-3-git-send-email-ngupta@vflare.org> <1253256805.4959.8.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Pekka Enberg wrote:
> On Fri, 2009-09-18 at 04:13 +0530, Nitin Gupta wrote:
> > +EXPORT_SYMBOL_GPL(set_swap_free_notify);
> > +
> >  static int swap_entry_free(struct swap_info_struct *p,
> >  			   swp_entry_t ent, int cache)
> >  {
> > @@ -585,6 +617,8 @@ static int swap_entry_free(struct swap_info_struct *p,
> >  			swap_list.next = p - swap_info;
> >  		nr_swap_pages++;
> >  		p->inuse_pages--;
> > +		if (p->swap_free_notify_fn)
> > +			p->swap_free_notify_fn(p->bdev, offset);
> >  	}
> >  	if (!swap_count(count))
> >  		mem_cgroup_uncharge_swap(ent);
> 
> OK, this hits core kernel code so we need to CC some more mm/swapfile.c
> people. The set_swap_free_notify() API looks strange to me. Hugh, I
> think you mentioned that you're okay with an explicit hook. Any
> suggestions how to do this cleanly?

No, no better suggestion.  I quite see Nitin's point that ramzswap
would benefit significantly from a callback here, though it's not a
place (holding swap_lock) where we'd like to offer a callback at all.

I think I would prefer the naming to make it absolutely clear that
it's a special for ramzswap or compcache, rather than dressing it
up in the grand generality of a swap_free_notify_fn: giving our
hacks fancy names doesn't really make them better.

(Does the bdev matching work out if there are any regular swapfiles
around? I've not checked, might or might not need refinement there.)

Hugh
