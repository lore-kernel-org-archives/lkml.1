Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZGBQ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZGBQ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZGBQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:26:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZGBQ0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:26:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YSBwq62TQZphGJUbzWvJffrqqbYbb9C4jXe1Bn3/mz+wnaBiOn0LO1yIc1N7iN4tz
	WcqYcebL7MIHQZx+VBfpw==
MIME-Version: 1.0
In-Reply-To: <4A4C0C60.4050106@cn.fujitsu.com>
References: <4A4C0C60.4050106@cn.fujitsu.com>
Date: Thu, 2 Jul 2009 09:26:38 -0700
Message-ID: <6599ad830907020926t6305bec9t44a50cc165f6fc28@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 6:24 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> The bug was introduced by commit cc31edceee04a7b87f2be48f9489ebb72d264844
> ("cgroups: convert tasks file to use a seq_file with shared pid array").
>
> We cache a pid array for all threads that are opening the same "tasks"
> file, but the pids in the array are always from the namespace of the
> last process that opened the file, so all other threads will read pids
> from that namespace instead of their own namespaces.
>
> To fix it, we maintain a list of pid arrays, which is keyed by pid_ns.
> The list will be of length 1 at most time.
>
> Reported-by: Paul Menage <menage@google.com>
> Idea-by: Paul Menage <menage@google.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/cgroup.h |   11 ++----
>  kernel/cgroup.c        |   94 +++++++++++++++++++++++++++++++++++------------
>  2 files changed, 74 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 665fa70..20411d2 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -179,14 +179,11 @@ struct cgroup {
>         */
>        struct list_head release_list;
>
> -       /* pids_mutex protects the fields below */
> +       /* pids_mutex protects pids_list and cached pid arrays. */
>        struct rw_semaphore pids_mutex;
> -       /* Array of process ids in the cgroup */
> -       pid_t *tasks_pids;
> -       /* How many files are using the current tasks_pids array */
> -       int pids_use_count;
> -       /* Length of the current tasks_pids array */
> -       int pids_length;
> +
> +       /* Linked list of struct cgroup_pids */
> +       struct list_head pids_list;
>
>        /* For RCU-protected deletion */
>        struct rcu_head rcu_head;
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3737a68..13dddb4 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -47,6 +47,7 @@
>  #include <linux/hash.h>
>  #include <linux/namei.h>
>  #include <linux/smp_lock.h>
> +#include <linux/pid_namespace.h>
>
>  #include <asm/atomic.h>
>
> @@ -960,6 +961,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
>        INIT_LIST_HEAD(&cgrp->children);
>        INIT_LIST_HEAD(&cgrp->css_sets);
>        INIT_LIST_HEAD(&cgrp->release_list);
> +       INIT_LIST_HEAD(&cgrp->pids_list);
>        init_rwsem(&cgrp->pids_mutex);
>  }
>  static void init_cgroup_root(struct cgroupfs_root *root)
> @@ -2201,12 +2203,30 @@ err:
>        return ret;
>  }
>
> +/*
> + * Cache pids for all threads in the same pid namespace that are
> + * opening the same "tasks" file.
> + */
> +struct cgroup_pids {
> +       /* The node in cgrp->pids_list */
> +       struct list_head list;
> +       /* The cgroup those pids belong to */
> +       struct cgroup *cgrp;
> +       /* The namepsace those pids belong to */
> +       struct pid_namespace *pid_ns;
> +       /* Array of process ids in the cgroup */
> +       pid_t *tasks_pids;
> +       /* How many files are using the this tasks_pids array */
> +       int pids_use_count;
> +       /* Length of the current tasks_pids array */
> +       int pids_length;
> +};

Maybe lose the unnecessary "pids" suffices and prefixes in this structure?

>
> @@ -2324,6 +2352,8 @@ static struct file_operations cgroup_tasks_operations = {
>  static int cgroup_tasks_open(struct inode *unused, struct file *file)
>  {
>        struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
> +       struct pid_namespace *pid_ns = task_active_pid_ns(current);
> +       struct cgroup_pids *cp;
>        pid_t *pidarray;
>        int npids;
>        int retval;
> @@ -2350,20 +2380,36 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
>         * array if necessary
>         */
>        down_write(&cgrp->pids_mutex);
> -       kfree(cgrp->tasks_pids);
> -       cgrp->tasks_pids = pidarray;
> -       cgrp->pids_length = npids;
> -       cgrp->pids_use_count++;
> +
> +       list_for_each_entry(cp, &cgrp->pids_list, list) {
> +               if (pid_ns == cp->pid_ns)
> +                       goto found;
> +       }
> +
> +       cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> +       if (!cp) {
> +               up_write(&cgrp->pids_mutex);
> +               kfree(pidarray);
> +               return -ENOMEM;
> +       }
> +       cp->cgrp = cgrp;
> +       cp->pid_ns = pid_ns;

You're storing an uncounted reference to the pid ns here - there's no
guarantee that the pid_ns will outlive the open file.

Paul
