Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYJWO0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYJWO0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJWOZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:25:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:58496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYJWOZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:25:55 -0400
Date: Thu, 23 Oct 2008 16:25:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: levon@movementarian.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] oprofile: fix memory ordering
Message-ID: <20081023142554.GA22805@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regular bitops don't work as locks on all architectures.

Also: can use non-atomic unlock as no concurrent stores to the word.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/drivers/oprofile/event_buffer.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/event_buffer.c
+++ linux-2.6/drivers/oprofile/event_buffer.c
@@ -105,7 +105,7 @@ static int event_buffer_open(struct inod
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (test_and_set_bit(0, &buffer_opened))
+	if (test_and_set_bit_lock(0, &buffer_opened))
 		return -EBUSY;
 
 	/* Register as a user of dcookies
@@ -129,7 +129,7 @@ static int event_buffer_open(struct inod
 fail:
 	dcookie_unregister(file->private_data);
 out:
-	clear_bit(0, &buffer_opened);
+	__clear_bit_unlock(0, &buffer_opened);
 	return err;
 }
 
@@ -141,7 +141,7 @@ static int event_buffer_release(struct i
 	dcookie_unregister(file->private_data);
 	buffer_pos = 0;
 	atomic_set(&buffer_ready, 0);
-	clear_bit(0, &buffer_opened);
+	__clear_bit_unlock(0, &buffer_opened);
 	return 0;
 }
 
