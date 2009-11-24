Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbZKXO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbZKXO42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbZKXO41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:56:27 -0500
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.70]:45351 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124AbZKXO40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:56:26 -0500
X-Greylist: delayed 3292 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 09:56:26 EST
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Tue, 24 Nov 2009 23:00:29 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH -mmotm] memcg: avoid oom-killing innocent task
 in  case of use_hierarchy
Message-Id: <20091124230029.7245e1b8.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <661de9470911240531p5e587c42w96995fde37dbd401@mail.gmail.com>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<661de9470911240531p5e587c42w96995fde37dbd401@mail.gmail.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 19:01:54 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Tue, Nov 24, 2009 at 11:27 AM, Daisuke Nishimura
> <nishimura@mxp.nes.nec.co.jp> wrote:
> > task_in_mem_cgroup(), which is called by select_bad_process() to check whether
> > a task can be a candidate for being oom-killed from memcg's limit, checks
> > "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).
> >
> > But this check return true(it's false positive) when:
> >
> >        <some path>/00          use_hierarchy == 0      <- hitting limit
> >          <some path>/00/aa     use_hierarchy == 1      <- "curr"
> >
> > This leads to killing an innocent task in 00/aa. This patch is a fix for this
> > bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
> > should print information of mem_cgroup which the task being killed, not current,
> > belongs to.
> >
> 
> Quick Question: What happens if <some path>/00 has no tasks in it
> after your patches?
> 
Nothing would happen because <some path>/00 never hit its limit.

The bug that this patch fixes is:

- create a dir <some path>/00 and set some limits.
- create a sub dir <some path>/00/aa w/o any limits, and enable hierarchy.
- run some programs in both in 00 and 00/aa. programs in 00 should be
  big enough to cause oom by its limit.
- when oom happens by 00's limit, tasks in 00/aa can also be killed.


Regards,
Daisuke Nishimura.
