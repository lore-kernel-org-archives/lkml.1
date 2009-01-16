Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZAPHvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZAPHvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZAPHu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:50:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37071 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZAPHuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:50:55 -0500
Date: Fri, 16 Jan 2009 16:49:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 3/4] memcg: hierarchical reclaim by CSS ID
Message-Id: <20090116164947.0c3cb725.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <497038CD.8010505@cn.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115192943.7c1df53a.kamezawa.hiroyu@jp.fujitsu.com>
	<496FE30C.1090300@cn.fujitsu.com>
	<20090116103810.5ef55cc3.kamezawa.hiroyu@jp.fujitsu.com>
	<496FE791.9030208@cn.fujitsu.com>
	<20090116112211.ea4231aa.kamezawa.hiroyu@jp.fujitsu.com>
	<497038CD.8010505@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 15:35:41 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >>>>> +	while (!ret) {
> >>>>> +		rcu_read_lock();
> >>>>> +		nextid = root_mem->last_scanned_child + 1;
> >>>>> +		css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
> >>>>> +				   &found);
> >>>>> +		if (css && css_is_populated(css) && css_tryget(css))
> >>>> I don't see why you need to check css_is_populated(css) ?
> >>>>
> >>> Main reason is for sanity. I don't like to hold css->refcnt of not populated css.
> >> I think this is a rare case. It's just a very short period when a cgroup is
> >> being created but not yet fully created.
> >>
> >>> Second reason is for avoinding unnecessary calls to try_to_free_pages(),
> >>> it's heavy. I should also add mem->res.usage == 0 case for skipping but not yet.
> >>>
> >> And if mem->res.usage == 0 is checked, css_is_popuated() is just redundant.
> >>
> > Hmm ? Can I check mem->res.usage before css_tryget() ?
> > 
> 
> I think you can. If css != NULL, css is valid (otherwise how can we access css->flags
> in css_tryget), so mem is valid. Correct me if I'm wrong. :)
> 
Ok, I'll remove css_is_populated(). (I alread removed it in my local set.)

BTW, because we can access cgroup outside of cgroup_lock via CSS ID scanning,
I want some way to confirm this cgroup is worth to be looked into or not.

*And* I think it's better to mark cgroup as NOT VALID in which initialization is
not complete.
And it's better to notify user that "you should rmdir this incomplete cgroup"
when populate() finally fails. Do you have  idea ?

-Kame

