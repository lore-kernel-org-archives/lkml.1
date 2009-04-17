Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZDQAQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZDQAQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZDQAQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:16:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54689 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbZDQAQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:16:31 -0400
Date: Fri, 17 Apr 2009 09:14:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v2)
Message-Id: <20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090416120316.GG7082@balbir.in.ibm.com>
References: <20090415120510.GX7082@balbir.in.ibm.com>
	<20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416015955.GB7082@balbir.in.ibm.com>
	<20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416171535.cfc4ca84.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416120316.GG7082@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 17:33:16 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-16 17:15:35]:
> 
> > 
> > > Sorry, some troubles found. Ignore above Ack. 3points now.
> > > 
> > > 1. get_cpu should be after (*)
> > > ==mem_cgroup_update_mapped_file_stat()
> > > +	int cpu = get_cpu();
> > > +
> > > +	if (!page_is_file_cache(page))
> > > +		return;
> > > +
> > > +	if (unlikely(!mm))
> > > +		mm = &init_mm;
> > > +
> > > +	mem = try_get_mem_cgroup_from_mm(mm);
> > > +	if (!mem)
> > > +		return;
> > > + ----------------------------------------(*)
> > > +	stat = &mem->stat;
> > > +	cpustat = &stat->cpustat[cpu];
> > > +
> > > +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
> > > +	put_cpu();
> > > +}
> > > ==
> 
> Yes or I should have a goto
> 
> > > 
> > > 2. In above, "mem" shouldn't be got from "mm"....please get "mem" from page_cgroup.
> > > (Because it's file cache, pc->mem_cgroup is not NULL always.)
> 
> Hmmm.. not sure I understand this part. Are you suggesting that mm can
> be NULL?
No.

> I added the check for !mm as a safety check. Since this
> routine is only called from rmap context, mm is not NULL, hence mem
> should not be NULL. Did you find a race between mm->owner assignment
> and lookup via mm->owner?
> 
No.

page_cgroup->mem_cgroup != try_get_mem_cgroup_from_mm(mm);  in many many cases.

For example, libc and /bin/*** is tend to be loaded into default cgroup at boot but
used by many cgroups. But mapcount of page caches for /bin/*** is 0 if not running.

Then, File_Mapped can be greater than Cached easily if you use mm->owner.

I can't estimate RSS in *my* cgroup if File_Mapped includes pages which is under 
other cgroups. It's meaningless.
Especially, when Cached==0 but File_Mapped > 0, I think "oh, the kernel leaks somehing..hmm..."

By useing page_cgroup->mem_cgroup, we can avoid above mess.

Thanks,
-Kame 









