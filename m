Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbZFWEqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbZFWEqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZFWEp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:45:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36911 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZFWEp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:45:56 -0400
Date: Tue, 23 Jun 2009 13:44:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH] cgroup: fix permanent wait in rmdir
Message-Id: <20090623134420.9103eac5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090623131333.be387c84.nishimura@mxp.nes.nec.co.jp>
References: <20090622183707.dd9e665b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090623092223.a44e7b20.kamezawa.hiroyu@jp.fujitsu.com>
	<20090623131333.be387c84.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 13:13:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 23 Jun 2009 09:22:23 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 22 Jun 2009 18:37:07 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > previous discussion was this => http://marc.info/?t=124478543600001&r=1&w=2
> > > 
> > > I think this is a minimum fix (in code size and behavior) and because
> > > we can take a BIG LOCK, this kind of check is necessary, anyway.
> > > Any comments are welcome.
> > 
> > I'll split this into 2 patches...and I found I should check page-migration, too.
> I'll wait a new version, but can you explain in advance this page-migration case ?
> 

Not far from swap-in case.

Assume cgroup "A" which includes file caches. A task in other group mmap file caches
and do page migration and rmdir against "A" is called at the same time.

In mem_cgroup_prepare_migration(), following check is used.

==
	lock_page_cgroup(pc);
	if (PageCgroupUsed(pc)) {
		mem = pc->mem_cgroup;
		css_get(&mem->css);
	}
	unlock_page_cgroup(pc);
	<======================================(*)
	if (mem) {
		<==============================(**)
		try_charge();
		...
	}
==

At (*), we grab css refcnt which can be under pre_destroy() and
At (**), pre_destroy may returns 0 but charge may be done after the end of pre_destroy().


> > > +static int mem_cgroup_retry_rmdir(struct cgroup_subsys *ss,
> > > +				  struct cgroup *cont)
> > > +{
> > > +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> > > +
> > > +	if (res_counter_read_u64(&memcg->res, RES_USAGE))
> It should be &mem->res.
> 
yes.
too many typos in my patches in these days..

Thanks,
-Kame

