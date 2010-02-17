Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab0BQApN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:45:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38310 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab0BQApK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:45:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 09:41:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
	<20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 16:31:39 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > Hmm, I have a few reason to add special behavior to memcg rather than panic.
> > 
> >  - freeze_at_oom is enough.
> >    If OOM can be notified, the management daemon can do useful jobs. Shutdown
> >    all other cgroups or migrate them to other host and do kdump.
> > 
> 
> The same could be said for cpusets if users use that for memory isolation.
> 
cpuset's difficulty is that there are some methods which share the limitation.

It's not simple that we have
  - cpuset
  - mempolicy per task
  - mempolicy per vma

Sigh..but they are for their own purpose.


> > But, Hmm...I'd like to go this way.
> > 
> >  1. At first, support panic_on_oom=2 in memcg.
> > 
> 
> This should panic in mem_cgroup_out_of_memory() and the documentation 
> should be added to Documentation/sysctl/vm.txt.
> 
> The memory controller also has some protection in the pagefault oom 
> handler that seems like it could be made more general: instead of checking 
> for mem_cgroup_oom_called(), I'd rather do a tasklist scan to check for 
> already oom killed task (checking for the TIF_MEMDIE bit) and check all 
> zones for ZONE_OOM_LOCKED.  If no oom killed tasks are found and no zones 
> are locked, we can check sysctl_panic_on_oom and invoke the system-wide 
> oom.
> 
plz remove memcg's hook after doing that. Current implemantation is desgined 
not to affect too much to other cgroups by doing unnecessary jobs.


> >  2. Second, I'll add OOM-notifier and freeze_at_oom to memcg.
> >     and don't call memcg_out_of_memory in oom_kill.c in this case. Because
> >     we don't kill anything. Taking coredumps of all procs in memcg is not
> >     very difficult.
> > 
> 
> The oom notifier would be at a higher level than the oom killer, the oom 
> killer's job is simply to kill a task when it is called. 
> So for these particular cases, you would never even call into out_of_memory() to panic 
> the machine in the first place. 

That's my point. 

Thanks,
-Kame


