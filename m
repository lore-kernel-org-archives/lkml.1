Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYHFKaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYHFKaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYHFK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:29:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22366 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYHFK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hPHTsH6YzRL5xGdaAdBuVe15mlKhSaPOKfQyomOrEuWAABqQ3fdedpi+u6dz4OSKOk
         lC6tm/hq99n0weogwufdpHHRsWWo++xyAIr7OXKzqfwr2lI91a40PGikr42qZqkXOLeC
         zkAaUNIjKO98zDJ+wYNs7RAZdGyS/WtltzsrE=
Message-ID: <86802c440808060329u32a02d19l95de3b47ce6f3f15@mail.gmail.com>
Date: Wed, 6 Aug 2008 03:29:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 32/33] remove >= nr_irqs checking with config_have_sparse_irq
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1218012195-10429-33-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-25-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-26-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-27-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-28-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-29-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-30-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-31-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-32-git-send-email-yhlu.kernel@gmail.com>
	 <1218012195-10429-33-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 1:43 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/io_apic_64.c |   36 ++++++++++++++++++++++++------------
>  arch/x86/kernel/irq_64.c     |    2 +-
>  drivers/char/random.c        |    4 ++++
>  fs/proc/proc_misc.c          |   29 +++++++++++++++++------------
>  kernel/irq/chip.c            |   28 +++++++++++++++++++++++++++-
>  kernel/irq/manage.c          |   37 +++++++++++++++++++++++++++++++------
>  6 files changed, 104 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
> index 8bb6565..1416925 100644
> --- a/arch/x86/kernel/io_apic_64.c
> +++ b/arch/x86/kernel/io_apic_64.c

========================================================
> @@ -2475,16 +2486,17 @@ int create_irq(void)
>        int irq;
>        int new;
>        unsigned long flags;
> -       struct irq_cfg *cfg_new;
> +       struct irq_cfg *cfg_new, *cfg;
>
>        irq = -ENOSPC;
>        spin_lock_irqsave(&vector_lock, flags);
>        for (new = (nr_irqs - 1); new >= 0; new--) {
>                if (platform_legacy_irq(new))
>                        continue;
> -               cfg_new = get_irq_cfg(new);
> -               if (cfg_new->vector != 0)
> +               cfg = get_irq_cfg_without_new(new);
> +               if (!cfg || cfg->vector != 0)
>                        continue;
> +               cfg_new = get_irq_cfg(new);
>                if (__assign_irq_vector(new, TARGET_CPUS) == 0)
>                        irq = new;
>                break;
======================================
change to create_irq is not needed, it will disabled msi

YH
