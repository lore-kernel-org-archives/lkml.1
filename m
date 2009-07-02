Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZGBLke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZGBLke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZGBLk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:40:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55501 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZGBLkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:40:25 -0400
Date: Thu, 2 Jul 2009 17:10:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
Message-ID: <20090702114019.GQ11273@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com> <20090702105707.8b2135d9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090702105707.8b2135d9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-07-02 10:57:07]:

> On Wed, 1 Jul 2009 18:36:36 -0700
> Paul Menage <menage@google.com> wrote:
> 
> > Thanks Li - but as I said to Serge in the email when I brought this up
> > originally, I already had a patch in mind for this; I've had an intern
> > (Ben) at Google working on it. His patch (pretty much ready, and being
> > sent out tomorrow I hope) is pretty similar to yours, but his is on
> > top of another patch that provides a (currently read-only)
> > "cgroup.procs" file in each cgroup dir that lists the unique tgids in
> > the cgroup. So the key in the list of pid arrays is actually a pid_ns
> > and a file type (indicating procs or tasks) rather than just a pid_ns.
> > 
> Wow, I welcome "procs" file :)
>

Yes, we discussed this in the Resouce Management topic of the
containers mini-summit. I hope we are talking of the same thing.
 
> Off-topic:
> Is there relationship betweem mm->owner and tgid ?
> If no, is it difficult to synchronize tgid and mm->owner ?
>

At the beginning tgid is mm->owner.
 
> 
> > So I think it makes more sense to not use this patch, but to use the
> > pair of patches that Ben's written, since they provide more overal
> > functionality.
> > 
> > Paul
> > 
> > On Wed, Jul 1, 2009 at 6:24 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> > > The bug was introduced by commit cc31edceee04a7b87f2be48f9489ebb72d264844
> > > ("cgroups: convert tasks file to use a seq_file with shared pid array").
> > >
> > > We cache a pid array for all threads that are opening the same "tasks"
> > > file, but the pids in the array are always from the namespace of the
> > > last process that opened the file, so all other threads will read pids
> > > from that namespace instead of their own namespaces.
> > >
> > > To fix it, we maintain a list of pid arrays, which is keyed by pid_ns.
> > > The list will be of length 1 at most time.
> > >
> > > Reported-by: Paul Menage <menage@google.com>
> > > Idea-by: Paul Menage <menage@google.com>
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > ---
> > >  include/linux/cgroup.h |   11 ++----
> > >  kernel/cgroup.c        |   94 +++++++++++++++++++++++++++++++++++------------
> > >  2 files changed, 74 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > > index 665fa70..20411d2 100644
> > > --- a/include/linux/cgroup.h
> > > +++ b/include/linux/cgroup.h
> > > @@ -179,14 +179,11 @@ struct cgroup {
> > >         */
> > >        struct list_head release_list;
> > >
> > > -       /* pids_mutex protects the fields below */
> > > +       /* pids_mutex protects pids_list and cached pid arrays. */
> > >        struct rw_semaphore pids_mutex;
> > > -       /* Array of process ids in the cgroup */
> > > -       pid_t *tasks_pids;
> > > -       /* How many files are using the current tasks_pids array */
> > > -       int pids_use_count;
> > > -       /* Length of the current tasks_pids array */
> > > -       int pids_length;
> > > +
> > > +       /* Linked list of struct cgroup_pids */
> > > +       struct list_head pids_list;
> > >
> > >        /* For RCU-protected deletion */
> > >        struct rcu_head rcu_head;
> > > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > > index 3737a68..13dddb4 100644
> > > --- a/kernel/cgroup.c
> > > +++ b/kernel/cgroup.c
> > > @@ -47,6 +47,7 @@
> > >  #include <linux/hash.h>
> > >  #include <linux/namei.h>
> > >  #include <linux/smp_lock.h>
> > > +#include <linux/pid_namespace.h>
> > >
> > >  #include <asm/atomic.h>
> > >
> > > @@ -960,6 +961,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
> > >        INIT_LIST_HEAD(&cgrp->children);
> > >        INIT_LIST_HEAD(&cgrp->css_sets);
> > >        INIT_LIST_HEAD(&cgrp->release_list);
> > > +       INIT_LIST_HEAD(&cgrp->pids_list);
> > >        init_rwsem(&cgrp->pids_mutex);
> > >  }
> > >  static void init_cgroup_root(struct cgroupfs_root *root)
> > > @@ -2201,12 +2203,30 @@ err:
> > >        return ret;
> > >  }
> > >
> > > +/*
> > > + * Cache pids for all threads in the same pid namespace that are
> > > + * opening the same "tasks" file.
> > > + */
> > > +struct cgroup_pids {
> > > +       /* The node in cgrp->pids_list */
> > > +       struct list_head list;
> > > +       /* The cgroup those pids belong to */
> > > +       struct cgroup *cgrp;
> > > +       /* The namepsace those pids belong to */
> > > +       struct pid_namespace *pid_ns;
> > > +       /* Array of process ids in the cgroup */
> > > +       pid_t *tasks_pids;
> > > +       /* How many files are using the this tasks_pids array */
> > > +       int pids_use_count;
> > > +       /* Length of the current tasks_pids array */
> > > +       int pids_length;
> > > +};
> > > +
> > >  static int cmppid(const void *a, const void *b)
> > >  {
> > >        return *(pid_t *)a - *(pid_t *)b;
> > >  }
> > >
> > > -
> > >  /*
> > >  * seq_file methods for the "tasks" file. The seq_file position is the
> > >  * next pid to display; the seq_file iterator is a pointer to the pid
> > > @@ -2221,45 +2241,47 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
> > >         * after a seek to the start). Use a binary-search to find the
> > >         * next pid to display, if any
> > >         */
> > > -       struct cgroup *cgrp = s->private;
> > > +       struct cgroup_pids *cp = s->private;
> > > +       struct cgroup *cgrp = cp->cgrp;
> > >        int index = 0, pid = *pos;
> > >        int *iter;
> > >
> > >        down_read(&cgrp->pids_mutex);
> > >        if (pid) {
> > > -               int end = cgrp->pids_length;
> > > +               int end = cp->pids_length;
> > >
> > >                while (index < end) {
> > >                        int mid = (index + end) / 2;
> > > -                       if (cgrp->tasks_pids[mid] == pid) {
> > > +                       if (cp->tasks_pids[mid] == pid) {
> > >                                index = mid;
> > >                                break;
> > > -                       } else if (cgrp->tasks_pids[mid] <= pid)
> > > +                       } else if (cp->tasks_pids[mid] <= pid)
> > >                                index = mid + 1;
> > >                        else
> > >                                end = mid;
> > >                }
> > >        }
> > >        /* If we're off the end of the array, we're done */
> > > -       if (index >= cgrp->pids_length)
> > > +       if (index >= cp->pids_length)
> > >                return NULL;
> > >        /* Update the abstract position to be the actual pid that we found */
> > > -       iter = cgrp->tasks_pids + index;
> > > +       iter = cp->tasks_pids + index;
> > >        *pos = *iter;
> > >        return iter;
> > >  }
> > >
> > >  static void cgroup_tasks_stop(struct seq_file *s, void *v)
> > >  {
> > > -       struct cgroup *cgrp = s->private;
> > > +       struct cgroup_pids *cp = s->private;
> > > +       struct cgroup *cgrp = cp->cgrp;
> > >        up_read(&cgrp->pids_mutex);
> > >  }
> > >
> > >  static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
> > >  {
> > > -       struct cgroup *cgrp = s->private;
> > > +       struct cgroup_pids *cp = s->private;
> > >        int *p = v;
> > > -       int *end = cgrp->tasks_pids + cgrp->pids_length;
> > > +       int *end = cp->tasks_pids + cp->pids_length;
> > >
> > >        /*
> > >         * Advance to the next pid in the array. If this goes off the
> > > @@ -2286,26 +2308,32 @@ static struct seq_operations cgroup_tasks_seq_operations = {
> > >        .show = cgroup_tasks_show,
> > >  };
> > >
> > > -static void release_cgroup_pid_array(struct cgroup *cgrp)
> > > +static void release_cgroup_pid_array(struct cgroup_pids *cp)
> > >  {
> > > +       struct cgroup *cgrp = cp->cgrp;
> > > +
> > >        down_write(&cgrp->pids_mutex);
> > > -       BUG_ON(!cgrp->pids_use_count);
> > > -       if (!--cgrp->pids_use_count) {
> > > -               kfree(cgrp->tasks_pids);
> > > -               cgrp->tasks_pids = NULL;
> > > -               cgrp->pids_length = 0;
> > > +       BUG_ON(!cp->pids_use_count);
> > > +       if (!--cp->pids_use_count) {
> > > +               list_del(&cp->list);
> > > +               kfree(cp->tasks_pids);
> > > +               kfree(cp);
> > >        }
> > >        up_write(&cgrp->pids_mutex);
> > >  }
> > >
> > >  static int cgroup_tasks_release(struct inode *inode, struct file *file)
> > >  {
> > > -       struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
> > > +       struct seq_file *seq;
> > > +       struct cgroup_pids *cp;
> > >
> > >        if (!(file->f_mode & FMODE_READ))
> > >                return 0;
> > >
> > > -       release_cgroup_pid_array(cgrp);
> > > +       seq = file->private_data;
> > > +       cp = seq->private;
> > > +
> > > +       release_cgroup_pid_array(cp);
> > >        return seq_release(inode, file);
> > >  }
> > >
> > > @@ -2324,6 +2352,8 @@ static struct file_operations cgroup_tasks_operations = {
> > >  static int cgroup_tasks_open(struct inode *unused, struct file *file)
> > >  {
> > >        struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
> > > +       struct pid_namespace *pid_ns = task_active_pid_ns(current);
> > > +       struct cgroup_pids *cp;
> > >        pid_t *pidarray;
> > >        int npids;
> > >        int retval;
> > > @@ -2350,20 +2380,36 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
> > >         * array if necessary
> > >         */
> > >        down_write(&cgrp->pids_mutex);
> > > -       kfree(cgrp->tasks_pids);
> > > -       cgrp->tasks_pids = pidarray;
> > > -       cgrp->pids_length = npids;
> > > -       cgrp->pids_use_count++;
> > > +
> > > +       list_for_each_entry(cp, &cgrp->pids_list, list) {
> > > +               if (pid_ns == cp->pid_ns)
> > > +                       goto found;
> > > +       }
> > > +
> > > +       cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> > > +       if (!cp) {
> > > +               up_write(&cgrp->pids_mutex);
> > > +               kfree(pidarray);
> > > +               return -ENOMEM;
> > > +       }
> > > +       cp->cgrp = cgrp;
> > > +       cp->pid_ns = pid_ns;
> > > +       list_add(&cp->list, &cgrp->pids_list);
> > > +found:
> > > +       kfree(cp->tasks_pids);
> > > +       cp->tasks_pids = pidarray;
> > > +       cp->pids_length = npids;
> > > +       cp->pids_use_count++;
> > >        up_write(&cgrp->pids_mutex);
> > >
> > >        file->f_op = &cgroup_tasks_operations;
> > >
> > >        retval = seq_open(file, &cgroup_tasks_seq_operations);
> > >        if (retval) {
> > > -               release_cgroup_pid_array(cgrp);
> > > +               release_cgroup_pid_array(cp);
> > >                return retval;
> > >        }
> > > -       ((struct seq_file *)file->private_data)->private = cgrp;
> > > +       ((struct seq_file *)file->private_data)->private = cp;
> > >        return 0;
> > >  }
> > >
> > > --
> > > 1.5.4.rc3
> > >
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/containers
> > 
> 

-- 
	Balbir
