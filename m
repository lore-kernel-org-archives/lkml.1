Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYLJCYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYLJCYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYLJCYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:24:45 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60116 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYLJCYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:24:44 -0500
Date: Wed, 10 Dec 2008 11:23:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
Message-Id: <20081210112348.3060f1d8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <493F2737.9060901@cn.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	<493F2737.9060901@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 10:19:35 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > +static bool memcg_is_obsolete(struct mem_cgroup *mem)
> > +{
> 
> Will this function be called with mem->css.refcnt == 0? If yes, then
> this function is racy.
> 
> cg = mem->css.cgroup
> 				cgroup_diput()
> 				  mem_cgroup_destroy()
> 				    mem->css.cgroup = NULL;
> 				  kfree(cg);
> if (!cg || cgroup_is_removed(cg)...)
> 
> (accessing invalid cg)
> 
Hmm.  then we have to add flag to css itself, anyway.


> > +	struct cgroup *cg = mem->css.cgroup;
> > +	/*
> > +	 * "Being Removed" means pre_destroy() handler is called.
> > +	 * After  "pre_destroy" handler is called, memcg should not
> > +	 * have any additional charges.
> > +	 * This means there are small races for mis-accounting. But this
> > +	 * mis-accounting should happen only under swap-in opration.
> > +	 * (Attachin new task will fail if cgroup is under rmdir()).
> > +	 */
> > +
> > +	if (!cg || cgroup_is_removed(cg) || cgroup_is_being_removed(cg))
> > +		return true;
> > +	return false;
> > +}
> > +
> 
> ...
> 
> >  static void mem_cgroup_destroy(struct cgroup_subsys *ss,
> >  				struct cgroup *cont)
> >  {
> > -	mem_cgroup_free(mem_cgroup_from_cont(cont));
> > +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont):
> > +	mem_cgroup_free(mem);
> > +	/* forget */
> > +	mem->css.cgroup = NULL;
> 
> mem might already be destroyed by mem_cgroup_free(mem).
> 
Ah, maybe. will fix.

Thanks,
-Kame

