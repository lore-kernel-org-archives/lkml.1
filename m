Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYFRVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYFRVOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYFRVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:14:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYFRVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:14:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tr9GAw+B7dvosJtnhJpGqOWsBBcPAD1f25Ootxyj5SZc0jFpAE1BGHcIfZTRfyuZL
	Ncxfh6nivaCpoibzqLtbw==
Message-ID: <6599ad830806181413y5d0ef1bfyfc54c17ee904d744@mail.gmail.com>
Date: Wed, 18 Jun 2008 14:13:58 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: support checking of subsystem dependencies
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <4858C0ED.2080905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4858C0ED.2080905@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 1:01 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> This allows one subsystem to require that it only be mounted when some
> other subsystems are also present in the proposed hierarchy.
>
> For example if subsystem foo depends on bar, the following will fail:
>  # mount -t cgroup -ofoo xxx /dev/cgroup
>
> You should mount with both subsystems:
>  # mount -t cgroup -ofoo,bar xxx /dev/cgroup
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  Documentation/cgroups.txt |    6 ++++++
>  include/linux/cgroup.h    |    2 ++
>  kernel/cgroup.c           |   30 ++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/cgroups.txt b/Documentation/cgroups.txt
> index 824fc02..8252f5b 100644
> --- a/Documentation/cgroups.txt
> +++ b/Documentation/cgroups.txt
> @@ -530,6 +530,12 @@ and root cgroup. Currently this will only involve movement between
>  the default hierarchy (which never has sub-cgroups) and a hierarchy
>  that is being created/destroyed (and hence has no sub-cgroups).
>
> +int subsys_depend(struct cgroup_subsys *ss, unsigned long subsys_bits)
> +
> +Called when a cgroup subsystem wants to check if some other subsystems
> +are also present in the proposed hierarchy. If this method returns error,
> +the mount of the cgroup filesystem will fail.
> +
>  4. Questions
>  ============
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e155aa7..fc99ba4 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -305,6 +305,8 @@ struct cgroup_subsys {
>                        struct cgroup *cgrp);
>        void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>        void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
> +       int (*subsys_depend)(struct cgroup_subsys *ss,
> +                             unsigned long subsys_bits);
>        /*
>         * This routine is called with the task_lock of mm->owner held
>         */
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 15ac0e1..a4c8671 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -837,6 +837,25 @@ static int parse_cgroupfs_options(char *data,
>        return 0;
>  }
>
> +static int check_subsys_dependency(unsigned long subsys_bits)
> +{
> +       int i;
> +       int ret;
> +       struct cgroup_subsys *ss;
> +
> +       for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +               ss = subsys[i];
> +
> +               if (test_bit(i, &subsys_bits) && ss->subsys_depend) {
> +                       ret = ss->subsys_depend(ss, subsys_bits);
> +                       if (ret)
> +                               return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>  {
>        int ret = 0;
> @@ -852,6 +871,10 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>        if (ret)
>                goto out_unlock;
>
> +       ret = check_subsys_dependency(opts.subsys_bits);
> +       if (ret)
> +               goto out_unlock;
> +

Can we just call this from one place, in parse_cgroupfs_options() ?

Paul
