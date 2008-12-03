Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYLCDzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYLCDzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYLCDzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:55:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45801 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYLCDzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:55:33 -0500
Date: Wed, 3 Dec 2008 12:54:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cgroup: fix pre_destroy and semantics of
 css->refcnt
Message-Id: <20081203125440.482279ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <493600A4.6040802@cn.fujitsu.com>
References: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>
	<20081201150208.6b24506b.kamezawa.hiroyu@jp.fujitsu.com>
	<493600A4.6040802@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 11:44:36 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > +/*
> > + * Try to set all subsys's refcnt to be 0.
> > + * css->refcnt==0 means this subsys will be destroy()'d.
> > + */
> > +static bool cgroup_set_subsys_removed(struct cgroup *cgrp)
> > +{
> > +	struct cgroup_subsys *ss;
> > +	struct cgroup_subsys_state *css, *tmp;
> > +
> > +	for_each_subsys(cgrp->root, ss) {
> > +		css = cgrp->subsys[ss->subsys_id];
> > +		if (!atomic_dec_and_test(&css->refcnt))
> > +			goto rollback;
> > +	}
> > +	return true;
> > +rollback:
> > +	for_each_subsys(cgrp->root, ss) {
> > +		tmp = cgrp->subsys[ss->subsys_id];
> > +		atomic_inc(&tmp->refcnt);
> > +		if (tmp == css)
> > +			break;
> > +	}
> > +	return false;
> > +}
> > +
> 
> This function may return false, then causes rmdir() fail. So css_tryget(subsys1)
> returns 0 doesn't necessarily mean subsys1->destroy() will be called,
> if subsys2's css's refcnt is >1 when cgroup_set_subsys_removed() is called.
> 
> Will this bring up bugs and problems?
> 

current user of css_get() is only memcg, so no problem now.

"css_tryget() fails" means "rmdir" is called against this cgroup. So, not so
troublesome in genral, I think. (the user will retry rmdir()).

To be honest, I don't want to return -EBUSY but wait for success in the kernel.
and go back to pre_destroy() for this temporal race.

Thanks,
-Kame





