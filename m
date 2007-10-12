Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbXJLR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbXJLR0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763032AbXJLRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:23:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762966AbXJLRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:23:42 -0400
Date: Fri, 12 Oct 2007 18:23:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.24 PATCH 24/25] dm log: split suspend
Message-ID: <20071012172337.GJ24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Brassow <jbrassow@redhat.com>

There are now two phases to a suspend in device-mapper -
presuspend and postsuspend.  This patch removes the
single 'suspend' in the logging API and replaces it with
'presuspend' and 'postsuspend' functions to align it 
better with core device-mapper.

A subsequent patch will make use of 'presuspend'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-log.c   |    2 +-
 drivers/md/dm-log.h   |    3 ++-
 drivers/md/dm-raid1.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.23/drivers/md/dm-log.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-log.c	2007-10-12 12:36:13.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-log.c	2007-10-12 15:03:32.000000000 +0100
@@ -696,7 +696,7 @@ static struct dirty_log_type _disk_type 
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
-	.suspend = disk_flush,
+	.postsuspend = disk_flush,
 	.resume = disk_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
Index: linux-2.6.23/drivers/md/dm-log.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-log.h	2007-10-12 12:36:13.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-log.h	2007-10-12 15:03:32.000000000 +0100
@@ -32,7 +32,8 @@ struct dirty_log_type {
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*suspend)(struct dirty_log *log);
+	int (*presuspend)(struct dirty_log *log);
+	int (*postsuspend)(struct dirty_log *log);
 	int (*resume)(struct dirty_log *log);
 
 	/*
Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 13:15:36.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 15:03:32.000000000 +0100
@@ -1305,7 +1305,7 @@ static void mirror_postsuspend(struct dm
 	wait_event(_kmirrord_recovery_stopped,
 		   !atomic_read(&ms->rh.recovery_in_flight));
 
-	if (log->type->suspend && log->type->suspend(log))
+	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log suspend failed");
 }
