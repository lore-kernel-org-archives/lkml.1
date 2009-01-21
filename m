Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbZAUKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbZAUKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZAUKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:01:04 -0500
Received: from smtp-out.google.com ([216.239.33.17]:23688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZAUKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:01:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=WMd+7/6MkyjU9THY9SnoVDD0ZmZJgoKiM0uHyhAOPtQrD9yBOvRBBH3UC/8r++PGK
	V5EYlKaYGnN1kByqmYS8g==
MIME-Version: 1.0
In-Reply-To: <20090120194735.cc52c5e0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
	 <20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
	 <20090114121205.1bb913aa.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090120194735.cc52c5e0.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 02:00:56 -0800
Message-ID: <6599ad830901210200q77b2553ag35f706c321a18d83@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir v2
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 2:47 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>        CGRP_NOTIFY_ON_RELEASE,
> +       /* Someone calls rmdir() and is wating for this cgroup is released */

/* A thread is in rmdir() waiting to destroy this cgroup */

Also document that it can only be set/cleared when you're holding the
inode_sem for the cgroup directory. And we should probably move this
enum inside cgroup.c, since nothing in the header file uses it.

> +       CGRP_WAIT_ON_RMDIR,
>  };

>
>  struct cgroup {
> @@ -350,7 +352,7 @@ int cgroup_is_descendant(const struct cg
>  struct cgroup_subsys {
>        struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
>                                                  struct cgroup *cgrp);
> -       void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> +       int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);

Can you update the documentation to indicate what an error result from
pre_destroy indicates? Can pre_destroy() be called multiple times for
the same subsystem/cgroup?

> +
> +       /* wake up rmdir() waiter....it should fail.*/

/* Wake up rmdir() waiter - the rmdir should fail since the cgroup is
no longer empty */

But is this safe? If we do a pre-destroy, is it OK to let new tasks
into the cgroup?

> @@ -2446,6 +2461,8 @@ static long cgroup_create(struct cgroup
>
>        mutex_unlock(&cgroup_mutex);
>        mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
> +       if (wakeup_on_rmdir(parent))
> +               cgroup_rmdir_wakeup_waiters();

I don't think that there can be a waiter, since rmdir() would hold the
parent's inode semaphore, which would block this thread before it gets
to cgroup_create()

> +DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
> +
> +static void cgroup_rmdir_wakeup_waiters(void)
> +{
> +       wake_up_all(&cgroup_rmdir_waitq);
> +}
> +

I think you can merge wakeup_on_rmdir() and
cgroup_rmdir_wakeup_waiters() into a single function,
cgroup_wakeup_rmdir(struct cgroup *)


>
> +       if (signal_pending(current))
> +               return -EINTR;

I think it would be better to move this check to after we've already
failed on cgroup_clear_css_refs(). That way we can't fail with an
EINTR just because we raced with a signal on the way into rmdir() - we
have to actually hit the EBUSY and try to sleep.
> +       ret = cgroup_call_pre_destroy(cgrp);
> +       if (ret == -EBUSY)
> +               return -EBUSY;

What about other potential error codes? If the subsystem's only
allowed to return 0 or EBUSY, then we should check for that.

Paul
