Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZINLKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZINLKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZINLKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:10:19 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:33084 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZINLKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=rkINxOTTp5axQCggYjYxAME+0fJJVHaEfuSS8aYw1Ic8mtoAZ8Ncv57lrmo+xI6bjJ
         tLMlXUaWx5WIxukzWAN94V22hXaYg5DaJ5FsedT+DCMm7dV4VMjTt5NkBDP+fASLmtmk
         89NkUwr1BKyV6djk5NGWki8niJ+ILOUxy2ZY8=
Date: Mon, 14 Sep 2009 20:10:02 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 4/7] writeback: use RCU to protect bdi_list
Message-Id: <20090914201002.0ca94166.minchan.kim@barrios-desktop>
In-Reply-To: <1252920994-11141-5-git-send-email-jens.axboe@oracle.com>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
	<1252920994-11141-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 11:36:31 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Now that bdi_writeback_all() no longer handles integrity writeback,
> it doesn't have to block anymore. This means that we can switch
> bdi_list reader side protection to RCU.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c           |    4 +-
>  include/linux/backing-dev.h |    1 +
>  mm/backing-dev.c            |   76 +++++++++++++++++++++++++++++++------------
>  mm/page-writeback.c         |    8 ++--
>  4 files changed, 62 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 5d4bd1c..d7592c7 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -849,7 +849,7 @@ static void bdi_writeback_all(struct writeback_control *wbc)
>  
>  	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
>  
> -	spin_lock(&bdi_lock);
> +	rcu_read_lock();
>  
>  	list_for_each_entry(bdi, &bdi_list, bdi_list) {

list_for_each_entry_rcu?

-- 
Kind regards,
Minchan Kim
