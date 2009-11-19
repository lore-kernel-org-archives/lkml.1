Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZKSSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZKSSwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZKSSwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:52:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38400 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZKSSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VztlnRFcb040f5Fr3KNgVsZ1Qvh4cI9IZn/4rnWzh0TrW9uCrBGLeGqi+yXU9jQC0p
         BQ7VaLbz0ZkQV81ALdtmT9XPLR/R9u12ItrKZfjpSPKYJIN/RJw48rHu1bYgsccOy0s7
         24C4K4CqGf9ZebUNwoYuaI6mlN+UQlCYAvJh4=
Date: Thu, 19 Nov 2009 21:50:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [tip:irq/core] genirq: switch /proc/irq/*/spurious to seq_file
Message-ID: <20091119185056.GA29223@x200.localdomain>
References: <20090828181743.GA14050@x200.localdomain>
 <tip-a1afb6371bb5341057056194d1168753f6d77242@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a1afb6371bb5341057056194d1168753f6d77242@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 11:54:34AM +0000, tip-bot for Alexey Dobriyan wrote:
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -148,18 +148,28 @@ static const struct file_operations default_affinity_proc_fops = {
>  };
>  #endif
>  
> -static int irq_spurious_read(char *page, char **start, off_t off,
> -				  int count, int *eof, void *data)
> +static int irq_spurious_proc_show(struct seq_file *m, void *v)
>  {
> -	struct irq_desc *desc = irq_to_desc((long) data);
> -	return sprintf(page, "count %u\n"
> -			     "unhandled %u\n"
> -			     "last_unhandled %u ms\n",
> -			desc->irq_count,
> -			desc->irqs_unhandled,
> -			jiffies_to_msecs(desc->last_unhandled));
> +	struct irq_desc *desc = irq_to_desc((long) m->private);
						   ^^^^^^^^^^
> +
> +	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
> +		   desc->irq_count, desc->irqs_unhandled,
> +		   jiffies_to_msecs(desc->last_unhandled));
> +	return 0;
> +}
> +
> +static int irq_spurious_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, irq_spurious_proc_show, NULL);

Oops, there has to be PDE(inode)->data instead of NULL.
