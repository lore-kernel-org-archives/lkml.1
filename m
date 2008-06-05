Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbYFEWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbYFEWE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYFEWET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:04:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYFEWES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:04:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=T++VYj+zGvOkkVaNJzvTFrXZ065bo2RIWLxSJvv4N6VEjTiVNN5ASPvbGmswQczbz
	gFq3/SviuDyiVBpm/vI9g==
Message-ID: <6599ad830806051504t52398ed1ya742f0145067ffa@mail.gmail.com>
Date: Thu, 5 Jun 2008 15:04:12 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for prevent fork bomb by cgroup)
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

The basic idea of a task-limiting subsystem is good, thanks.

On Wed, Jun 4, 2008 at 9:43 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2719,13 +2719,27 @@ static struct file_operations proc_cgrou
>  * At the point that cgroup_fork() is called, 'current' is the parent
>  * task, and the passed argument 'child' points to the child task.
>  */
> -void cgroup_fork(struct task_struct *child)
> +int cgroup_fork(struct task_struct *child)
>  {
> +       int i;
> +       int ret;
> +
> +       for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +               struct cgroup_subsys *ss = subsys[i];
> +               if (ss->can_fork) {
> +                       ret = ss->can_fork(ss, child);
> +                       if (ret)
> +                               return ret;
> +               }
> +       }
> +
>        task_lock(current);
>        child->cgroups = current->cgroups;
>        get_css_set(child->cgroups);
>        task_unlock(current);
>        INIT_LIST_HEAD(&child->cg_list);
> +
> +       return 0;
>  }

I don't think this is the right way to handle this check. This isn't a
generic control groups callback, it's one that specific for a
particular subsystem. So the right way to handle it is to call
task_cgroup_can_fork() from the same place that the RLIM_NPROC limit
is checked.

If it later turned out that multiple cgroup subsystems wanted to be
able to prevent forking, then it might make sense to have a generic
cgroup callback, but for just one subsystem it's cleaner to call
directly.

> +
> +static int task_cgroup_populate(struct cgroup_subsys *ss,
> +                               struct cgroup *cgrp)
> +{
> +       if (task_cgroup_subsys.disabled)
> +               return 0;

I don't think you should need this check - if the subsystem is
disabled, it'll never be mounted in the first place.

Paul
