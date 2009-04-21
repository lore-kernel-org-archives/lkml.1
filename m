Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZDULja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZDULja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZDULjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:39:19 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52448 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbZDULjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:39:18 -0400
Date: Tue, 21 Apr 2009 20:39:17 +0900 (JST)
Message-Id: <20090421.203917.189725396.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: balbir@linux.vnet.ibm.com, randy.dunlap@oracle.com, axboe@kernel.dk,
       dradford@bluehost.com, akpm@linux-foundation.org, ngupta@google.com,
       fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, roberto@unbit.it,
       agk@sourceware.org, matt@bluehost.com,
       containers@lists.linux-foundation.org, menage@google.com,
       subrata@linux.vnet.ibm.com, eric.rannaud@gmail.com
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090420145658.GB13307@linux>
References: <20090417102214.GC3896@balbir.in.ibm.com>
	<20090420.203540.104031006.ryov@valinux.co.jp>
	<20090420145658.GB13307@linux>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

> On Mon, Apr 20, 2009 at 08:35:40PM +0900, Ryo Tsuruta wrote:
> > > > +/*
> > > > + * Assign "page" the same owner as "opage."
> > > > + */
> > > > +void bio_cgroup_copy_owner(struct page *npage, struct page *opage)
> > > > +{
> > > > +	struct page_cgroup *npc, *opc;
> > > > +
> > > > +	if (bio_cgroup_disabled())
> > > > +		return;
> > > > +	npc = lookup_page_cgroup(npage);
> > > > +	if (unlikely(!npc))
> > > > +		return;
> > > > +	opc = lookup_page_cgroup(opage);
> > > > +	if (unlikely(!opc))
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 * Do this without any locks. The reason is the same as
> > > > +	 * bio_cgroup_reset_owner().
> > > > +	 */
> > > > +	npc->bio_cgroup_id = opc->bio_cgroup_id;
> > > 
> > > What protects npc and opc?
> > 
> > As the same reason mentioned above, bio_cgroup_id can be updated
> > without any locks, and npc and opc always point to page_cgroups.
> > An integer variable can be set a new value at once on a system which
> > can use RCU lock.
> 
> mmmh... I'm not sure about this. Actually you read opc->bio_cgroup_id
> first and then write to npc->bio_cgroup_id, so it is not atomic at all.
> So, you can read or set a wrong ID, but at least it should be always
> consistent (the single read or write itself is atomic).

Even if opc->bio_cgroup_id is changed before copying to
npc->bio_cgroup_id, npc->bio_cgroup_id is correctly updated at some time.
The implementation is not completely accurate, but is faster and lighter.

Thanks,
Ryo Tsuruta
