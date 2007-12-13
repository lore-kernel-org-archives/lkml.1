Return-Path: <linux-kernel-owner+w=401wt.eu-S1764179AbXLMRMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764179AbXLMRMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbXLMRMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:12:45 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37666 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXLMRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:12:45 -0500
Date: Thu, 13 Dec 2007 09:07:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 7/8] Enhanced partition statistics: procfs
Message-Id: <20071213090756.73de4e3e.randy.dunlap@oracle.com>
In-Reply-To: <47615B3C.6030404@redhat.com>
References: <47615B3C.6030404@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 17:18:04 +0100 Jerome Marchand wrote:

> Reports enhanced partition statistics in /proc/diskstats.

> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  genhd.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/block/genhd.c linux-2.6/block/genhd.c
> --- linux-2.6.orig/block/genhd.c	2007-12-04 17:37:31.000000000 +0100
> +++ linux-2.6/block/genhd.c	2007-12-05 13:52:55.000000000 +0100
> @@ -655,12 +655,27 @@ static int diskstats_show(struct seq_fil
>  	for (n = 0; n < gp->minors - 1; n++) {
>  		struct hd_struct *hd = gp->part[n];
>  
> -		if (hd && hd->nr_sects)
> -			seq_printf(s, "%4d %4d %s %u %u %u %u\n",
> -				gp->major, n + gp->first_minor + 1,
> -				disk_name(gp, n + 1, buf),
> -				hd->ios[0], hd->sectors[0],
> -				hd->ios[1], hd->sectors[1]);
> +		if (!hd || !hd->nr_sects) continue;

Don't put if () and following statement on same line.

> +
> +		preempt_disable();
> +		part_round_stats(hd);
> +		preempt_enable();
> +		seq_printf(s, "%4d %4d %s %lu %lu %llu "
> +			   "%u %lu %lu %llu %u %u %u %u\n",
> +			   gp->major, n + gp->first_minor + 1,
> +			   disk_name(gp, n + 1, buf),
> +			   part_stat_read(hd, ios[0]),
> +			   part_stat_read(hd, merges[0]),
> +			   (unsigned long long)part_stat_read(hd, sectors[0]),
> +			   jiffies_to_msecs(part_stat_read(hd, ticks[0])),
> +			   part_stat_read(hd, ios[1]),
> +			   part_stat_read(hd, merges[1]),
> +			   (unsigned long long)part_stat_read(hd, sectors[1]),
> +			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
> +			   hd->in_flight,
> +			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
> +			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
> +			);
>  	}
>   
>  	return 0;
> 
> --

The format of the /proc file is not changed except to add data
at the end of each line.  Is that correct?

---
~Randy
