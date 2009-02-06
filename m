Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZBFWAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZBFWAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZBFWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:00:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbZBFWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:00:25 -0500
Date: Fri, 6 Feb 2009 14:00:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: clear kstat_irqs
Message-Id: <20090206140005.44b4bb50.akpm@linux-foundation.org>
In-Reply-To: <498CB0B7.8030009@kernel.org>
References: <498CB0B7.8030009@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 13:50:47 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> +void clear_kstat_irqs(struct irq_desc *desc)
> +{
> +	unsigned long bytes;

size_t would be more formally correct.

> +	char *ptr;
> +
> +	ptr = (char *)desc->kstat_irqs;
> +	/* Compute how many bytes we need to clear */
> +	bytes = nr_cpu_ids * sizeof(unsigned int);

This is fragile.  For example, if someone changes ->kstat_irqs to long
then this code will secretly and subtly break.

If it used sizeof(*(desc->kstat_irqs)) then everything would magically
continue to work.

> +	memset(ptr, 0, bytes);
> +}

The whole function could be written as

	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));

