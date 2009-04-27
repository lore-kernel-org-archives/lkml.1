Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZD0MH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZD0MH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZD0MHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:07:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:42147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbZD0MHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:07:20 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Cleanup: Remove unused __REQ_NR_BITS from enum rq_flag_bits
Date: Mon, 27 Apr 2009 17:35:01 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200904271705.30550.knikanth@suse.de> <20090427114633.GA4593@kernel.dk>
In-Reply-To: <20090427114633.GA4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271735.02007.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009 17:16:33 Jens Axboe wrote:
> On Mon, Apr 27 2009, Nikanth Karthikesan wrote:
> > The __REQ_NR_BITS  was being used by blk_dump_rq_flags() long back, while
> > printing the individual request flag bits as strings to limit to the used
> > bits. But it does not use it now. Remove unused enum.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > ---
> >
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index ba54c83..f41abbb 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -118,7 +118,6 @@ enum rq_flag_bits {
> >  	__REQ_COPY_USER,	/* contains copies of user pages */
> >  	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
> >  	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
> > -	__REQ_NR_BITS,		/* stops here */
> >  };
> >
> >  #define REQ_RW		(1 << __REQ_RW)
>
> Lets turn it into something useful instead. It's meant to catch someone
> adding too many flags, how about something like this:
>
> Untested ;-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index d73eb76..e62ef94 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2159,6 +2159,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>
>  int __init blk_dev_init(void)
>  {
> +	BUILD_BUG_ON(__REQ_NR_BITS > 8 * sizeof(int));
> +
>  	kblockd_workqueue = create_workqueue("kblockd");
>  	if (!kblockd_workqueue)
>  		panic("Failed to create kblockd\n");

Good idea. How about this?

Thanks
Nikanth

Catch trying to use more bits than request->cmd_flags has.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..218f745 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2156,6 +2156,9 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 
 int __init blk_dev_init(void)
 {
+	BUILD_BUG_ON(__REQ_NR_BITS > 8 * 
+			sizeof(((struct request *)0)->cmd_flags));
+
 	kblockd_workqueue = create_workqueue("kblockd");
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");


