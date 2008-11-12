Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbYKLEXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbYKLEXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYKLEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:23:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48031 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKLEW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:22:59 -0500
Date: Wed, 12 Nov 2008 13:22:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 4/6] memcg: swap cgroup for remembering account
Message-Id: <20081112132219.20510b57.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112131701.dbb7d003.d-nishimura@mtf.biglobe.ne.jp>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122949.d17bbc7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112131701.dbb7d003.d-nishimura@mtf.biglobe.ne.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 13:17:01 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> > +/**
> > + * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
> > + * @ent: swap entry to be looked up.
> > + *
> > + * Returns pointer to mem_cgroup at success. NULL at failure.
> > + */
> > +struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
> > +{
> > +	int type = swp_type(ent);
> > +	unsigned long flags;
> > +	unsigned long offset = swp_offset(ent);
> > +	unsigned long idx = offset / SC_PER_PAGE;
> > +	unsigned long pos = offset & SC_POS_MASK;
> > +	struct swap_cgroup_ctrl *ctrl;
> > +	struct page *mappage;
> > +	struct swap_cgroup *sc;
> > +	struct mem_cgroup *ret;
> > +
> > +	if (!do_swap_account)
> > +		return NULL;
> > +
> > +	ctrl = &swap_cgroup_ctrl[type];
> > +
> > +	mappage = ctrl->map[idx];
> > +
> > +	spin_lock_irqsave(&ctrl->lock, flags);
> > +	sc = kmap_atomic(mappage, KM_USER0);
> > +	sc += pos;
> > +	ret = sc->val;
> > +	kunmap_atomic(mapppage, KM_USER0);
> s/mapppage/mappage
> 
> I don't know why I didn't notice this while testing previous version.
> 
Ah...kmap_atomic() doesn't check its argument if HIGHMEM=n.
and mapppage disappears by macro.

I'm now preparing x86-32 test enviroment before goint further.

Thanks,
-Kame

> 
> Thanks,
> Daisuke Nishimura.
> 
> > +	spin_unlock_irqrestore(&ctrl->lock, flags);
> > +	return ret;
> > +}
> > +
> 

