Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFAFOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFAFOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZFAFNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:13:52 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49263 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZFAFNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:13:52 -0400
Date: Mon, 1 Jun 2009 14:01:02 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Low overhead patches for the memory cgroup controller
 (v2)
Message-Id: <20090601140102.c55bdf03.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090601132505.2fe9c870.nishimura@mxp.nes.nec.co.jp>
References: <b7dd123f0a15fff62150bc560747d7f0.squirrel@webmail-b.css.fujitsu.com>
	<20090517041543.GA5156@balbir.in.ibm.com>
	<20090601132505.2fe9c870.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1114,9 +1125,24 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
> >  		css_put(&mem->css);
> >  		return;
> >  	}
> > +
> >  	pc->mem_cgroup = mem;
> >  	smp_wmb();
> > -	pc->flags = pcg_default_flags[ctype];
> > +	switch (ctype) {
> > +	case MEM_CGROUP_CHARGE_TYPE_CACHE:
> > +	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
> > +		SetPageCgroupCache(pc);
> > +		SetPageCgroupUsed(pc);
> > +		break;
> > +	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> > +		SetPageCgroupUsed(pc);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	if (mem == root_mem_cgroup)
> > +		SetPageCgroupRoot(pc);
> >  
> >  	mem_cgroup_charge_statistics(mem, pc, true);
> >  
> Shouldn't we set PCG_LOCK ?
> unlock_page_cgroup() will be called after this.
> 
Ah, lock_page_cgroup() has already set it.
please ignore this comment.

Sorry for noise.

Daisuke Nishimura.

