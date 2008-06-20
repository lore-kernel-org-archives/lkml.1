Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbYFTEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbYFTEwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 00:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYFTEwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 00:52:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYFTEwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 00:52:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DWbrEW+W0vrqiL+OsAa6D3jsXOaHVClOl+A7pCHVkhymKLKpbC+YBZZZ10QBdw9yg
	/T/HNf2LERWK/vOa5hQFw==
Message-ID: <6599ad830806192151wd44a468r242acb3eabe4ce7a@mail.gmail.com>
Date: Thu, 19 Jun 2008 21:51:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: support checking of subsystem dependencies (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <4859BBA8.6070808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4858C0ED.2080905@cn.fujitsu.com>
	 <6599ad830806181413y5d0ef1bfyfc54c17ee904d744@mail.gmail.com>
	 <4859BBA8.6070808@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 6:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

> ---
>  Documentation/cgroups.txt |    6 ++++++
>  include/linux/cgroup.h    |    2 ++
>  kernel/cgroup.c           |   21 ++++++++++++++++++++-
>  3 files changed, 28 insertions(+), 1 deletions(-)
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
> index 15ac0e1..18e8132 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -774,6 +774,25 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
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
>  struct cgroup_sb_opts {
>        unsigned long subsys_bits;
>        unsigned long flags;
> @@ -834,7 +853,7 @@ static int parse_cgroupfs_options(char *data,
>        if (!opts->subsys_bits)
>                return -EINVAL;
>
> -       return 0;
> +       return check_subsys_dependency(opts->subsys_bits);
>  }
>
>  static int cgroup_remount(struct super_block *sb, int *flags, char *data)
> --
> 1.5.4.rc3
>
>
