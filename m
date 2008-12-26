Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYLZGAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYLZGAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYLZF76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 00:59:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:50559 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYLZF75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 00:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SmrE3xoqvi2m6u8JD7txivkGl1cYt8TFFAMwqTpoQbv9JgA7OCoTq/V4uvn6l8GWwD
         Y+debCldrNZpTnk4yiVfMXHrb2ChS7fahLJTeygojRTszuFJWzOKKJOOvzJ1ax7v4jNl
         XTdRJ3R8Ajv2lGEIoVuc3WLLElwspQXuy6L3w=
Message-ID: <86802c440812252159v6129a385qb900be42845ac90a@mail.gmail.com>
Date: Thu, 25 Dec 2008 21:59:56 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081226141743.5CB5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226131855.5CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <86802c440812252036h37d4886bucab9ff3591f94821@mail.gmail.com>
	 <20081226141743.5CB5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 28983769b90462fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 9:24 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Thu, Dec 25, 2008 at 8:21 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
>> >> > Impact: cleanup
>> >> >
>> >> > introduce irq_inuse() macro and remove ifdef in stat.c
>> >>
>> >> should have a good name... irq_inuse is some confusing.
>> >
>> > Why?
>> > May I ask your perfered name?
>>
>> after freeing msi with dynamic_irq_cleanup(), that irq_desc is not used.
>
> hm, instead, How about following patch?
>
>
>
> =======
> Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> Impact: cleanup
>
> irq_desc can be NULL when CONFIG_SPARSE_IRQ=y only.
> therefore, NULL checking can move into kstat_irqs_cpu() of SPARSE_IRQ version.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/proc/stat.c      |   11 +----------
>  kernel/irq/handle.c |    2 +-
>  2 files changed, 2 insertions(+), 11 deletions(-)
>
> Index: b/fs/proc/stat.c
> ===================================================================
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -9,6 +9,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/time.h>
> +#include <linux/irqnr.h>
>  #include <asm/cputime.h>
>
>  #ifndef arch_irq_stat_cpu
> @@ -45,10 +46,6 @@ static int show_stat(struct seq_file *p,
>                steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>                guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>                for_each_irq_nr(j) {
> -#ifdef CONFIG_SPARSE_IRQ
> -                       if (!irq_to_desc(j))
> -                               continue;
> -#endif
>                        sum += kstat_irqs_cpu(j, i);
>                }
>                sum += arch_irq_stat_cpu(i);
> @@ -95,12 +92,6 @@ static int show_stat(struct seq_file *p,
>        /* sum again ? it could be updated? */
>        for_each_irq_nr(j) {
>                per_irq_sum = 0;
> -#ifdef CONFIG_SPARSE_IRQ
> -               if (!irq_to_desc(j)) {
> -                       seq_printf(p, " %u", per_irq_sum);
> -                       continue;
> -               }
> -#endif
>                for_each_possible_cpu(i)
>                        per_irq_sum += kstat_irqs_cpu(j, i);
>
> Index: b/kernel/irq/handle.c
> ===================================================================
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -445,7 +445,7 @@ void early_init_irq_lock_class(void)
>  unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
>  {
>        struct irq_desc *desc = irq_to_desc(irq);
> -       return desc->kstat_irqs[cpu];
> +       return desc ? desc->kstat_irqs[cpu] : 0;
>  }
>  #endif
>  EXPORT_SYMBOL(kstat_irqs_cpu);
>
>

nice. much clean.

YH
