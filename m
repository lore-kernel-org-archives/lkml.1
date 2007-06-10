Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbXFJR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbXFJR2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbXFJR2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:28:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbXFJR2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:28:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: cat /dev/snapshot == OOPs
Date: Sun, 10 Jun 2007 19:33:53 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
References: <200706101542.33951.arekm@maven.pl>
In-Reply-To: <200706101542.33951.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101933.53647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 June 2007 15:42, Arkadiusz Miskiewicz wrote:
> Hello,
> 
> Is this desired behaviour?

Obviously not.

> $ sudo cat /dev/snapshot
> 
> ended with:
> 
> [54498.464550] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
> dm-devel@redhat.com
> [56592.077674] swsusp: Basic memory bitmaps created
> [56592.084340] BUG: unable to handle kernel NULL pointer dereference at 
> virtual address 0000000c

Can you please try the appended patch?

Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/power/user.c	2007-06-10 19:33:36.000000000 +0200
+++ linux-2.6.22-rc4/kernel/power/user.c	2007-06-10 19:35:59.000000000 +0200
@@ -99,6 +99,8 @@ static ssize_t snapshot_read(struct file
 	ssize_t res;
 
 	data = filp->private_data;
+	if (!data->ready)
+		return -ENODATA;
 	res = snapshot_read_next(&data->handle, count);
 	if (res > 0) {
 		if (copy_to_user(buf, data_of(data->handle), res))
@@ -163,7 +165,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_UNFREEZE:
-		if (!data->frozen)
+		if (!data->frozen || data->ready)
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
