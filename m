Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYHYWRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYHYWRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYHYWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:17:07 -0400
Received: from [198.99.130.12] ([198.99.130.12]:47606 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYHYWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:17:05 -0400
Date: Mon, 25 Aug 2008 18:11:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: UML Reboot Panic
Message-ID: <20080825221145.GD12626@c2.user-mode-linux.org>
References: <7b9198260808241349v45c4d5ffjd908c7ffe34286a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260808241349v45c4d5ffjd908c7ffe34286a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 09:49:15PM +0100, Tom Spink wrote:
> When using UML with a UML block device, and issuing a reboot, I was
> getting a kernel panic on the next kernel startup because UML was
> unable to open the file mapped to the UBD. 

The crash was because the attempt to get a file lock failed?

> I think this is because
> the file is not closed when the UBD is released, and the following
> patch appears to resolve this issue.

Looks right to me.

>  I'm not sure if it's the right
> fix, as I may have missed something, but it works for me.

That's slightly nasty - try the patch below.

       		      	    Jeff

-- 
Work email - jdike at linux dot intel dot com


Index: linux-2.6.22/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/ubd_kern.c	2008-06-12 11:56:19.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/ubd_kern.c	2008-08-25 18:09:35.000000000 -0400
@@ -722,6 +722,9 @@ static int create_cow_file(char *cow_fil
 
 static void ubd_close_dev(struct ubd *ubd_dev)
 {
+	if(--ubd_dev->count > 0)
+		return;
+
 	os_close_file(ubd_dev->fd);
 	if(ubd_dev->cow.file == NULL)
 		return;
@@ -801,6 +804,7 @@ static void ubd_device_release(struct de
 {
 	struct ubd *ubd_dev = dev->driver_data;
 
+	ubd_close_dev(ubd_dev);
 	blk_cleanup_queue(ubd_dev->queue);
 	*ubd_dev = ((struct ubd) DEFAULT_UBD);
 }
@@ -1144,8 +1148,7 @@ static int ubd_release(struct inode * in
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ubd *ubd_dev = disk->private_data;
 
-	if(--ubd_dev->count == 0)
-		ubd_close_dev(ubd_dev);
+	ubd_close_dev(ubd_dev);
 	return 0;
 }
 
