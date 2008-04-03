Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYDCRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYDCRlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDCRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:41:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbYDCRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:41:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mjN76lTx2lN4gR3Nvn3k8bi0acuX/vgAVKjut7fyjcGu72NZRXcQT7zKxFnVxojQa
	m9LP1wiJ/D3hhSE651jTw==
Message-ID: <6599ad830804031041i229f14d5s8cbc1b77e1020c18@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:41:00 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -mm 2/3] cgroup: simplify init_subsys()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47F470BF.3060905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F470BF.3060905@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 10:53 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We are at system boot and there is only 1 cgroup group (i,e,
>  init_css_set), so we don't need to run through the css_set
>  linked list. Neither do we need to run through the task list,
>  since no processes have been created yet.
>
>
>  Also referring to a comment in cgroup.h:
>
>  struct css_set
>  {
>         ...
>         /*
>          * Set of subsystem states, one for each subsystem. This array
>          * is immutable after creation apart from the init_css_set
>          * during subsystem registration (at boot time).
>          */
>         struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
>  }
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Paul Menage <menage@google.com>

Looks good, thanks.

>  ---
>   Documentation/cgroups.txt |    3 +--
>   kernel/cgroup.c           |   35 +++++++++--------------------------
>   2 files changed, 10 insertions(+), 28 deletions(-)
>
>  diff --git a/Documentation/cgroups.txt b/Documentation/cgroups.txt
>  index 31d12e2..c298a66 100644
>  --- a/Documentation/cgroups.txt
>  +++ b/Documentation/cgroups.txt
>  @@ -500,8 +500,7 @@ post-attachment activity that requires memory allocations or blocking.
>
>   void fork(struct cgroup_subsy *ss, struct task_struct *task)
>
>  -Called when a task is forked into a cgroup. Also called during
>  -registration for all existing tasks.
>  +Called when a task is forked into a cgroup.
>
>   void exit(struct cgroup_subsys *ss, struct task_struct *task)
>
>
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index f79e60d..250e28e 100644
>
> --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -2471,7 +2471,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>
>  static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>   {
>         struct cgroup_subsys_state *css;
>  -       struct list_head *l;
>
>         printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>
>  @@ -2482,35 +2481,19 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>
>         BUG_ON(IS_ERR(css));
>         init_cgroup_css(css, ss, dummytop);
>
>  -       /* Update all cgroup groups to contain a subsys
>  +       /* Update the init_css_set to contain a subsys
>          * pointer to this state - since the subsystem is
>  -        * newly registered, all tasks and hence all cgroup
>  -        * groups are in the subsystem's top cgroup. */
>  -       write_lock(&css_set_lock);
>  -       l = &init_css_set.list;
>  -       do {
>  -               struct css_set *cg =
>  -                       list_entry(l, struct css_set, list);
>  -               cg->subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
>  -               l = l->next;
>  -       } while (l != &init_css_set.list);
>  -       write_unlock(&css_set_lock);
>  -
>
> -       /* If this subsystem requested that it be notified with fork
>  -        * events, we should send it one now for every process in the
>  -        * system */
>  -       if (ss->fork) {
>  -               struct task_struct *g, *p;
>  -
>  -               read_lock(&tasklist_lock);
>  -               do_each_thread(g, p) {
>  -                       ss->fork(ss, p);
>  -               } while_each_thread(g, p);
>  -               read_unlock(&tasklist_lock);
>  -       }
>
> +        * newly registered, all tasks and hence the
>  +        * init_css_set is in the subsystem's top cgroup. */
>  +       init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
>
>         need_forkexit_callback |= ss->fork || ss->exit;
>
>  +       /* At system boot, before all subsystems have been
>  +        * registered, no tasks have been forked, so we don't
>  +        * need to invoke fork callbacks here. */
>  +       BUG_ON(!list_empty(&init_task.tasks));
>  +
>         ss->active = 1;
>   }
>
>  --
>  1.5.4.rc3
>
