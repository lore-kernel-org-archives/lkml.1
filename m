Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0BIUQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:16:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851Ab0BIUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:16:10 -0500
Date: Tue, 9 Feb 2010 12:15:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 21/35] x86: move back find_e820_area to e820.c
Message-Id: <20100209121528.f3a85b74.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-22-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-22-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:32 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

>  /*
> + * Find a free area with specified alignment in a specific range.
> + */
> +u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
> +{
> +	int i;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +		u64 addr;
> +		u64 ei_start, ei_last;
> +
> +		if (ei->type != E820_RAM)
> +			continue;
> +
> +		ei_last = ei->addr + ei->size;
> +		ei_start = ei->addr;
> +		addr = find_early_area(ei_start, ei_last, start, end,
> +					 size, align);
> +
> +		if (addr == -1ULL)
> +			continue;
> +
> +		return addr;

Small simplification:

		if (addr != -1)
			return addr;

> +	}
> +	return -1ULL;
> +}
> +
> +/*
> + * Find next free range after *start
> + */
> +u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
> +{
> +	int i;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +		u64 addr;
> +		u64 ei_start, ei_last;
> +
> +		if (ei->type != E820_RAM)
> +			continue;
> +
> +		ei_last = ei->addr + ei->size;
> +		ei_start = ei->addr;
> +		addr = find_early_area_size(ei_start, ei_last, start,
> +					 sizep, align);
> +
> +		if (addr == -1ULL)
> +			continue;
> +
> +		return addr;

Ditto.

> +	}
> +
> +	return -1ULL;
> +}
