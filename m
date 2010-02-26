Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763Ab0BZA1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:27:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672Ab0BZA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:27:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 09:23:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Righi <arighi@develer.com>, Vivek Goyal <vgoyal@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting 
 infrastructure
Message-Id: <20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-2-git-send-email-arighi@develer.com>
	<alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
	<20100221221700.GA5233@linux>
	<20100222180732.GC3096@redhat.com>
	<20100223115846.GI1882@linux>
	<28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 00:36:15 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi
> 
> On Tue, Feb 23, 2010 at 8:58 PM, Andrea Righi <arighi@develer.com> wrote:
> > On Mon, Feb 22, 2010 at 01:07:32PM -0500, Vivek Goyal wrote:
> >> > > > +unsigned long mem_cgroup_dirty_bytes(void)
> >> > > > +{
> >> > > > +       struct mem_cgroup *memcg;
> >> > > > +       unsigned long dirty_bytes;
> >> > > > +
> >> > > > +       if (mem_cgroup_disabled())
> >> > > > +               return vm_dirty_bytes;
> >> > > > +
> >> > > > +       rcu_read_lock();
> >> > > > +       memcg = mem_cgroup_from_task(current);
> >> > > > +       if (memcg == NULL)
> >> > > > +               dirty_bytes = vm_dirty_bytes;
> >> > > > +       else
> >> > > > +               dirty_bytes = get_dirty_bytes(memcg);
> >> > > > +       rcu_read_unlock();
> >> > >
> >> > > The rcu_read_lock() isn't protecting anything here.
> >> >
> >> > Right!
> >>
> >> Are we not protecting "memcg" pointer using rcu here?
> >
> > Vivek, you are right:
> >
> >  mem_cgroup_from_task() -> task_subsys_state() -> rcu_dereference()
> >
> > So, this *must* be RCU protected.
> 
> So, Doesn't mem_cgroup_from_task in mem_cgroup_can_attach need RCU, too?
> 
Hm ? I don't read the whole thread but can_attach() is called under
cgroup_mutex(). So, it doesn't need to use RCU.

Thanks,
-Kame


