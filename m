Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYIRLwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYIRLwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIRLwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:52:07 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45346 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYIRLwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:52:06 -0400
X-Greylist: delayed 5570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 07:52:06 EDT
Date: Thu, 18 Sep 2008 12:06:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add sysctl from printk_tag
Message-ID: <20080918100621.GA19499@elte.hu>
References: <1221725137-21947-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221725137-21947-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> under /proc/sys/kernel/printk_tag/ will have acpi, apic, dev, pci

nice!

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  init/main.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -63,6 +63,8 @@
>  #include <linux/idr.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/ftrace.h>
> +#include <linux/sysctl.h>
> +#include <linux/proc_fs.h>
>  
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -395,6 +397,60 @@ static int __init quiet_kernel(char *str
>  early_param("debug", debug_kernel);
>  early_param("quiet", quiet_kernel);
>  
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table printk_tag_ctl_dir[] = {
> +        {
> +                .procname       = "printk_tag",
> +                .mode           = 0555,
> +        },
> +        {0, },
> +};
> +
> +static struct ctl_table printk_tag_ctl_root[] = {
> +        {
> +                .ctl_name       = CTL_KERN,
> +                .procname       = "kernel",
> +                .mode           = 0555,
> +                .child          = printk_tag_ctl_dir,
> +        },
> +        {0, },
> +};
> +
> +static int __init proc_printk_tag_init(void)
> +{
> +        int i;
> +        struct ctl_table *entry;
> +        char buf[32];

magic constant.

> +		strncpy(buf, tag_level[i].name, len - 1);
> +                entry->procname = kstrdup(buf, GFP_KERNEL);
> +		entry->data = &tag_level[i].level;
> +		entry->maxlen = sizeof(tag_level[i].level);
> +                entry->mode = 0644;
> +		entry->proc_handler = proc_dointvec;
> +                entry++;
> +        }

hm, whitespace damage in every second line.

	Ingo
