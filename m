Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596Ab0AKVuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0AKVuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051Ab0AKVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:50:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:60696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0AKVuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:50:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=k5A3zFpxrCSAqex3M78wIihvrVr6YUXiBmEvaTbkKdfoGX+uUfJJ6XSZL2E1tqful
	es6ltA0BsU4r0ib9fFj/g==
MIME-Version: 1.0
In-Reply-To: <1263245216-14754-20-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
	 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
Date: Mon, 11 Jan 2010 13:50:11 -0800
Message-ID: <6599ad831001111350l4e125bcdo4b5cf278d18e46ac@mail.gmail.com>
Subject: Re: [PATCH 19/26] cgroups: Convert cgroups release_list_lock to 
	raw_spinlock
From: Paul Menage <menage@google.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this patch take the lock out of the scope of lockdep? Or is
raw_spinlock still high-level enough to support lockdep?

Paul

On Mon, Jan 11, 2010 at 1:26 PM, John Kacur <jkacur@redhat.com> wrote:
> Convert locks which cannot sleep in preempt-rt to raw_spinlocks
>
> See also 58814bae5de64d5291b813ea0a52192e4fa714ad
>
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  kernel/cgroup.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 0249f4b..32a80b2 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -204,7 +204,7 @@ list_for_each_entry(_root, &roots, root_list)
>  /* the list of cgroups eligible for automatic release. Protected by
>  * release_list_lock */
>  static LIST_HEAD(release_list);
> -static DEFINE_SPINLOCK(release_list_lock);
> +static DEFINE_RAW_SPINLOCK(release_list_lock);
>  static void cgroup_release_agent(struct work_struct *work);
>  static DECLARE_WORK(release_agent_work, cgroup_release_agent);
>  static void check_for_release(struct cgroup *cgrp);
> @@ -3151,11 +3151,11 @@ again:
>        finish_wait(&cgroup_rmdir_waitq, &wait);
>        clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>
> -       spin_lock(&release_list_lock);
> +       raw_spin_lock(&release_list_lock);
>        set_bit(CGRP_REMOVED, &cgrp->flags);
>        if (!list_empty(&cgrp->release_list))
>                list_del(&cgrp->release_list);
> -       spin_unlock(&release_list_lock);
> +       raw_spin_unlock(&release_list_lock);
>
>        cgroup_lock_hierarchy(cgrp->root);
>        /* delete this cgroup from parent->children */
> @@ -3691,13 +3691,13 @@ static void check_for_release(struct cgroup *cgrp)
>                 * already queued for a userspace notification, queue
>                 * it now */
>                int need_schedule_work = 0;
> -               spin_lock(&release_list_lock);
> +               raw_spin_lock(&release_list_lock);
>                if (!cgroup_is_removed(cgrp) &&
>                    list_empty(&cgrp->release_list)) {
>                        list_add(&cgrp->release_list, &release_list);
>                        need_schedule_work = 1;
>                }
> -               spin_unlock(&release_list_lock);
> +               raw_spin_unlock(&release_list_lock);
>                if (need_schedule_work)
>                        schedule_work(&release_agent_work);
>        }
> @@ -3747,7 +3747,7 @@ static void cgroup_release_agent(struct work_struct *work)
>  {
>        BUG_ON(work != &release_agent_work);
>        mutex_lock(&cgroup_mutex);
> -       spin_lock(&release_list_lock);
> +       raw_spin_lock(&release_list_lock);
>        while (!list_empty(&release_list)) {
>                char *argv[3], *envp[3];
>                int i;
> @@ -3756,7 +3756,7 @@ static void cgroup_release_agent(struct work_struct *work)
>                                                    struct cgroup,
>                                                    release_list);
>                list_del_init(&cgrp->release_list);
> -               spin_unlock(&release_list_lock);
> +               raw_spin_unlock(&release_list_lock);
>                pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>                if (!pathbuf)
>                        goto continue_free;
> @@ -3786,9 +3786,9 @@ static void cgroup_release_agent(struct work_struct *work)
>  continue_free:
>                kfree(pathbuf);
>                kfree(agentbuf);
> -               spin_lock(&release_list_lock);
> +               raw_spin_lock(&release_list_lock);
>        }
> -       spin_unlock(&release_list_lock);
> +       raw_spin_unlock(&release_list_lock);
>        mutex_unlock(&cgroup_mutex);
>  }
>
> --
> 1.6.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
