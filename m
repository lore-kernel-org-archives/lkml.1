Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZLOKac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZLOKac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZLOKab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:30:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:16929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZLOKaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:30:30 -0500
MIME-Version: 1.0
In-Reply-To: <20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <cc557aab0912150111k41517b41t8999568db3bd8daa@mail.gmail.com>
	 <20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 12:30:27 +0200
Message-ID: <cc557aab0912150230g54863bb8rabc8b8c1c58d5a55@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] cgroup: implement eventfd-based generic API 
	for notifications
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 15 Dec 2009 11:11:16 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>
>> Could anybody review the patch?
>>
>> Thank you.
>
> some nitpicks.
>
>>
>> On Sat, Dec 12, 2009 at 12:59 AM, Kirill A. Shutemov
>> <kirill@shutemov.name> wrote:
>
>> > +       /*
>> > +        * Unregister events and notify userspace.
>> > +        * FIXME: How to avoid race with cgroup_event_remove_work()
>> > +        *        which runs from workqueue?
>> > +        */
>> > +       mutex_lock(&cgrp->event_list_mutex);
>> > +       list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
>> > +               cgroup_event_remove(event);
>> > +               eventfd_signal(event->eventfd, 1);
>> > +       }
>> > +       mutex_unlock(&cgrp->event_list_mutex);
>> > +
>> > +out:
>> >        return ret;
>> >  }
>
> How ciritical is this FIXME ?

There is potential race. I have never seen it. When userspace closes
eventfd associated
with cgroup event, cgroup_event_remove() will not be called
immediately. It will be called
later from workqueue. If somebody removes cgroup before the workqueue calls
cgroup_event_remove() we will get problem.
It's unlikely, but theoretically possible.

> But Hmm..can't we use RCU ?

I'll play with it.

>> >
>> > @@ -1136,6 +1187,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
>> >        INIT_LIST_HEAD(&cgrp->release_list);
>> >        INIT_LIST_HEAD(&cgrp->pidlists);
>> >        mutex_init(&cgrp->pidlist_mutex);
>> > +       INIT_LIST_HEAD(&cgrp->event_list);
>> > +       mutex_init(&cgrp->event_list_mutex);
>> >  }
>> >
>> >  static void init_cgroup_root(struct cgroupfs_root *root)
>> > @@ -1935,6 +1988,16 @@ static const struct inode_operations cgroup_dir_inode_operations = {
>> >        .rename = cgroup_rename,
>> >  };
>> >
>> > +/*
>> > + * Check if a file is a control file
>> > + */
>> > +static inline struct cftype *__file_cft(struct file *file)
>> > +{
>> > +       if (file->f_dentry->d_inode->i_fop != &cgroup_file_operations)
>> > +               return ERR_PTR(-EINVAL);
>> > +       return __d_cft(file->f_dentry);
>> > +}
>> > +
>> >  static int cgroup_create_file(struct dentry *dentry, mode_t mode,
>> >                                struct super_block *sb)
>> >  {
>> > @@ -2789,6 +2852,151 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
>> >        return 0;
>> >  }
>> >
>> > +static inline void cgroup_event_remove(struct cgroup_event *event)
>> > +{
>> > +       struct cgroup *cgrp = event->cgrp;
>> > +
>> > +       BUG_ON(event->cft->unregister_event(cgrp, event->cft, event->eventfd));
>
> Hmm ? BUG ? If bug, please add document or comment.

I'll remove it, since we check it in cgroup_write_event_control().

>> > +       eventfd_ctx_put(event->eventfd);
>> > +       remove_wait_queue(event->wqh, &event->wait);
>> > +       list_del(&event->list);
>
> please add comment as /* event_list_mutex must be held */

Ok.

>> > +       kfree(event);
>> > +}
>> > +
>> > +static void cgroup_event_remove_work(struct work_struct *work)
>> > +{
>> > +       struct cgroup_event *event = container_of(work, struct cgroup_event,
>> > +                       remove);
>> > +       struct cgroup *cgrp = event->cgrp;
>> > +
>> > +       mutex_lock(&cgrp->event_list_mutex);
>> > +       cgroup_event_remove(event);
>> > +       mutex_unlock(&cgrp->event_list_mutex);
>> > +}
>> > +
>> > +static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
>> > +               int sync, void *key)
>> > +{
>> > +       struct cgroup_event *event = container_of(wait,
>> > +                       struct cgroup_event, wait);
>> > +       unsigned long flags = (unsigned long)key;
>> > +
>> > +       if (flags & POLLHUP)
>> > +               /*
>> > +                * This function called with spinlock taken, but
>> > +                * cgroup_event_remove() may sleep, so we have
>> > +                * to run it in a workqueue.
>> > +                */
>> > +               schedule_work(&event->remove);
>> > +
>> > +       return 0;
>> > +}
>
>> > +
>> > +static void cgroup_event_ptable_queue_proc(struct file *file,
>> > +               wait_queue_head_t *wqh, poll_table *pt)
>> > +{
>> > +       struct cgroup_event *event = container_of(pt,
>> > +                       struct cgroup_event, pt);
>> > +
>> > +       event->wqh = wqh;
>> > +       add_wait_queue(wqh, &event->wait);
>> > +}
>> > +
>> > +static int cgroup_write_event_control(struct cgroup *cont, struct cftype *cft,
>> > +                                     const char *buffer)
>> > +{
>> > +       struct cgroup_event *event = NULL;
>> > +       unsigned int efd, cfd;
>> > +       struct file *efile = NULL;
>> > +       struct file *cfile = NULL;
>> > +       char *endp;
>> > +       int ret;
>> > +
>> > +       efd = simple_strtoul(buffer, &endp, 10);
>> > +       if (*endp != ' ')
>> > +               return -EINVAL;
>> > +       buffer = endp + 1;
>> > +
>> > +       cfd = simple_strtoul(buffer, &endp, 10);
>> > +       if ((*endp != ' ') && (*endp != '\0'))
>> > +               return -EINVAL;
>> > +       buffer = endp + 1;
>> > +
>> > +       event = kzalloc(sizeof(*event), GFP_KERNEL);
>> > +       if (!event)
>> > +               return -ENOMEM;
>> > +       event->cgrp = cont;
>> > +       INIT_LIST_HEAD(&event->list);
>> > +       init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
>> > +       init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
>> > +       INIT_WORK(&event->remove, cgroup_event_remove_work);
>> > +
>> > +       efile = eventfd_fget(efd);
>> > +       if (IS_ERR(efile)) {
>> > +               ret = PTR_ERR(efile);
>> > +               goto fail;
>> > +       }
>> > +
>> > +       event->eventfd = eventfd_ctx_fileget(efile);
>> > +       if (IS_ERR(event->eventfd)) {
>> > +               ret = PTR_ERR(event->eventfd);
>> > +               goto fail;
>> > +       }
>> > +
>> > +       cfile = fget(cfd);
>> > +       if (!cfile) {
>> > +               ret = -EBADF;
>> > +               goto fail;
>> > +       }
>> > +
>> > +       /* the process need read permission on control file */
>> > +       ret = file_permission(cfile, MAY_READ);
>> > +       if (ret < 0)
>> > +               goto fail;
>> > +
>> > +       event->cft = __file_cft(cfile);
>> > +       if (IS_ERR(event->cft)) {
>> > +               ret = PTR_ERR(event->cft);
>> > +               goto fail;
>> > +       }
>> > +
>> > +       if (!event->cft->register_event || !event->cft->unregister_event) {
>> > +               ret = -EINVAL;
>> > +               goto fail;
>> > +       }
>> > +
>> > +       ret = event->cft->register_event(cont, event->cft,
>> > +                       event->eventfd, buffer);
>> > +       if (ret)
>> > +               goto fail;
>> > +
>> > +       efile->f_op->poll(efile, &event->pt);
>
> Not necessary to check return value ?

You are right. We need to check return value for POLLHUP.

Thanks!
