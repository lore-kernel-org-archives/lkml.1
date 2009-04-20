Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZDTO5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZDTO5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZDTO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:57:07 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:41663 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZDTO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=YNRRPChEvWo/mLgIw6YRmoEoi750n2Yxd1xsjP6etfTjc6VkT0pbJOF60XGkRz53Pr
         g0ZATiuODGGv/lj7/y2GSvWJI2Njr5vI4s7fvFkm4/Hpv5E0XNa1Ge4jMUDpPR4dVTOR
         x0wXFBaTaFp5dWtL5FxOeEYvWIYU95a2J+j+s=
Date: Mon, 20 Apr 2009 16:56:59 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: balbir@linux.vnet.ibm.com, randy.dunlap@oracle.com, axboe@kernel.dk,
       dradford@bluehost.com, akpm@linux-foundation.org, ngupta@google.com,
       fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, roberto@unbit.it,
       agk@sourceware.org, matt@bluehost.com,
       containers@lists.linux-foundation.org, menage@google.com,
       subrata@linux.vnet.ibm.com, eric.rannaud@gmail.com
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090420145658.GB13307@linux>
Mail-Followup-To: Ryo Tsuruta <ryov@valinux.co.jp>,
	balbir@linux.vnet.ibm.com, randy.dunlap@oracle.com, axboe@kernel.dk,
	dradford@bluehost.com, akpm@linux-foundation.org, ngupta@google.com,
	fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
	chlunde@ping.uio.no, dave@linux.vnet.ibm.com, roberto@unbit.it,
	agk@sourceware.org, matt@bluehost.com,
	containers@lists.linux-foundation.org, menage@google.com,
	subrata@linux.vnet.ibm.com, eric.rannaud@gmail.com
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090417102214.GC3896@balbir.in.ibm.com> <20090420.203540.104031006.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420.203540.104031006.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 08:35:40PM +0900, Ryo Tsuruta wrote:
> > > +/*
> > > + * Assign "page" the same owner as "opage."
> > > + */
> > > +void bio_cgroup_copy_owner(struct page *npage, struct page *opage)
> > > +{
> > > +	struct page_cgroup *npc, *opc;
> > > +
> > > +	if (bio_cgroup_disabled())
> > > +		return;
> > > +	npc = lookup_page_cgroup(npage);
> > > +	if (unlikely(!npc))
> > > +		return;
> > > +	opc = lookup_page_cgroup(opage);
> > > +	if (unlikely(!opc))
> > > +		return;
> > > +
> > > +	/*
> > > +	 * Do this without any locks. The reason is the same as
> > > +	 * bio_cgroup_reset_owner().
> > > +	 */
> > > +	npc->bio_cgroup_id = opc->bio_cgroup_id;
> > 
> > What protects npc and opc?
> 
> As the same reason mentioned above, bio_cgroup_id can be updated
> without any locks, and npc and opc always point to page_cgroups.
> An integer variable can be set a new value at once on a system which
> can use RCU lock.

mmmh... I'm not sure about this. Actually you read opc->bio_cgroup_id
first and then write to npc->bio_cgroup_id, so it is not atomic at all.
So, you can read or set a wrong ID, but at least it should be always
consistent (the single read or write itself is atomic).

-Andrea
