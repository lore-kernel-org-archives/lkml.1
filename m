Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYDCTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYDCTy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYDCTys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:54:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbYDCTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:54:47 -0400
Date: Thu, 3 Apr 2008 12:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerlof Langeveld <gerlof@ATComputing.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] accounting: task counters for disk/network
Message-Id: <20080403125416.ead5cd38.akpm@linux-foundation.org>
In-Reply-To: <20080402073037.GA8419@atcmpg.ATComputing.nl>
References: <20080402073037.GA8419@atcmpg.ATComputing.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 09:30:37 +0200
Gerlof Langeveld <gerlof@ATComputing.nl> wrote:

> 
> From: Gerlof Langeveld <gerlof@atcomputing.nl>

You sent three different patches, all with the same title.  Please don't do
that - choose unique, suitable and meaningful titles for each patch.

> Proper performance analysis requires the availability of system level
> and process level counters for CPU, memory, disk and network utilization.
> The current kernel offers the system level counters, however process level
> counters are only (sufficiently) available for CPU and memory utilization.
> 
> The kernel feature "task I/O accounting" currently maintains
> per process counters for the number of bytes transferred to/from disk.
> These counters are available via /proc/pid/io. It is still not possible
> to find out which process issues the physical disk transfer. Besides,
> not *all* disk transfers are accounted to processes (e.g. swap-transfers
> by kswapd, journaling transfers).
> 
> This patch extends "task I/O accounting" by counting real *physical*
> disk transfers per process and by counting IPv4/IPv6 socket transfers
> per process.
> The modified output generated for /proc/pid/io will be as follows:
> 
>   $ cat /proc/3179/io

/proc/pid/io is not the primary interface for this sort of accounting - it
was just tossed in there as an afterthought because it wasy easy.

This sort of accounting should be delivered across taskstats and
Documentation/accounting/getdelays.c should be suitably updated.

> --- linux-2.6.24.4-vanilla/block/ll_rw_blk.c	2008-03-24 19:49:18.000000000 +0100
> +++ linux-2.6.24.4-modified/block/ll_rw_blk.c	2008-03-25 13:52:14.000000000 +0100
> @@ -2739,6 +2739,19 @@ static void drive_stat_acct(struct reque
>  		disk_round_stats(rq->rq_disk);
>  		rq->rq_disk->in_flight++;
>  	}
> +
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +	switch (rw) {
> +	case READ:
> +		current->group_leader->ioac.dsk_rio += new_io;
> +		current->group_leader->ioac.dsk_rsz += rq->nr_sectors;
> +		break;
> +	case WRITE:
> +		current->group_leader->ioac.dsk_wio += new_io;
> +		current->group_leader->ioac.dsk_wsz += rq->nr_sectors;
> +		break;
> +	}
> +#endif

For many workloads, this will cause almost all writeout to be accounted to
pdflush and perhaps kswapd.  This makes the per-task write accounting
largely unuseful.

