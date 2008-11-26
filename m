Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYKZKKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYKZKKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYKZKKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:10:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48700 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKZKKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:10:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com
In-Reply-To: <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp> <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20081126190603.3CC3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 26 Nov 2008 19:10:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nit

> @@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p, void *v)
>  			sum += kstat_irqs_cpu(j, i);
>  
>  		sum += arch_irq_stat_cpu(i);
> +
> +		for (j = 0; j < NR_SOFTIRQS; j++)
> +			sum_softirq += kstat_softirqs_cpu(j, i);
> +
>  	}

You can calcurate per_irq_sum here.
Typically, # of possible cpu are very big.

So, I don't like unnecessary twrice looping.


>  	sum += arch_irq_stat();
>  
> @@ -111,6 +116,18 @@ static int show_stat(struct seq_file *p, void *v)
>  		nr_running(),
>  		nr_iowait());
>  
> +	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
> +
> +	for (i = 0; i < NR_SOFTIRQS; i++) {
> +		per_irq_sum = 0;
> +
> +		for_each_possible_cpu(j)
> +			per_irq_sum += kstat_softirqs_cpu(i, j);
> +
> +		seq_printf(p, " %u", per_irq_sum);
> +	}
> +	seq_printf(p, "\n");
> +
>  	return 0;
>  }


