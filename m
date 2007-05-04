Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXEDGP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXEDGP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXEDGP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:15:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbXEDGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:15:26 -0400
Date: Thu, 3 May 2007 23:14:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: steve@chygwyn.com, pavel@ucw.cz, Paul.Clements@steeleye.com,
       linux-kernel@vger.kernel.org, Wang Ya-gang <lazy_linux@126.com>,
       Chen Li-jun <cljun@xiyou.edu.cn>
Subject: Re: [-mm Patch]nbd: check the return value of sysfs_create_file
Message-Id: <20070503231450.93b4d417.akpm@linux-foundation.org>
In-Reply-To: <20070428053023.GA2578@localhost.localdomain>
References: <20070428053023.GA2578@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 13:30:23 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Since 'sysfs_create_file' is declared with attribute warn_unused_result, we must always check its return value carefully.
> 

Well that's not really the reason for your patch.

warn_unused_result is there to tell us that there are deeper problems in
the code which need addressing: the failure to check the
sysfs_create_file() return value means that bugs in the kernel can remain
undetected, or can be harder to find.

> 
> ---
> 
> --- linux-2.6.21-rc7-mm2/drivers/block/nbd.c.orig	2007-04-27 17:27:47.000000000 +0800
> +++ linux-2.6.21-rc7-mm2/drivers/block/nbd.c	2007-04-27 17:47:32.000000000 +0800
> @@ -373,7 +373,10 @@ static void nbd_do_it(struct nbd_device 
>  	BUG_ON(lo->magic != LO_MAGIC);
>  
>  	lo->pid = current->pid;
> -	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
> +	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
> +		printk(KERN_ERR "nbd: sysfs_create_file failed!");
> +		return;
> +	}
>  
>  	while ((req = nbd_read_stat(lo)) != NULL)
>  		nbd_end_request(req);

It would better saner to propagate this error back through callers:

--- a/drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file-fix
+++ a/drivers/block/nbd.c
@@ -366,23 +366,25 @@ static struct disk_attribute pid_attr = 
 	.show = pid_show,
 };
 
-static void nbd_do_it(struct nbd_device *lo)
+static int nbd_do_it(struct nbd_device *lo)
 {
 	struct request *req;
+	int ret;
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
-		return;
+		return ret;
 	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
 	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
-	return;
+	return 0;
 }
 
 static void nbd_clear_que(struct nbd_device *lo)
@@ -572,7 +574,9 @@ static int nbd_ioctl(struct inode *inode
 	case NBD_DO_IT:
 		if (!lo->file)
 			return -EINVAL;
-		nbd_do_it(lo);
+		error = nbd_do_it(lo);
+		if (error)
+			return error;
 		/* on return tidy up in case we have a signal */
 		/* Forcibly shutdown the socket causing all listeners
 		 * to error
_

