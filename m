Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYELW3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYELW3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYELW25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:28:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175AbYELW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:28:54 -0400
Date: Mon, 12 May 2008 15:27:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Abdel Benamrouche <draconux@gmail.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org, trivial@kernel.org,
       draconux@gmail.com
Subject: Re: [PATCH] /fs/partition/check.c: fix return value warning
Message-Id: <20080512152743.3c6b8adc.akpm@linux-foundation.org>
In-Reply-To: <1210419653-19234-1-git-send-email-draconux@gmail.com>
References: <1210419653-19234-1-git-send-email-draconux@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 13:40:53 +0200
Abdel Benamrouche <draconux@gmail.com> wrote:

> fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
>  declared with attribute warn_unused_result
> 
> Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
> ---
> :100644 100644 6149e4b... 7a87fad... M	fs/partitions/check.c
>  fs/partitions/check.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 6149e4b..7a87fad 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -378,7 +378,13 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>  
>  	/* delay uevent until 'holders' subdir is created */
>  	p->dev.uevent_suppress = 1;
> -	device_add(&p->dev);
> +	if (device_add(&p->dev)) {
> +		put_device(&p->dev);
> +		free_part_stats(p);
> +		kfree(p);
> +		return;
> +	}
> +
>  	partition_sysfs_add_subdir(p);
>  	p->dev.uevent_suppress = 0;
>  	if (flags & ADDPART_FLAG_WHOLEDISK)

We should go further than this.  add_partition() just drops the error
on the floor.  It should be propagated back to callers, and callers
should be modified to handle it appropriately.

Presumably we should also handle a device_create_file() failure as well
- that is presently being silently ignored.

