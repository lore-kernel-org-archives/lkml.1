Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726Ab0AZXJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0AZXJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677Ab0AZXJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:09:04 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0AZXJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:09:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HPAh3HxC1EGWnfnoUaxO2IxSNFTgMihNV1C0AGW8TN6/UvA+SeR+VHfSbHsNxgn1R
	docN979SkH2c5KtfdfLXw==
MIME-Version: 1.0
In-Reply-To: <4B5EA500.5040802@cn.fujitsu.com>
References: <4B5EA4EC.8020700@cn.fujitsu.com> <4B5EA500.5040802@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 15:08:59 -0800
Message-ID: <6599ad831001261508w2262bf56gd713c5170a91c31d@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroups: Clean up cgroup_pidlist_find() a bit
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@andrew.cmu.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 12:17 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Don't Call get_pid_ns() before we locate/alloc the ns.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  cgroup.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> --- a/kernel/cgroup.c.orig      2010-01-26 14:24:29.000000000 +0800
> +++ a/kernel/cgroup.c   2010-01-26 14:24:44.000000000 +0800
> @@ -2643,7 +2643,8 @@ static struct cgroup_pidlist *cgroup_pid
>  {
>        struct cgroup_pidlist *l;
>        /* don't need task_nsproxy() if we're looking at ourself */
> -       struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
> +       struct pid_namespace *ns = current->nsproxy->pid_ns;
> +
>        /*
>         * We can't drop the pidlist_mutex before taking the l->mutex in case
>         * the last ref-holder is trying to remove l from the list at the same
> @@ -2653,8 +2654,6 @@ static struct cgroup_pidlist *cgroup_pid
>        mutex_lock(&cgrp->pidlist_mutex);
>        list_for_each_entry(l, &cgrp->pidlists, links) {
>                if (l->key.type == type && l->key.ns == ns) {
> -                       /* found a matching list - drop the extra refcount */
> -                       put_pid_ns(ns);
>                        /* make sure l doesn't vanish out from under us */
>                        down_write(&l->mutex);
>                        mutex_unlock(&cgrp->pidlist_mutex);
> @@ -2665,13 +2664,12 @@ static struct cgroup_pidlist *cgroup_pid
>        l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
>        if (!l) {
>                mutex_unlock(&cgrp->pidlist_mutex);
> -               put_pid_ns(ns);
>                return l;
>        }
>        init_rwsem(&l->mutex);
>        down_write(&l->mutex);
>        l->key.type = type;
> -       l->key.ns = ns;
> +       l->key.ns = get_pid_ns(ns);
>        l->use_count = 0; /* don't increment here */
>        l->list = NULL;
>        l->owner = cgrp;
>
