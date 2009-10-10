Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZJJLw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZJJLw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 07:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbZJJLwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 07:52:25 -0400
Received: from server1.wserver.cz ([82.113.45.157]:59337 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbZJJLwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 07:52:23 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] PM / Hibernate: fix error handling in save_image
Date: Sat, 10 Oct 2009 13:51:45 +0200
Message-Id: <1255175505-7756-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are too many retval variables in save_image. Thus error return
value from snapshot_read_next may be ignored and only part of the
snapshot (successfully) written.

Remove 'error' variable, invert the condition in the do-while loop
and convert the loop to use only 'ret' variable.

Switch the rest of the function to consider only 'ret'.

Also make sure we end printed line by \n if an error occurs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/power/swap.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 89e958e..47586d9 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -415,7 +415,6 @@ static int save_image(struct swap_map_handle *handle,
 {
 	unsigned int m;
 	int ret;
-	int error = 0;
 	int nr_pages;
 	int err2;
 	struct bio *bio;
@@ -430,26 +429,27 @@ static int save_image(struct swap_map_handle *handle,
 	nr_pages = 0;
 	bio = NULL;
 	do_gettimeofday(&start);
-	do {
+	while (1) {
 		ret = snapshot_read_next(snapshot, PAGE_SIZE);
-		if (ret > 0) {
-			error = swap_write_page(handle, data_of(*snapshot),
-						&bio);
-			if (error)
-				break;
-			if (!(nr_pages % m))
-				printk("\b\b\b\b%3d%%", nr_pages / m);
-			nr_pages++;
-		}
-	} while (ret > 0);
+		if (ret <= 0)
+			break;
+		ret = swap_write_page(handle, data_of(*snapshot), &bio);
+		if (ret)
+			break;
+		if (!(nr_pages % m))
+			printk("\b\b\b\b%3d%%", nr_pages / m);
+		nr_pages++;
+	}
 	err2 = wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
-	if (!error)
-		error = err2;
-	if (!error)
+	if (!ret)
+		ret = err2;
+	if (!ret)
 		printk("\b\b\b\bdone\n");
+	else
+		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
-	return error;
+	return ret;
 }
 
 /**
-- 
1.6.4.2

