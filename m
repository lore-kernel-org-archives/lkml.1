Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZKVJRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZKVJRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZKVJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:17:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:24349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZKVJRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UVznwCP9Gbn/UvxWXQI6W/V+ntGBwGJ0A4fnrlogVDiPmIlBmEI5jSId8DavGFIsgz
         Z0uafyKZBmtbS6Gf81/t+LxXwILdBLGcB+MF0k2C9lbZJo0JVFjLG0mrk3usyy0WgZUp
         Kk9dO7/u5kBeYYeuyV3RTi6IN7BkRiQwsNKBY=
MIME-Version: 1.0
In-Reply-To: <80d3c5c680300de7ebd41aba89723a5cf45396ed.1258783305.git.andre.goddard@gmail.com>
References: <80d3c5c680300de7ebd41aba89723a5cf45396ed.1258783305.git.andre.goddard@gmail.com>
Date: Sun, 22 Nov 2009 11:17:45 +0200
X-Google-Sender-Auth: e3834a49c9e5bb69
Message-ID: <84144f020911220117p5c4720e0g58587b97efdbb46b@mail.gmail.com>
Subject: Re: [PATCH] pid: tighten pidmap_lock critical section
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andre,

On Sat, Nov 21, 2009 at 8:04 AM, André Goddard Rosa
<andre.goddard@gmail.com> wrote:
> Avoid calling kfree() under pidmap_lock and doing unnecessary work.
> It doesn't change behavior.
>
> It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
>   text    data     bss     dec     hex filename
>   4314    2216       8    6538    198a kernel/pid.o-BEFORE
>   4298    2216       8    6522    197a kernel/pid.o-AFTER
>
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

This patch is doing a lot more than the changelog above says it does.
What exactly is the purpose of this patch? What's the upside?

> ---
>  kernel/pid.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d3f722d..ec06912 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>                         * installing it:
>                         */
>                        spin_lock_irq(&pidmap_lock);
> -                       if (map->page)
> -                               kfree(page);
> -                       else
> +                       if (!map->page) {
>                                map->page = page;
> +                               page = NULL;
> +                       }
>                        spin_unlock_irq(&pidmap_lock);
> +                       kfree(page);

OK, maybe. The upside seem rather small and the resulting code is IMHO
slightly less readable.

>                        if (unlikely(!map->page))
>                                break;
>                }
> @@ -225,11 +226,11 @@ static void delayed_put_pid(struct rcu_head *rhp)
>  void free_pid(struct pid *pid)
>  {
>        /* We can be called with write_lock_irq(&tasklist_lock) held */
> -       int i;
> +       int i = 0;
>        unsigned long flags;
>
>        spin_lock_irqsave(&pidmap_lock, flags);
> -       for (i = 0; i <= pid->level; i++)
> +       for ( ; i <= pid->level; i++)
>                hlist_del_rcu(&pid->numbers[i].pid_chain);
>        spin_unlock_irqrestore(&pidmap_lock, flags);

This has nothing to do with kfree(). AFAICT, it just obfuscates the
code as the initial assignment to zero is lost in the noise anyway.

> @@ -268,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>        for (type = 0; type < PIDTYPE_MAX; ++type)
>                INIT_HLIST_HEAD(&pid->tasks[type]);
>
> +       upid = pid->numbers + ns->level;
>        spin_lock_irq(&pidmap_lock);
> -       for (i = ns->level; i >= 0; i--) {
> -               upid = &pid->numbers[i];
> +       for ( ; upid >= pid->numbers; --upid)
>                hlist_add_head_rcu(&upid->pid_chain,
>                                &pid_hash[pid_hashfn(upid->nr, upid->ns)]);
> -       }
>        spin_unlock_irq(&pidmap_lock);

Again, this has nothing to do with kfree(). I suspect this is where
most of the 16 byte text savings come from. I'm not convinced it's
worth the hit in readability, though.

                        Pekka
