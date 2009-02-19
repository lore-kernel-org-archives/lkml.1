Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZBSKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZBSKZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZBSKZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:25:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbZBSKZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:25:27 -0500
Date: Thu, 19 Feb 2009 02:24:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Conform L3 Cache Index Disable to Linux standards
Message-Id: <20090219022430.3c682a93.akpm@linux-foundation.org>
In-Reply-To: <200902181604.26991.mark.langsdorf@amd.com>
References: <200902181604.26991.mark.langsdorf@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 16:04:26 -0600 Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> The L3 Cache Index Disable feature to arch/x86/kernel/cpu/intel_cacheinfo.c
> accepted in 2.6.28 was inadvertently a preliminary version of the patch
> that should not have been accepted.  It did not include ABI documentation
> and did not meet the usage standards of a /sys file.
> 
> This patch changes that code to use a proposed patch that had the
> maintainer's approval but was accidentally not accepted.
> 
> It also corrects prevents the patch from being used on AMD processors
> that do not currently support L3 Cache Index Disable.
> 
> ...
>
> +show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
> +{									\
> +	return show_cache_disable(this_leaf, buf, index);		\
> +}
> +
> +static ssize_t
> +store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> +		 size_t count, unsigned int index)
> +{
> +	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	struct pci_dev *dev = k8_northbridges[node];
> +	ssize_t ret = 0;
> +	unsigned int val;
> +
> +	if (!this_leaf->can_disable)
> +		return -EINVAL;
> +
> +	ret = sscanf(buf, "%x", &val);

We permit used input suzh as `42foo'?

strict_strtoul() would fix that.

> +	if (ret != 1)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

It would make sense to do this earlier in the function.

Do we need to do it at all?  File permissions do not suffice?

> +	val |= 0xc0000000;
> +	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
> +	wbinvd();
> +	pci_write_config_dword(dev, 0x1BC + index * 4, val);
> +	return count;
> +}
> +

