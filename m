Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYKFBZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYKFBZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYKFBYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:24:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYKFBYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:24:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=De6ujjer+0xEyl0kYF4C/5g9C1EuRBSmGDuvWGRvTx5zVzTLK75yDkrfA65NIKHM8
	Pl6D2I8eZW/Aw+fwmBLSA==
MIME-Version: 1.0
In-Reply-To: <491245F1.5070707@cn.fujitsu.com>
References: <491245F1.5070707@cn.fujitsu.com>
Date: Wed, 5 Nov 2008 17:24:49 -0800
Message-ID: <6599ad830811051724p1f97026fl96be5efe38b33152@mail.gmail.com>
Subject: Re: [PATCH -v2] freezer_cg: disable writing freezer.state of root 
	cgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 5:18 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> With this change, control file 'freezer.state' doesn't exist in root
> cgroup, making root cgroup unfreezable.
>
> I think it's reasonable to disallow freeze tasks in the root cgroup.
> And then we can avoid fork overhead when freezer subsystem is
> compiled but not used.
>
> Also make writing invalid value to freezer.state returns EINVAL
> rather than EIO. This is more consistent with other cgroup subsystem.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

I might use the term "non-freezable" rather than "unfreezable".

Thanks,

Paul

> ---
>
> patch is based on freezer_cg-remove-task_lock-from-freezer_fork.patch
>
> ---
>  Documentation/cgroups/freezer-subsystem.txt |    3 +++
>  kernel/cgroup_freezer.c                     |   11 ++++++++++-
>  2 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/cgroups/freezer-subsystem.txt b/Documentation/cgroups/freezer-subsystem.txt
> index c50ab58..91572b9 100644
> --- a/Documentation/cgroups/freezer-subsystem.txt
> +++ b/Documentation/cgroups/freezer-subsystem.txt
> @@ -54,6 +54,9 @@ freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
>  cgroup. Subsequently writing "THAWED" will unfreeze the tasks in the cgroup.
>  Reading will return the current state.
>
> +Note freezer.state doesn't exist in root cgroup, which means root cgroup
> +is unfreezable.
> +
>  * Examples of usage :
>
>    # mkdir /containers/freezer
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 6605907..cf3fce9 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -192,6 +192,13 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
>         */
>        freezer = task_freezer(task);
>
> +       /*
> +        * The root cgroup is unfreezable, so we can skip the
> +        * following check.
> +        */
> +       if (!freezer->css.cgroup->parent)
> +               return;
> +
>        spin_lock_irq(&freezer->lock);
>        BUG_ON(freezer->state == CGROUP_FROZEN);
>
> @@ -335,7 +342,7 @@ static int freezer_write(struct cgroup *cgroup,
>        else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
>                goal_state = CGROUP_FROZEN;
>        else
> -               return -EIO;
> +               return -EINVAL;
>
>        if (!cgroup_lock_live_group(cgroup))
>                return -ENODEV;
> @@ -354,6 +361,8 @@ static struct cftype files[] = {
>
>  static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
>  {
> +       if (!cgroup->parent)
> +               return 0;
>        return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
>  }
>
> --
> 1.5.4.rc3
>
>
