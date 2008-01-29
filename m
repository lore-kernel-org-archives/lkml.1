Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYA2Vyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYA2Vyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbYA2VyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:54:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758677AbYA2VyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:54:22 -0500
Date: Tue, 29 Jan 2008 13:54:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: raise max number of nbd devices to 1024
Message-Id: <20080129135417.e20b8107.akpm@linux-foundation.org>
In-Reply-To: <479F9B12.8010207@steeleye.com>
References: <479F9B12.8010207@steeleye.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 16:30:58 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> The limit was 128. This changes it to 1024.
> 

Please include the "why" in changelogs as well as the "what".  It's fairly
easy to guess why this needs to be increased, but it would be useful and
interesting to hear about the operational scenarios in which 128 was
insufficient.

> 
> --- ./include/linux/nbd.h.TIMEOUT	2007-08-22 13:18:12.000000000 -0400
> +++ ./include/linux/nbd.h	2008-01-29 14:35:17.000000000 -0500
> @@ -35,7 +35,7 @@ enum {
>  };
>  
>  #define nbd_cmd(req) ((req)->cmd[0])
> -#define MAX_NBD 128
> +#define MAX_NBD 1024
>  
>  /* userspace doesn't need the nbd_device structure */
>  #ifdef __KERNEL__
> 

But one still needs to specify the nbds_max module parameter.

Can't we just nuke MAX_NBD altogether?


--- a/drivers/block/nbd.c~a
+++ a/drivers/block/nbd.c
@@ -54,7 +54,7 @@ static unsigned int debugflags;
 #endif /* NDEBUG */
 
 static unsigned int nbds_max = 16;
-static struct nbd_device nbd_dev[MAX_NBD];
+static struct nbd_device *nbd_dev;
 
 /*
  * Use just one lock (or at most 1 per NIC). Two arguments for this:
@@ -651,12 +651,6 @@ static int __init nbd_init(void)
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
-	if (nbds_max > MAX_NBD) {
-		printk(KERN_CRIT "nbd: cannot allocate more than %u nbds; %u requested.\n", MAX_NBD,
-				nbds_max);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1);
 		if (!disk)
@@ -715,6 +709,10 @@ out:
 static void __exit nbd_cleanup(void)
 {
 	int i;
+
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = nbd_dev[i].disk;
 		nbd_dev[i].magic = 0;
diff -puN include/linux/nbd.h~a include/linux/nbd.h
--- a/include/linux/nbd.h~a
+++ a/include/linux/nbd.h
@@ -35,7 +35,6 @@ enum {
 };
 
 #define nbd_cmd(req) ((req)->cmd[0])
-#define MAX_NBD 128
 
 /* userspace doesn't need the nbd_device structure */
 #ifdef __KERNEL__
_


much nicer?

