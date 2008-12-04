Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYLDKnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYLDKnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYLDKnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:43:10 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62993 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYLDKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:43:09 -0500
Date: Thu, 4 Dec 2008 19:17:02 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: Re: [Experimental][PATCH 19/21] memcg-fix-pre-destroy.patch
Message-Id: <20081204191702.d845d79c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081204184309.da8264c0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
	<20081203141117.d3685413.kamezawa.hiroyu@jp.fujitsu.com>
	<20081204183428.19cbd22d.nishimura@mxp.nes.nec.co.jp>
	<20081204184309.da8264c0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008 18:43:09 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 4 Dec 2008 18:34:28 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > Added CC: Paul Menage <menage@google.com>
> > 
> > > @@ -2096,7 +2112,7 @@ static void mem_cgroup_get(struct mem_cg
> > >  static void mem_cgroup_put(struct mem_cgroup *mem)
> > >  {
> > >  	if (atomic_dec_and_test(&mem->refcnt)) {
> > > -		if (!mem->obsolete)
> > > +		if (!css_under_removal(&mem->css))
> > >  			return;
> > >  		mem_cgroup_free(mem);
> > >  	}
> > I don't think it's safe to check css_under_removal here w/o cgroup_lock.
> > (It's safe *NOW* just because memcg is the only user of css->refcnt.)
> > 
> 
> > As Li said before, css_under_removal doesn't necessarily mean
> > this this group has been destroyed, but mem_cgroup will be freed.
> > 
> > But adding cgroup_lock/unlock here causes another dead lock,
> > because mem_cgroup_get_next_node calls mem_cgroup_put.
> > 
> > hmm.. hierarchical reclaim code will be re-written completely by [21/21],
> > so would it be better to change patch order or to take another approach ?
> > 
> Hmm, ok.
> 
> How about this ?
> ==
> 	At initlization, mem_cgroup_create(), set memcg->refcnt to be 1.
> 
> 	At destroy(), put this refcnt by 1.
> 
> 	remove css_under_removal(&mem->css) check.
> ==
> 
would be make sence.

Thanks,
Daisuke Nishimura.
