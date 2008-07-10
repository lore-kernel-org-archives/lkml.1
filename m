Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYGJCZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYGJCZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYGJCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:24:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbYGJCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:24:57 -0400
Date: Wed, 9 Jul 2008 19:18:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 23/34] AMD IOMMU: add functions to find IOMMU device
 resources
Message-Id: <20080709191827.dbdfcd96.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-24-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:59 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds functions necessary to find the IOMMU resources for a specific
> device.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   75 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 75 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index c43d15d..47e80b5 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -461,3 +461,78 @@ free_dma_dom:
>  	return NULL;
>  }
>  
> +static struct protection_domain *domain_for_device(u16 devid)
> +{
> +	struct protection_domain *dom;
> +	unsigned long flags;
> +
> +	read_lock_irqsave(&amd_iommu_devtable_lock, flags);

Why is this cheerfully undocumented lock irq-safe?  Is it ever taken from
IRQ context?

> +	dom = amd_iommu_pd_table[devid];
> +	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
> +
> +	return dom;
> +}

The locking in this function makes no sense.  We drop the lock then return
a value which the caller cannot use in a race-free fashion, because the
lock is no longer held.


