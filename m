Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZD0V67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZD0V67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760249AbZD0V5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:57:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46975 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbZD0V46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CrkKJ009zmMW6UUGzQuFaoz3gQ/r1owP1XsH2BZg1Kll70pxs8TLPUraGGoE6e3/RF
         u8XnU/1mNZ1TNSKUgRnYpaHdPcE9lcWGg0qNDPC3e7B3/IUC5ILFAzeOGayRHx+m2owm
         8qR7YSFujdUg6ceT1XlFpuudwPqeJzRtKULsI=
Date: Mon, 27 Apr 2009 23:56:52 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090427215650.GB3606@linux>
References: <20090417102539.GA16838@linux> <20090420.183815.226804723.ryov@valinux.co.jp> <20090420150052.GC13307@linux> <20090427.194533.183037823.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427.194533.183037823.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 07:45:33PM +0900, Ryo Tsuruta wrote:
> Hi Andrea,
> 
> From: Andrea Righi <righi.andrea@gmail.com>
> Subject: Re: [PATCH 1/9] io-throttle documentation
> Date: Mon, 20 Apr 2009 17:00:53 +0200
> 
> > On Mon, Apr 20, 2009 at 06:38:15PM +0900, Ryo Tsuruta wrote:
> > > Hi Andrea, 
> > > 
> > > > Implementing bio-cgroup functionality as pure infrastructure framework
> > > > instead of a cgroup subsystem would remove all this oddity and
> > > > complexity.
> > > > 
> > > > For example, the actual functionality that I need for the io-throttle
> > > > controller is just an interface to set and get the cgroup owner of a
> > > > page. I think it should be the same also for other potential users of
> > > > bio-cgroup.
> > > > 
> > > > So, what about implementing the bio-cgroup functionality as cgroup "page
> > > > tracking" infrastructure and provide the following interfaces:
> > > > 
> > > > /*
> > > >  * Encode the cgrp->css.id in page_group->flags
> > > >  */
> > > > void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> > > > 
> > > > /*
> > > >  * Returns the cgroup owner of a page, decoding the cgroup id from
> > > >  * page_cgroup->flags.
> > > >  */
> > > > struct cgroup *get_cgroup_page_owner(struct page *page);
> > > > 
> > > > This also wouldn't increase the size of page_cgroup because we can
> > > > encode the cgroup id in the unused bits of page_cgroup->flags, as
> > > > originally suggested by Kame.
> > > > 
> > > > And I think it could be used also by dm-ioband, even if it's not a
> > > > cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?
> 
> I've come up with an idea to coexist blkio-cgroup and io-throttle.
> blkio-cgroup provides a function to get a cgroup with the specified ID.
> 
> /* Should be called under rcu_read_lock() */
> struct cgroup *blkio_cgroup_lookup(int id)
> {
> 	struct cgroup *cgrp;
> 	struct cgroup_subsys_state *css;
> 	
> 	if (blkio_cgroup_disabled())
> 		return NULL;
> 
> 	css = css_lookup(&blkio_cgroup_subsys, id);
> 	if (!css)
> 		return NULL;
> 	cgrp = css->cgroup;
> 	return cgrp;
> }
> 
> Then io-throttle can get a struct iothrottle which belongs to the
> cgroup by using the above function.
> 
> static struct iothrottle *iothrottle_lookup(int id)
> {
> 	struct cgroup *grp;
> 	struct iothrottle *iot;
> 
> 	...
> 	grp = blkio_cgroup_lookup(id);
> 	if (!grp)
> 		return NULL
> 	iot = cgroup_to_iothrottle(grp);
> 	...
> }
> 
> What do you think about this way?

Hi Ryo,

this should be ok for io-throttle. But I'd still prefer to see
blkio-cgroup implemented as an infrastructure, instead of a cgroup. This
would avoid (at least for io-throttle) the need to mount io-throttle
together with blkio-cgroup or provide complicate ways to associate
io-throttle groups with blkio-cgroup groups.

Thanks,
-Andrea
