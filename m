Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYGaLnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYGaLnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYGaLnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:43:05 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:38340 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYGaLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:43:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VWhumLATWVizx9yIZ9QfezxzWCwpNhDfzWKY5CvZhb9dY5iTogO4Qg07wVd05vIlM1
         Gp7H8J3lX8p2PZKounyHZGs21v/x6D7CrN3p71nHlO+x3T9SKm3Ome/+QpDEMvg7Jyog
         Ll3N20aAyspJCPo9VERb9aizIwhSKdBMXGW5g=
Message-ID: <a4423d670807310443j593ef7f5p9d4f1fa553de1b6d@mail.gmail.com>
Date: Thu, 31 Jul 2008 15:43:02 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, mingo@redhat.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] kernel/profile.c: fix warnings
In-Reply-To: <20080729190026.GA32433@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729190026.GA32433@orion>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> Moved these three functions under ifdef CONFIG_PROC_FS, separated
> profile_hits. Perhaps it would be better to join two ifdef-CONFIG_PROC_FS
> blocks.
> This patch is on top of 2.6.27-rc1.
>
> From: Alexander Beregalov <a.beregalov@gmail.com>
>
> kernel/profile.c: fix warnings:
>
> kernel/profile.c:245: warning: 'profile_flip_buffers' defined but not
> used
> kernel/profile.c:268: warning: 'profile_discard_flip_buffers' defined
> but not used
> kernel/profile.c:335: warning: 'profile_cpu_callback' defined but not
> used
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> ---
>
>  kernel/profile.c |  107 ++++++++++++++++++++++++++++--------------------------
>  1 files changed, 56 insertions(+), 51 deletions(-)
>
> diff --git a/kernel/profile.c b/kernel/profile.c
> index cd26bed..0f377d9 100644
> --- a/kernel/profile.c
> +++ b/kernel/profile.c
> @@ -202,6 +202,7 @@ void unregister_timer_hook(int (*hook)(struct pt_regs *))
>  EXPORT_SYMBOL_GPL(unregister_timer_hook);
>
>
> +#ifdef CONFIG_PROC_FS
>  #ifdef CONFIG_SMP
>  /*
>  * Each cpu has a pair of open-addressed hashtables for pending
> @@ -279,57 +280,6 @@ static void profile_discard_flip_buffers(void)
>        mutex_unlock(&profile_flip_mutex);
>  }
>
> -void profile_hits(int type, void *__pc, unsigned int nr_hits)
> -{
> -       unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
> -       int i, j, cpu;
> -       struct profile_hit *hits;
> -
> -       if (prof_on != type || !prof_buffer)
> -               return;
> -       pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
> -       i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
> -       secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
> -       cpu = get_cpu();
> -       hits = per_cpu(cpu_profile_hits, cpu)[per_cpu(cpu_profile_flip, cpu)];
> -       if (!hits) {
> -               put_cpu();
> -               return;
> -       }
> -       /*
> -        * We buffer the global profiler buffer into a per-CPU
> -        * queue and thus reduce the number of global (and possibly
> -        * NUMA-alien) accesses. The write-queue is self-coalescing:
> -        */
> -       local_irq_save(flags);
> -       do {
> -               for (j = 0; j < PROFILE_GRPSZ; ++j) {
> -                       if (hits[i + j].pc == pc) {
> -                               hits[i + j].hits += nr_hits;
> -                               goto out;
> -                       } else if (!hits[i + j].hits) {
> -                               hits[i + j].pc = pc;
> -                               hits[i + j].hits = nr_hits;
> -                               goto out;
> -                       }
> -               }
> -               i = (i + secondary) & (NR_PROFILE_HIT - 1);
> -       } while (i != primary);
> -
> -       /*
> -        * Add the current hit(s) and flush the write-queue out
> -        * to the global buffer:
> -        */
> -       atomic_add(nr_hits, &prof_buffer[pc]);
> -       for (i = 0; i < NR_PROFILE_HIT; ++i) {
> -               atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
> -               hits[i].pc = hits[i].hits = 0;
> -       }
> -out:
> -       local_irq_restore(flags);
> -       put_cpu();
> -}
> -
>  static int __devinit profile_cpu_callback(struct notifier_block *info,
>                                        unsigned long action, void *__cpu)
>  {
> @@ -390,7 +340,62 @@ out_free:
>  #define profile_flip_buffers()         do { } while (0)
>  #define profile_discard_flip_buffers() do { } while (0)
>  #define profile_cpu_callback           NULL
> +#endif
> +#endif /* CONFIG_PROC_FS */
>
> +#ifdef CONFIG_SMP
> +void profile_hits(int type, void *__pc, unsigned int nr_hits)
> +{
> +       unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
> +       int i, j, cpu;
> +       struct profile_hit *hits;
> +
> +       if (prof_on != type || !prof_buffer)
> +               return;
> +       pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
> +       i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
> +       secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
> +       cpu = get_cpu();
> +       hits = per_cpu(cpu_profile_hits, cpu)[per_cpu(cpu_profile_flip, cpu)];
> +       if (!hits) {
> +               put_cpu();
> +               return;
> +       }
> +       /*
> +        * We buffer the global profiler buffer into a per-CPU
> +        * queue and thus reduce the number of global (and possibly
> +        * NUMA-alien) accesses. The write-queue is self-coalescing:
> +        */
> +       local_irq_save(flags);
> +       do {
> +               for (j = 0; j < PROFILE_GRPSZ; ++j) {
> +                       if (hits[i + j].pc == pc) {
> +                               hits[i + j].hits += nr_hits;
> +                               goto out;
> +                       } else if (!hits[i + j].hits) {
> +                               hits[i + j].pc = pc;
> +                               hits[i + j].hits = nr_hits;
> +                               goto out;
> +                       }
> +               }
> +               i = (i + secondary) & (NR_PROFILE_HIT - 1);
> +       } while (i != primary);
> +
> +       /*
> +        * Add the current hit(s) and flush the write-queue out
> +        * to the global buffer:
> +        */
> +       atomic_add(nr_hits, &prof_buffer[pc]);
> +       for (i = 0; i < NR_PROFILE_HIT; ++i) {
> +               atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
> +               hits[i].pc = hits[i].hits = 0;
> +       }
> +out:
> +       local_irq_restore(flags);
> +       put_cpu();
> +}
> +
> +#else /* !CONFIG_SMP */
>  void profile_hits(int type, void *__pc, unsigned int nr_hits)
>  {
>        unsigned long pc;
>

Hi Andrew,
Can you also have a look at this?
Is there a better way to fix it?

Thanks
