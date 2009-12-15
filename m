Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZLOJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZLOJip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZLOJio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:38:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49620 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZLOJim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:38:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 18:35:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v2 1/4] cgroup: implement eventfd-based generic API
  for notifications
Message-Id: <20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912150111k41517b41t8999568db3bd8daa@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<cc557aab0912150111k41517b41t8999568db3bd8daa@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 11:11:16 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> Could anybody review the patch?
> 
> Thank you.

some nitpicks.

> 
> On Sat, Dec 12, 2009 at 12:59 AM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:

> > +       /*
> > +        * Unregister events and notify userspace.
> > +        * FIXME: How to avoid race with cgroup_event_remove_work()
> > +        *        which runs from workqueue?
> > +        */
> > +       mutex_lock(&cgrp->event_list_mutex);
> > +       list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
> > +               cgroup_event_remove(event);
> > +               eventfd_signal(event->eventfd, 1);
> > +       }
> > +       mutex_unlock(&cgrp->event_list_mutex);
> > +
> > +out:
> >        return ret;
> >  }

How ciritical is this FIXME ?
But Hmm..can't we use RCU ?

> >
> > @@ -1136,6 +1187,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
> >        INIT_LIST_HEAD(&cgrp->release_list);
> >        INIT_LIST_HEAD(&cgrp->pidlists);
> >        mutex_init(&cgrp->pidlist_mutex);
> > +       INIT_LIST_HEAD(&cgrp->event_list);
> > +       mutex_init(&cgrp->event_list_mutex);
> >  }
> >
> >  static void init_cgroup_root(struct cgroupfs_root *root)
> > @@ -1935,6 +1988,16 @@ static const struct inode_operations cgroup_dir_inode_operations = {
> >        .rename = cgroup_rename,
> >  };
> >
> > +/*
> > + * Check if a file is a control file
> > + */
> > +static inline struct cftype *__file_cft(struct file *file)
> > +{
> > +       if (file->f_dentry->d_inode->i_fop != &cgroup_file_operations)
> > +               return ERR_PTR(-EINVAL);
> > +       return __d_cft(file->f_dentry);
> > +}
> > +
> >  static int cgroup_create_file(struct dentry *dentry, mode_t mode,
> >                                struct super_block *sb)
> >  {
> > @@ -2789,6 +2852,151 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
> >        return 0;
> >  }
> >
> > +static inline void cgroup_event_remove(struct cgroup_event *event)
> > +{
> > +       struct cgroup *cgrp = event->cgrp;
> > +
> > +       BUG_ON(event->cft->unregister_event(cgrp, event->cft, event->eventfd));

Hmm ? BUG ? If bug, please add document or comment.            

> > +       eventfd_ctx_put(event->eventfd);
> > +       remove_wait_queue(event->wqh, &event->wait);
> > +       list_del(&event->list);

please add comment as /* event_list_mutex must be held */

> > +       kfree(event);
> > +}
> > +
> > +static void cgroup_event_remove_work(struct work_struct *work)
> > +{
> > +       struct cgroup_event *event = container_of(work, struct cgroup_event,
> > +                       remove);
> > +       struct cgroup *cgrp = event->cgrp;
> > +
> > +       mutex_lock(&cgrp->event_list_mutex);
> > +       cgroup_event_remove(event);
> > +       mutex_unlock(&cgrp->event_list_mutex);
> > +}
> > +
> > +static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
> > +               int sync, void *key)
> > +{
> > +       struct cgroup_event *event = container_of(wait,
> > +                       struct cgroup_event, wait);
> > +       unsigned long flags = (unsigned long)key;
> > +
> > +       if (flags & POLLHUP)
> > +               /*
> > +                * This function called with spinlock taken, but
> > +                * cgroup_event_remove() may sleep, so we have
> > +                * to run it in a workqueue.
> > +                */
> > +               schedule_work(&event->remove);
> > +
> > +       return 0;
> > +}

> > +
> > +static void cgroup_event_ptable_queue_proc(struct file *file,
> > +               wait_queue_head_t *wqh, poll_table *pt)
> > +{
> > +       struct cgroup_event *event = container_of(pt,
> > +                       struct cgroup_event, pt);
> > +
> > +       event->wqh = wqh;
> > +       add_wait_queue(wqh, &event->wait);
> > +}
> > +
> > +static int cgroup_write_event_control(struct cgroup *cont, struct cftype *cft,
> > +                                     const char *buffer)
> > +{
> > +       struct cgroup_event *event = NULL;
> > +       unsigned int efd, cfd;
> > +       struct file *efile = NULL;
> > +       struct file *cfile = NULL;
> > +       char *endp;
> > +       int ret;
> > +
> > +       efd = simple_strtoul(buffer, &endp, 10);
> > +       if (*endp != ' ')
> > +               return -EINVAL;
> > +       buffer = endp + 1;
> > +
> > +       cfd = simple_strtoul(buffer, &endp, 10);
> > +       if ((*endp != ' ') && (*endp != '\0'))
> > +               return -EINVAL;
> > +       buffer = endp + 1;
> > +
> > +       event = kzalloc(sizeof(*event), GFP_KERNEL);
> > +       if (!event)
> > +               return -ENOMEM;
> > +       event->cgrp = cont;
> > +       INIT_LIST_HEAD(&event->list);
> > +       init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
> > +       init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
> > +       INIT_WORK(&event->remove, cgroup_event_remove_work);
> > +
> > +       efile = eventfd_fget(efd);
> > +       if (IS_ERR(efile)) {
> > +               ret = PTR_ERR(efile);
> > +               goto fail;
> > +       }
> > +
> > +       event->eventfd = eventfd_ctx_fileget(efile);
> > +       if (IS_ERR(event->eventfd)) {
> > +               ret = PTR_ERR(event->eventfd);
> > +               goto fail;
> > +       }
> > +
> > +       cfile = fget(cfd);
> > +       if (!cfile) {
> > +               ret = -EBADF;
> > +               goto fail;
> > +       }
> > +
> > +       /* the process need read permission on control file */
> > +       ret = file_permission(cfile, MAY_READ);
> > +       if (ret < 0)
> > +               goto fail;
> > +
> > +       event->cft = __file_cft(cfile);
> > +       if (IS_ERR(event->cft)) {
> > +               ret = PTR_ERR(event->cft);
> > +               goto fail;
> > +       }
> > +
> > +       if (!event->cft->register_event || !event->cft->unregister_event) {
> > +               ret = -EINVAL;
> > +               goto fail;
> > +       }
> > +
> > +       ret = event->cft->register_event(cont, event->cft,
> > +                       event->eventfd, buffer);
> > +       if (ret)
> > +               goto fail;
> > +
> > +       efile->f_op->poll(efile, &event->pt);

Not necessary to check return value ?

Thanks,
-Kame
> > +
> > +       mutex_lock(&cont->event_list_mutex);
> > +       list_add(&event->list, &cont->event_list);
> > +       mutex_unlock(&cont->event_list_mutex);
> > +
> > +       fput(cfile);
> > +       fput(efile);
> > +
> > +       return 0;
> > +
> > +fail:
> > +       if (!IS_ERR(cfile))
> > +               fput(cfile);
> > +
> > +       if (event && event->eventfd && !IS_ERR(event->eventfd))
> > +               eventfd_ctx_put(event->eventfd);
> > +
> > +       if (!IS_ERR(efile))
> > +               fput(efile);
> > +
> > +       if (event)
> > +               kfree(event);
> > +
> > +       return ret;
> > +}
> > +
> >  /*
> >  * for the common functions, 'private' gives the type of file
> >  */
> > @@ -2814,6 +3022,11 @@ static struct cftype files[] = {
> >                .read_u64 = cgroup_read_notify_on_release,
> >                .write_u64 = cgroup_write_notify_on_release,
> >        },
> > +       {
> > +               .name = CGROUP_FILE_GENERIC_PREFIX "event_control",
> > +               .write_string = cgroup_write_event_control,
> > +               .mode = S_IWUGO,
> > +       },
> >  };
> >
> >  static struct cftype cft_release_agent = {
> > --
> > 1.6.5.3
> >
> >
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

