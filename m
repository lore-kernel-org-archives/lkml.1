Return-Path: <linux-kernel-owner+w=401wt.eu-S965201AbXA3EYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201AbXA3EYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965220AbXA3EYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:24:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201AbXA3EYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:24:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 3/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Tue, 30 Jan 2007 05:24:32 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F78.6080705@us.ibm.com>
In-Reply-To: <45BE4F78.6080705@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701300524.32556.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX197ulibmhN8JP5NkTVuY5MoYZZqougdPabHkW4idPKWbx0tMvA8+rEWha3qOkp/lenXCssLR8FBammfI1uqF2l4VJGd5Nm09POCrs4qIZAzZA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 20:48, Maynard Johnson wrote:
> Subject: Enable SPU switch notification to detect currently active SPU tasks.
> 
> From: Maynard Johnson <maynardj@us.ibm.com>
> 
> This patch adds to the capability of spu_switch_event_register so that the
> caller is also notified of currently active SPU tasks.  It also exports
> spu_switch_event_register and spu_switch_event_unregister.
> 
> Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>

I looked through it again, and think I found a serious bug, but that
should be easy enough to solve:

> +static void notify_spus_active(void)
> +{
> +       int node;
> +       /* Wake up the active spu_contexts. When the awakened processes 
> +        * sees their notify_active flag is set, they will call
> +        * spu_switch_notify();
> +        */
> +       for (node = 0; node < MAX_NUMNODES; node++) {
> +               struct spu *spu;
> +               mutex_lock(&spu_prio->active_mutex[node]);
> +                list_for_each_entry(spu, &spu_prio->active_list[node], list) {
> +                       struct spu_context *ctx = spu->ctx;

[side note]
There is a small whitespace breakage in here, please make sure you always
use tabs for indenting, not space characters.
[/side note]

> @@ -45,9 +45,10 @@
>         u64 pte_fault;
>  
>         *stat = ctx->ops->status_read(ctx);
> -       if (ctx->state != SPU_STATE_RUNNABLE)
> -               return 1;
> +
>         spu = ctx->spu;
> +       if (ctx->state != SPU_STATE_RUNNABLE || spu->notify_active)
> +               return 1;
>         pte_fault = spu->dsisr &
>             (MFC_DSISR_PTE_NOT_FOUND | MFC_DSISR_ACCESS_DENIED);
>         return (!(*stat & 0x1) || pte_fault || spu->class_0_pending) ? 1 : 0;
> @@ -305,6 +306,7 @@
>                    u32 *npc, u32 *event)
>  {
>         int ret;
> +       struct spu * spu;
>         u32 status;
>  
>         if (down_interruptible(&ctx->run_sema))
> @@ -318,8 +320,16 @@
>  
>         do {
>                 ret = spufs_wait(ctx->stop_wq, spu_stopped(ctx, &status));
> +               spu = ctx->spu;
>                 if (unlikely(ret))
>                         break;
> +               if (unlikely(spu->notify_active)) {
> +                       spu->notify_active = 0;
> +                       if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
> +                               spu_switch_notify(spu, ctx);
> +                               continue;
> +                       }
> +               }

This is before spu_reacquire_runnable, so in case the spu got
preempted at the same time when oprofile was enabled, ctx->spu
is NULL, and you can't load the notify_active flag from it.

On solution would be to move the notify_active flag from ctx->spu
into ctx itself, but maybe there are other ways to solve this.

Thanks,

	Arnd <><
