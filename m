Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbYFGGrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbYFGGrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYFGGq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:46:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49948 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYFGGq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:46:57 -0400
Date: Sat, 07 Jun 2008 15:46:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for prevent fork bomb by cgroup)
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <6599ad830806051504t52398ed1ya742f0145067ffa@mail.gmail.com>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com> <6599ad830806051504t52398ed1ya742f0145067ffa@mail.gmail.com>
Message-Id: <20080607154449.9C64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi Kosaki,
> 
> The basic idea of a task-limiting subsystem is good, thanks.

Thanks.


> > -void cgroup_fork(struct task_struct *child)
> > +int cgroup_fork(struct task_struct *child)
> >  {
> > +       int i;
> > +       int ret;
> > +
> > +       for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> > +               struct cgroup_subsys *ss = subsys[i];
> > +               if (ss->can_fork) {
> > +                       ret = ss->can_fork(ss, child);
> > +                       if (ret)
> > +                               return ret;
> > +               }
> > +       }
> > +
> >        task_lock(current);
> >        child->cgroups = current->cgroups;
> >        get_css_set(child->cgroups);
> >        task_unlock(current);
> >        INIT_LIST_HEAD(&child->cg_list);
> > +
> > +       return 0;
> >  }
> 
> I don't think this is the right way to handle this check. This isn't a
> generic control groups callback, it's one that specific for a
> particular subsystem. So the right way to handle it is to call
> task_cgroup_can_fork() from the same place that the RLIM_NPROC limit
> is checked.
> 
> If it later turned out that multiple cgroup subsystems wanted to be
> able to prevent forking, then it might make sense to have a generic
> cgroup callback, but for just one subsystem it's cleaner to call
> directly.

OK.


> > +static int task_cgroup_populate(struct cgroup_subsys *ss,
> > +                               struct cgroup *cgrp)
> > +{
> > +       if (task_cgroup_subsys.disabled)
> > +               return 0;
> 
> I don't think you should need this check - if the subsystem is
> disabled, it'll never be mounted in the first place.

to be honest, I did copy&past it from memcontrol.c ;)
Thanks good opinion.


