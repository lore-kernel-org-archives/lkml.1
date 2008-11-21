Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYKUPRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYKUPRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYKUPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:17:46 -0500
Received: from ms01.sssup.it ([193.205.80.99]:51796 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753487AbYKUPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:17:45 -0500
Date: Fri, 21 Nov 2008 16:21:22 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nauman Rafique <nauman@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Divyesh Shah <dpshah@google.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081121152122.GA969@gandalf.sssup.it>
References: <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081120213155.GI29306@redhat.com> <20081121030533.GA30883@gandalf.sssup.it> <20081121145823.GD3111@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121145823.GD3111@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Fri, Nov 21, 2008 09:58:23AM -0500
>
> On Fri, Nov 21, 2008 at 04:05:33AM +0100, Fabio Checconi wrote:
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Date: Thu, Nov 20, 2008 04:31:55PM -0500
> > >
> > ...
> > > Hi Fabio,
> > > 
> > > I though will give bfq a try.  I get following when I put my current shell
> > > into a newly created cgroup and then try to do "ls".
> > > 
> > 
> > The posted patch cannot work as it is, I'm sorry for that ugly bug.
> > Do you still have problems with this one applied?
> > 
> > ---
> > diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> > index efb03fc..ed8c597 100644
> > --- a/block/bfq-cgroup.c
> > +++ b/block/bfq-cgroup.c
> > @@ -168,7 +168,7 @@ static void bfq_group_chain_link(struct bfq_data *bfqd, struct cgroup *cgroup,
> >  
> >  		spin_lock_irqsave(&bgrp->lock, flags);
> >  
> > -		rcu_assign_pointer(bfqg->bfqd, bfqd);
> > +		rcu_assign_pointer(leaf->bfqd, bfqd);
> >  		hlist_add_head_rcu(&leaf->group_node, &bgrp->group_data);
> >  		hlist_add_head(&leaf->bfqd_node, &bfqd->group_list);
> 
> Thanks Fabio. This fix solves the issue for me.
> 

Ok thank you.


> I did a quick testing and I can see the differential service if I create
> two cgroups of different priority. How do I map ioprio to shares? I
> mean lets say one cgroup has ioprio 4 and other has got ioprio 7, then
> what's the respective share(%) of each cgroup?
> 

I thought I wrote it somewhere, but maybe I missed that; weights are
mapped linearly, in decreasing order of priority:

  weight = 8 - ioprio

[ the calculation is done in bfq_weight_t bfq_ioprio_to_weight() ]

So, with ioprio 4 you have weight 4, and with ioprio 7 you have weight 1.
The shares, as long as the two tasks/groups are active on the disk,
are 4/5 and 1/5 respectively.

This interface is really ugly, but it allows compatible uses of
ioprios with the two schedulers.
