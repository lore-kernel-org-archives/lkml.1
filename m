Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYKUSGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYKUSGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYKUSGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:06:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:53379 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYKUSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:06:33 -0500
Date: Fri, 21 Nov 2008 10:06:33 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/3] proc: Export statistics for softirq to /proc
Message-Id: <20081121100633.ff237ae0.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081120210923.cfb90561.akpm@linux-foundation.org>
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
	<20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp>
	<20081120210923.cfb90561.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.

> > +
> > +/*
> > + * /proc/softirqs  ... display the number of softirqs
> > + */
> > +static int show_softirqs(struct seq_file *p, void *v)
> > +{
> > +	int i, j;
> > +
> > +	seq_printf(p, "                ");
> > +	for_each_online_cpu(i)
> > +		seq_printf(p, "CPU%-8d", i);
> > +	seq_printf(p, "\n");
> > +
> > +	for_each_softirq_nr(i) {
> > +		seq_printf(p, "%-10s", desc_array[i]);
> > +		for_each_online_cpu(j)
> > +			seq_printf(p, "%10u ", kstat_softirqs_cpu(i, j));
> > +		seq_printf(p, "\n");
> > +	}
> > +	return 0;
> > +}
> 
> This uses for_each_online_cpu(), but below we use for_each_possible_cpu().
> 
> Shouldn't we be consistent here so that at least the numbers will add
> up to the same thing?
> 
> Probably for_each_possible_cpu() is best - people might want to see how
> many softirqs happened on a CPU which was recently offlined.

OK. I'll look into this point.

> > +
> > +static int softirqs_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, show_softirqs, NULL);
> > +}
> > +
> > +static struct file_operations proc_softirqs_operations = {
> 
> Make this const, please.
> 
> > +	.open		= softirqs_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= single_release,
> > +};
> > +
> > +static int __init proc_softirqs_init(void)
> > +{
> > +	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
> > +	return 0;
> > +}
> > +module_init(proc_softirqs_init);
> > diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> > index 81904f0..02d5bf8 100644
> > --- a/fs/proc/stat.c
> > +++ b/fs/proc/stat.c
> > @@ -25,6 +25,7 @@ static int show_stat(struct seq_file *p, void *v)
> >  	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
> >  	cputime64_t guest;
> >  	u64 sum = 0;
> > +	u64 sum_softirq = 0;
> >  	struct timespec boottime;
> >  	unsigned int per_irq_sum;
> >  
> > @@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p, void *v)
> >  			sum += kstat_irqs_cpu(j, i);
> >  
> >  		sum += arch_irq_stat_cpu(i);
> > +
> > +		for_each_softirq_nr(j)
> > +			sum_softirq += kstat_softirqs_cpu(j, i);
> > +
> >  	}
> >  	sum += arch_irq_stat();
> >  
> > @@ -111,6 +116,18 @@ static int show_stat(struct seq_file *p, void *v)
> >  		nr_running(),
> >  		nr_iowait());
> >  
> > +	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
> > +
> > +	for_each_softirq_nr(i) {
> > +		per_irq_sum = 0;
> > +
> > +		for_each_possible_cpu(j)
> > +			per_irq_sum += kstat_softirqs_cpu(i, j);
> > +
> > +		seq_printf(p, " %u", per_irq_sum);
> > +	}
> > +	seq_printf(p, "\n");
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> > index f58a0cf..9a12ba0 100644
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -259,6 +259,9 @@ enum
> >  	NR_SOFTIRQS
> >  };
> >  
> > +#define for_each_softirq_nr(irq)		\
> > +	for (irq = 0; irq < NR_SOFTIRQS; irq++)
> 
> Can we remove this please?  It doesn't make the code any more readable.
> Just open-code the loop at each site.
> 
> (And strictly speaking the `irq' macro arg should be parenthesised)

I agree with you.
I'll remove this definition.

Later, I'll post v2.
