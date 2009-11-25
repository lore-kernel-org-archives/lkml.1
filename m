Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbZKYAKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbZKYAKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbZKYAKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:10:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53610 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779AbZKYAKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:10:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Nov 2009 09:07:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH -mmotm] memcg: avoid oom-killing innocent task
 in case of use_hierarchy
Message-Id: <20091125090756.690d7a68.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091124170402.GB3365@balbir.in.ibm.com>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<661de9470911240531p5e587c42w96995fde37dbd401@mail.gmail.com>
	<20091124230029.7245e1b8.d-nishimura@mtf.biglobe.ne.jp>
	<20091124170402.GB3365@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 22:34:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> [2009-11-24 23:00:29]:
> 
> > On Tue, 24 Nov 2009 19:01:54 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > On Tue, Nov 24, 2009 at 11:27 AM, Daisuke Nishimura
> > > <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > task_in_mem_cgroup(), which is called by select_bad_process() to check whether
> > > > a task can be a candidate for being oom-killed from memcg's limit, checks
> > > > "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).
> > > >
> > > > But this check return true(it's false positive) when:
> > > >
> > > >        <some path>/00          use_hierarchy == 0      <- hitting limit
> > > >          <some path>/00/aa     use_hierarchy == 1      <- "curr"
> > > >
> > > > This leads to killing an innocent task in 00/aa. This patch is a fix for this
> > > > bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
> > > > should print information of mem_cgroup which the task being killed, not current,
> > > > belongs to.
> > > >
> > > 
> > > Quick Question: What happens if <some path>/00 has no tasks in it
> > > after your patches?
> > > 
> > Nothing would happen because <some path>/00 never hit its limit.
> 
> Why not? I am talking of a scenario where <some path>/00 is set to a
> limit (similar to your example) and hits its limit, but the groups
> under it have no limits, but tasks. Shouldn't we be scanning
> <some path>/00/aa as well?
> 
No.  <some path>/00 == use_hierarchy=0 means _all_ children's accounting
information is never added up to <some path>/00.

If there is no task in <some path>/00, it means <some path>/00 contains only
file cache and not-migrated rss. To hit limit, the admin has to make 
memory.(memsw).limit_in_bytes smaller. But in this case, oom is not called.
-ENOMEM is returned to users. IIUC.




> > 
> > The bug that this patch fixes is:
> > 
> > - create a dir <some path>/00 and set some limits.
> > - create a sub dir <some path>/00/aa w/o any limits, and enable hierarchy.
> > - run some programs in both in 00 and 00/aa. programs in 00 should be
> >   big enough to cause oom by its limit.
> > - when oom happens by 00's limit, tasks in 00/aa can also be killed.
> >
> 
> To be honest, the last part is fair, specifically if 00/aa has a task
> that is really the heaviest task as per the oom logic. no? Are you
> suggesting that only tasks in <some path>/00 should be selected by the
> oom logic? 
> 
<some path>/00 and <some path>/00/aa has completely different accounting set.
There are no hierarchy relationship. The directory tree shows "virtual"
hierarchy but in reality, their relationship is horizontal rather than hierarchycal.

So, killing tasks only in <some path>/00 is better.

Thanks,
-Kame



