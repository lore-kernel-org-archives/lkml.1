Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZIDMGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZIDMGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZIDMGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:06:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43973 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbZIDMGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:06:10 -0400
Date: Fri, 4 Sep 2009 14:06:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data v2
Message-ID: <20090904120611.GW18599@kernel.dk>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz> <20090904115858.GT18599@kernel.dk> <20090904120407.GV18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904120407.GV18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Jens Axboe wrote:
> +static long wb_check_old_data_flush(struct bdi_writeback *wb)
> +{
> +	unsigned long expired;
> +	long nr_pages;
> +
> +	expired = wb->last_old_flush +
> +			msecs_to_jiffies(dirty_writeback_interval * 10);
> +	if (time_before(jiffies, expired))
> +		return 0;
> +
> +	nr_pages = global_page_state(NR_FILE_DIRTY) +
> +			global_page_state(NR_UNSTABLE_NFS) +
> +			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +
> +	return wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
> +}

Needs to set ->last_old_flush of course. I also made it check for
nr_pages > 0 before calling into wb_writeback().

-- 
Jens Axboe

