Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYKXUlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYKXUlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYKXUlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:41:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYKXUlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:41:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=GM7MZ6ZLVsBXTGIRTWJtE4FZbcuP7gz7QDhRvSvUNWGqdVrjKjPlFBy4AF+SqmoTU
	lSwXaOJpAbQOzenRZuUSg==
MIME-Version: 1.0
In-Reply-To: <49278602.2000707@cn.fujitsu.com>
References: <49278602.2000707@cn.fujitsu.com>
Date: Mon, 24 Nov 2008 12:41:09 -0800
Message-ID: <6599ad830811241241p2a01c7e1h163766c088141468@mail.gmail.com>
Subject: Re: [PATCH] cgroups: remove rcu_read_lock() in cgroupstats_build()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 8:09 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> cgroup_iter_* do not need rcu_read_lock().
>
> In cgroup_enable_task_cg_lists(), do_each_thread() and
> while_each_thread() are protected by RCU,
> it's OK, for write_lock(&css_set_lock) implies rcu_read_lock() in non-RT kernel.
>
> If we need explicit rcu_read_lock(), we should add rcu_read_lock()
> in cgroup_enable_task_cg_lists(), not cgroup_iter_*.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Seems reasonable. Thanks,

Paul

> ---
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..e6d92a5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2047,7 +2047,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
>
>        ret = 0;
>        cgrp = dentry->d_fsdata;
> -       rcu_read_lock();
>
>        cgroup_iter_start(cgrp, &it);
>        while ((tsk = cgroup_iter_next(cgrp, &it))) {
> @@ -2072,7 +2071,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
>        }
>        cgroup_iter_end(cgrp, &it);
>
> -       rcu_read_unlock();
>  err:
>        return ret;
>  }
>
>
>
