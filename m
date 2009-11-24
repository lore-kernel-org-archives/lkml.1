Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbZKXX4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbZKXX4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934452AbZKXX4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:56:33 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54502 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbZKXX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:56:32 -0500
Date: Wed, 25 Nov 2009 08:49:10 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH -mmotm] memcg: avoid oom-killing innocent task
 in case of use_hierarchy
Message-Id: <20091125084910.16d9095d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091124170402.GB3365@balbir.in.ibm.com>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<661de9470911240531p5e587c42w96995fde37dbd401@mail.gmail.com>
	<20091124230029.7245e1b8.d-nishimura@mtf.biglobe.ne.jp>
	<20091124170402.GB3365@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 22:34:02 +0530, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
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
All of your comments would be rational if hierarchy is enabled in 00(it's
also enabled in 00/aa automatically in this case).
I'm saying about the case where it's disabled in 00 but enabled in 00/aa.

In this scenario, charges by tasks in 00/aa is(and should not be) charged to 00.
And oom caused by 00's limit should not affect the task in 00/aa.


Regards,
Daisuke Nishimura.
