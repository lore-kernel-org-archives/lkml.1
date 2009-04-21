Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZDUPco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZDUPco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZDUPce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:32:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53421 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDUPcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:32:33 -0400
Date: Tue, 21 Apr 2009 21:01:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>, randy.dunlap@oracle.com, axboe@kernel.dk,
       dradford@bluehost.com, akpm@linux-foundation.org, ngupta@google.com,
       fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, roberto@unbit.it,
       agk@sourceware.org, matt@bluehost.com,
       containers@lists.linux-foundation.org, menage@google.com,
       subrata@linux.vnet.ibm.com, eric.rannaud@gmail.com
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090421153137.GL19637@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090417102214.GC3896@balbir.in.ibm.com> <20090420.203540.104031006.ryov@valinux.co.jp> <20090420145658.GB13307@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090420145658.GB13307@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righi.andrea@gmail.com> [2009-04-20 16:56:59]:

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

Quick concern here, how long does it take for the data to become
consistent? Can we have a group misuse the bandwidth during that time?
What about conditions where you have a wrong ID, but the group
associated with the wrong ID is gone?

-- 
	Balbir
