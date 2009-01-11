Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZAKHB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZAKHB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZAKHBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:01:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:12085 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZAKHBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NwapmQYLfosWrIBGgtNuMWEDU6+K284WQq/UqlZCCSjXPr4qx0qUuX6lkR8efJwWhe
         vVkkP/9RpkT3NDjmBcipOGdLX4uEvUhs1VFMKCMrg1TRxP5sJcX4TNkaNT6035177Zzp
         9LpX6OtiffPliZv7GABZeeHxdGIggiog5gipA=
Message-ID: <86802c440901102301n5a7bb98ajd44a31ab32ddb726@mail.gmail.com>
Date: Sat, 10 Jan 2009 23:01:16 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable sized
Cc: "Ingo Molnar" <mingo@redhat.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jack Steiner" <steiner@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090110223819.033438000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
	 <20090110223819.033438000@polaris-admin.engr.sgi.com>
X-Google-Sender-Auth: 1d74718d5ff341c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 2:38 PM, Mike Travis <travis@sgi.com> wrote:
> Impact: reduce memory usage.
>
> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
> memory usage bump when NR_CPUS bumped from 128 to 4096:
>
>     8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
>
> This is only when CONFIG_SPARSE_IRQS=y.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/irq/handle.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
> +++ linux-2.6-for-ingo/kernel/irq/handle.c
> @@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
>        }
>  };
>
> -/* FIXME: use bootmem alloc ...*/
> -static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> +static unsigned int *kstat_irqs_legacy;
>
>  int __init early_irq_init(void)
>  {
> @@ -146,9 +145,13 @@ int __init early_irq_init(void)
>        /* allocate irq_desc_ptrs array based on nr_irqs */
>        irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
>
> +       /* allocate based on nr_cpu_ids */
> +       kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
> +                                         sizeof(int));
> +
>        for (i = 0; i < legacy_count; i++) {
>                desc[i].irq = i;
> -               desc[i].kstat_irqs = kstat_irqs_legacy[i];
> +               desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;

here should be

+               desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;

YH
