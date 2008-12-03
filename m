Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYLCDo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYLCDo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLCDoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:44:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYLCDoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:44:20 -0500
Message-ID: <493600A4.6040802@cn.fujitsu.com>
Date: Wed, 03 Dec 2008 11:44:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cgroup: fix pre_destroy and semantics of css->refcnt
References: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com> <20081201150208.6b24506b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201150208.6b24506b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Try to set all subsys's refcnt to be 0.
> + * css->refcnt==0 means this subsys will be destroy()'d.
> + */
> +static bool cgroup_set_subsys_removed(struct cgroup *cgrp)
> +{
> +	struct cgroup_subsys *ss;
> +	struct cgroup_subsys_state *css, *tmp;
> +
> +	for_each_subsys(cgrp->root, ss) {
> +		css = cgrp->subsys[ss->subsys_id];
> +		if (!atomic_dec_and_test(&css->refcnt))
> +			goto rollback;
> +	}
> +	return true;
> +rollback:
> +	for_each_subsys(cgrp->root, ss) {
> +		tmp = cgrp->subsys[ss->subsys_id];
> +		atomic_inc(&tmp->refcnt);
> +		if (tmp == css)
> +			break;
> +	}
> +	return false;
> +}
> +

This function may return false, then causes rmdir() fail. So css_tryget(subsys1)
returns 0 doesn't necessarily mean subsys1->destroy() will be called,
if subsys2's css's refcnt is >1 when cgroup_set_subsys_removed() is called.

Will this bring up bugs and problems?

