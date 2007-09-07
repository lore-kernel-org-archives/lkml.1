Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXIGOZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXIGOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965357AbXIGOZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:25:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45137 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965384AbXIGOZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:25:44 -0400
Date: Fri, 7 Sep 2007 07:25:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, satyam@infradead.org,
       flo@rfc822.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
       flamingice@sourmilk.net
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
Message-ID: <20070907142538.GC8864@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au> <1189085815.28781.78.camel@johannes.berg> <20070906154612.GD8030@linux.vnet.ibm.com> <1189171635.28781.134.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189171635.28781.134.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 03:27:15PM +0200, Johannes Berg wrote:
> On Thu, 2007-09-06 at 08:46 -0700, Paul E. McKenney wrote:
> 
> > Looks good to me from an RCU viewpoint.  I cannot claim familiarity with
> > this code.  I therefore especially like the indications of where RTNL
> > is held and not!!!
> 
> :)
> 
> > Some questions below based on a quick scan.  And a global question:
> > should the comments about RTNL being held be replaced by ASSERT_RTNL()?
> 
> I don't like ASSERT_RTNL() much because it actually tries to lock it.
> I'd be much happer if it was WARN_ON(!mutex_locked(&rtnl_mutex)) or
> something equivalent.

Ah!  It would indeed be nice to have a lower-overhead ASSERT_RTNL_LIGHT()
or whatever.

> In any case, I have an updated patch I'll be sending soon, and it
> requires a new list walking primitive I'll also send.

Look forward to seeing it!

> > > -	write_lock_bh(&local->sub_if_lock);
> > > +	/* we're under RTNL so all this is fine */
> > >  	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
> > > -		write_unlock_bh(&local->sub_if_lock);
> > >  		__ieee80211_if_del(local, sdata);
> > >  		return -ENODEV;
> > >  	}
> > > -	list_add(&sdata->list, &local->sub_if_list);
> > > +	list_add_tail_rcu(&sdata->list, &local->interfaces);
> > 
> > The _rcu is required because this list isn't protected by RTNL?
> 
> Yes, not all walkers of the list are protected by the RTNL.

K.

> > > @@ -226,22 +225,22 @@ void ieee80211_if_reinit(struct net_devi
> > >  		/* Remove all virtual interfaces that use this BSS
> > >  		 * as their sdata->bss */
> > >  		struct ieee80211_sub_if_data *tsdata, *n;
> > > -		LIST_HEAD(tmp_list);
> > > 
> > > -		write_lock_bh(&local->sub_if_lock);
> > 
> > This code is also protected by RTNL?
> 
> Yes.

Comment?  (Or is it in the function header?)

> > >  	ASSERT_RTNL();
> > 
> > I -like- this!!!  ;-)
> 
> :)

							Thanx, Paul
