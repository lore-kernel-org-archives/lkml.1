Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZALXxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZALXxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZALXx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:53:28 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:4383 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZALXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hDWBuoX1lvC7JoeBLKpTANA1O1C1ojeDm7dAUbaA00baErfgynF+4JOTU9j7A8ylYg
         NaBHkzlj3zKxi6/TtVM3O2V6uuhVSJLpAgC93QpodDJLUj+AjcGK1lm87CdT94pQkZFQ
         XUCNn9GoYUKfElf5iFepqZdV7mhr4RZcC3C+0=
Message-ID: <51c5bc110901121553s81a34a6j7771efa9682b2d8b@mail.gmail.com>
Date: Mon, 12 Jan 2009 15:53:25 -0800
From: kobayashi.kk@ncos.nec.co.jp
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <20090112204059.27A8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <51c5bc110901101022g1fc407f6ifc37aa93580a2da1@mail.gmail.com>
	 <2f11576a0901101144y66c072e9w5da6bde9d000e907@mail.gmail.com>
	 <20090112204059.27A8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 79f58431679c70db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> >>> You can calcurate per_irq_sum here.
>> >>> Typically, # of possible cpu are very big.
>> >>>
>> >>> So, I don't like unnecessary twrice looping.
>> >>
>> >> I was about to send these patches to Linus, but it seems that this
>> >> optmisation hasn't been addressed?
>> >
>> > Thanks for your notice, Andrew.
>> > Of course, thanks for your advice, Kosaki-san.
>> > I didn't check carefully about this point...
>> >
>> > Now I am on a business trip.
>> > So, I'll post the fix next week.
>>
>> No problem.
>> I've made it three hour ago. I'll post soon.
>
> Done.
>
>
> ==
> Subject: [PATCH] proc: remove redundunt for_each_possible_cpu() loop
> Impact: cleanup
>
> Almost distro set NR_CPUS very large number and at that time for_each_possible_cpu() is
> a bit costly.
>
> Therefore, To remove unnecessary twice loop is better.
>
>
> Note. we can remove softirq's redundunt loop, but we can't remove irq's.
> because NR_SOFTIRQS ~= 10, NR_IRQS ~= 4000 (in x86 case).
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/proc/stat.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index f95d73a..cb839e8 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -27,6 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
>        cputime64_t guest;
>        u64 sum = 0;
>        u64 sum_softirq = 0;
> +       unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
>        struct timespec boottime;
>        unsigned int per_irq_sum;
>
> @@ -51,8 +52,12 @@ static int show_stat(struct seq_file *p, void *v)
>                }
>                sum += arch_irq_stat_cpu(i);
>
> -               for (j = 0; j < NR_SOFTIRQS; j++)
> -                       sum_softirq += kstat_softirqs_cpu(j, i);
> +               for (j = 0; j < NR_SOFTIRQS; j++) {
> +                       unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
> +
> +                       per_softirq_sums[j] += softirq_stat;
> +                       sum_softirq += softirq_stat;
> +               }
>
>        }
>        sum += arch_irq_stat();
> @@ -118,12 +123,7 @@ static int show_stat(struct seq_file *p, void *v)
>        seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
>
>        for (i = 0; i < NR_SOFTIRQS; i++) {
> -               per_irq_sum = 0;
> -
> -               for_each_possible_cpu(j)
> -                       per_irq_sum += kstat_softirqs_cpu(i, j);
> -
> -               seq_printf(p, " %u", per_irq_sum);
> +               seq_printf(p, " %u", per_softirq_sums[i]);
>        }
>        seq_printf(p, "\n");
>

Thank you very much, Kosaki-san!
It looks good to me.

// Keika Kobayashi
