Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZDQQVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZDQQVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZDQQV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:21:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZDQQV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:21:28 -0400
Date: Fri, 17 Apr 2009 18:21:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: jbarnes@virtuousgeek.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090417162115.GF8253@elte.hu>
References: <20090417100155.GE16198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417100155.GE16198@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index a7eb1b4..9360f3d 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -74,7 +74,11 @@ static ssize_t local_cpus_show(struct device *dev,
>  	const struct cpumask *mask;
>  	int len;
>  
> +#ifdef CONFIG_NUMA
> +	mask = cpumask_of_node(dev_to_node(dev));
> +#else
>  	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
> +#endif
>  	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
>  	buf[len++] = '\n';
>  	buf[len] = '\0';
> @@ -88,7 +92,11 @@ static ssize_t local_cpulist_show(struct device *dev,
>  	const struct cpumask *mask;
>  	int len;
>  
> +#ifdef CONFIG_NUMA
> +	mask = cpumask_of_node(dev_to_node(dev));
> +#else
>  	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
> +#endif

No objections against the change (at all), but this pattern cries 
out for a different, cleaner solution.

Shouldnt there be a cpumask_of_pcidev(dev) helper instead, which 
[recognizing that most PCI devices dont get their node info 
initialized in practice] would do something like:

const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
{
	if (dev->numa_node == -1)
		return cpumask_of_pcibus(to_pci_dev(dev)->bus);

	return cpumask_of_node(dev_to_node(dev));
}

? This would work fine in all cases.

Which you could thus use in both cases above, cleanly.

	Ingo
