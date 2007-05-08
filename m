Return-Path: <linux-kernel-owner+w=401wt.eu-S1032646AbXEHXLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032646AbXEHXLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969701AbXEHXLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:11:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38039 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969695AbXEHXLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:11:05 -0400
Message-ID: <46410380.2060906@garzik.org>
Date: Tue, 08 May 2007 19:10:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Monakhov Dmitriy <dmonakhov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: floppy: handle device_create_file() failure while init
References: <200705081900.l48J0kiv005844@hera.kernel.org>
In-Reply-To: <200705081900.l48J0kiv005844@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4ea1b0f4c4f656e0838a937c47be9544ed1c5118
> Commit:     4ea1b0f4c4f656e0838a937c47be9544ed1c5118
> Parent:     6de2d20235a2b8c751d39ec4b68347d66b19d815
> Author:     Dmitriy Monakhov <dmonakhov@sw.ru>
> AuthorDate: Tue May 8 00:25:58 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Tue May 8 11:15:02 2007 -0700
> 
>     floppy: handle device_create_file() failure while init
>     
>     This patch kills the "ignoring return value of 'device_create_file'"
>     warning message.
>     
>     Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/block/floppy.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 5231ed7..3587cb4 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4334,7 +4334,10 @@ static int __init floppy_init(void)
>  		if (err)
>  			goto out_flush_work;
>  
> -		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> +		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> +		if (err)
> +			goto out_unreg_platform_dev;
> +
>  		/* to be cleaned up... */
>  		disks[drive]->private_data = (void *)(long)drive;
>  		disks[drive]->queue = floppy_queue;
> @@ -4345,6 +4348,8 @@ static int __init floppy_init(void)
>  
>  	return 0;
>  
> +out_unreg_platform_dev:
> +	platform_device_unregister(&floppy_device[drive]);
>  out_flush_work:
>  	flush_scheduled_work();
>  	if (usage_count)


This patch appears to leave things in a half-initialized state, upon error.

That's the big reason why I did not bother with this warning, it's not 
the low-hanging fruit it appears to be.

	Jeff


