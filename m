Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZD0Kpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZD0Kpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZD0Kpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:45:36 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57587 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647AbZD0Kpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:45:35 -0400
Date: Mon, 27 Apr 2009 19:45:33 +0900 (JST)
Message-Id: <20090427.194533.183037823.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
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
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090420150052.GC13307@linux>
References: <20090417102539.GA16838@linux>
	<20090420.183815.226804723.ryov@valinux.co.jp>
	<20090420150052.GC13307@linux>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 1/9] io-throttle documentation
Date: Mon, 20 Apr 2009 17:00:53 +0200

> On Mon, Apr 20, 2009 at 06:38:15PM +0900, Ryo Tsuruta wrote:
> > Hi Andrea, 
> > 
> > > Implementing bio-cgroup functionality as pure infrastructure framework
> > > instead of a cgroup subsystem would remove all this oddity and
> > > complexity.
> > > 
> > > For example, the actual functionality that I need for the io-throttle
> > > controller is just an interface to set and get the cgroup owner of a
> > > page. I think it should be the same also for other potential users of
> > > bio-cgroup.
> > > 
> > > So, what about implementing the bio-cgroup functionality as cgroup "page
> > > tracking" infrastructure and provide the following interfaces:
> > > 
> > > /*
> > >  * Encode the cgrp->css.id in page_group->flags
> > >  */
> > > void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> > > 
> > > /*
> > >  * Returns the cgroup owner of a page, decoding the cgroup id from
> > >  * page_cgroup->flags.
> > >  */
> > > struct cgroup *get_cgroup_page_owner(struct page *page);
> > > 
> > > This also wouldn't increase the size of page_cgroup because we can
> > > encode the cgroup id in the unused bits of page_cgroup->flags, as
> > > originally suggested by Kame.
> > > 
> > > And I think it could be used also by dm-ioband, even if it's not a
> > > cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?

I've come up with an idea to coexist blkio-cgroup and io-throttle.
blkio-cgroup provides a function to get a cgroup with the specified ID.

/* Should be called under rcu_read_lock() */
struct cgroup *blkio_cgroup_lookup(int id)
{
	struct cgroup *cgrp;
	struct cgroup_subsys_state *css;
	
	if (blkio_cgroup_disabled())
		return NULL;

	css = css_lookup(&blkio_cgroup_subsys, id);
	if (!css)
		return NULL;
	cgrp = css->cgroup;
	return cgrp;
}

Then io-throttle can get a struct iothrottle which belongs to the
cgroup by using the above function.

static struct iothrottle *iothrottle_lookup(int id)
{
	struct cgroup *grp;
	struct iothrottle *iot;

	...
	grp = blkio_cgroup_lookup(id);
	if (!grp)
		return NULL
	iot = cgroup_to_iothrottle(grp);
	...
}

What do you think about this way?

Thanks,
Ryo Tsuruta
