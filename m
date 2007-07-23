Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbXGWOyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbXGWOyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXGWOx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:53:57 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:52620 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755291AbXGWOx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:53:56 -0400
Subject: Re: [patch] drivers/scsi/scsi_sysfs.c:718: warning: unused
	variable `rq'
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20070723143637.GB23448@slug>
References: <20070723143637.GB23448@slug>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 09:53:51 -0500
Message-Id: <1185202432.3417.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 16:36 +0200, Frederik Deweerdt wrote:
> -	struct request_queue *rq = sdev->request_queue;
>  
>  	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
>  		return error;
> @@ -736,7 +735,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	 * released by the sdev_class .release */
>  	get_device(&sdev->sdev_gendev);
>  
> -	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
> +	error = bsg_register_queue(sdev->request_queue,
> +				   &sdev->sdev_gendev, NULL);

Actually, that's not really a good fix because the same problem will
reoccur elsewhere.  This is a more correct fix:

James

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index f415f89..2344dab 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -60,8 +60,13 @@ struct bsg_class_device {
 extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-#define bsg_register_queue(disk, dev, name)		(0)
-#define bsg_unregister_queue(disk)	do { } while (0)
+static inline int bsg_register_queue(struct request_queue * rq, struct device *dev, const char *name)
+{
+	return 0;
+}
+static inline void bsg_unregister_queue(struct request_queue *rq)
+{
+}
 #endif
 
 #endif /* __KERNEL__ */


