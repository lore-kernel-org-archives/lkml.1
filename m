Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZBDPs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZBDPs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZBDPst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:48:49 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZBDPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:48:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=X0DHak7146be/Cwp+o5siuaPqEJjPUUPpP+JQ/ClUV95iCobzi5+ARP2k3TXmdGSP
	jZWSoEdA9EujEM6P7zgaA==
MIME-Version: 1.0
In-Reply-To: <49895BD7.8090405@cn.fujitsu.com>
References: <49895BD7.8090405@cn.fujitsu.com>
Date: Wed, 4 Feb 2009 07:48:42 -0800
Message-ID: <6599ad830902040748u58c7afcasc4152175aa382a2b@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix lockdep subclasses overflow
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 1:11 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> This patch uses different lockdep keys for different subsystems.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Looks good, thanks.

Paul

> ---
>  include/linux/cgroup.h |    1 +
>  kernel/cgroup.c        |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e4e8e11..499900d 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -378,6 +378,7 @@ struct cgroup_subsys {
>         * - initiating hotplug events
>         */
>        struct mutex hierarchy_mutex;
> +       struct lock_class_key subsys_key;
>
>        /*
>         * Link to parent, and list entry in parent's children.
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5a54ff4..e14db9c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2351,7 +2351,7 @@ static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
>        for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>                struct cgroup_subsys *ss = subsys[i];
>                if (ss->root == root)
> -                       mutex_lock_nested(&ss->hierarchy_mutex, i);
> +                       mutex_lock(&ss->hierarchy_mutex);
>        }
>  }
>
> @@ -2637,6 +2637,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>        BUG_ON(!list_empty(&init_task.tasks));
>
>        mutex_init(&ss->hierarchy_mutex);
> +       lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
>        ss->active = 1;
>  }
>
> --
> 1.5.4.rc3
>
>
>
>
