Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0BWL6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 06:58:50 -0500
Received: from trinity.develer.com ([83.149.158.210]:56150 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0BWL6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 06:58:48 -0500
Date: Tue, 23 Feb 2010 12:58:46 +0100
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100223115846.GI1882@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-2-git-send-email-arighi@develer.com>
 <alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
 <20100221221700.GA5233@linux>
 <20100222180732.GC3096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222180732.GC3096@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 01:07:32PM -0500, Vivek Goyal wrote:
> > > > +unsigned long mem_cgroup_dirty_bytes(void)
> > > > +{
> > > > +	struct mem_cgroup *memcg;
> > > > +	unsigned long dirty_bytes;
> > > > +
> > > > +	if (mem_cgroup_disabled())
> > > > +		return vm_dirty_bytes;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	memcg = mem_cgroup_from_task(current);
> > > > +	if (memcg == NULL)
> > > > +		dirty_bytes = vm_dirty_bytes;
> > > > +	else
> > > > +		dirty_bytes = get_dirty_bytes(memcg);
> > > > +	rcu_read_unlock();
> > > 
> > > The rcu_read_lock() isn't protecting anything here.
> > 
> > Right!
> 
> Are we not protecting "memcg" pointer using rcu here?

Vivek, you are right:

 mem_cgroup_from_task() -> task_subsys_state() -> rcu_dereference()

So, this *must* be RCU protected.

Thanks!
-Andrea
