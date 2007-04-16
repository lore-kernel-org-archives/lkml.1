Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbXDPHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbXDPHg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXDPHg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:36:58 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:11417 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbXDPHg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:36:57 -0400
Message-ID: <4623289A.1000101@sw.ru>
Date: Mon, 16 Apr 2007 11:41:14 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH] Check for error returned by kthread_create on creating journal
 thread
Content-Type: multipart/mixed;
 boundary="------------020900000406050409030808"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020900000406050409030808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If the thread failed to create the subsequent wait_event
will hang forever.

This is likely to happen if kernel hits max_threads limit.

Will be critical for virtualization systems that limit the
number of tasks and kernel memory usage within the container.

--------------020900000406050409030808
Content-Type: text/plain;
 name="diff-jbd-check-start-journal-thread-return-value"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-jbd-check-start-journal-thread-return-value"

--- ./fs/jbd/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
+++ ./fs/jbd/journal.c	2007-04-16 11:30:09.000000000 +0400
@@ -211,10 +211,16 @@ end_loop:
 	return 0;
 }
 
-static void journal_start_thread(journal_t *journal)
+static int journal_start_thread(journal_t *journal)
 {
-	kthread_run(kjournald, journal, "kjournald");
+	struct task_struct *t;
+
+	t = kthread_run(kjournald, journal, "kjournald");
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
 	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	return 0;
 }
 
 static void journal_kill_thread(journal_t *journal)
@@ -840,8 +846,7 @@ static int journal_reset(journal_t *jour
 
 	/* Add the dynamic fields and write it to disk. */
 	journal_update_superblock(journal, 1);
-	journal_start_thread(journal);
-	return 0;
+	return journal_start_thread(journal);
 }
 
 /**
--- ./fs/jbd2/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
+++ ./fs/jbd2/journal.c	2007-04-16 11:27:45.000000000 +0400
@@ -211,10 +211,16 @@ end_loop:
 	return 0;
 }
 
-static void jbd2_journal_start_thread(journal_t *journal)
+static int jbd2_journal_start_thread(journal_t *journal)
 {
-	kthread_run(kjournald2, journal, "kjournald2");
+	struct task_struct *t;
+
+	t = kthread_run(kjournald2, journal, "kjournald2");
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
 	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	return 0;
 }
 
 static void journal_kill_thread(journal_t *journal)
@@ -840,8 +846,7 @@ static int journal_reset(journal_t *jour
 
 	/* Add the dynamic fields and write it to disk. */
 	jbd2_journal_update_superblock(journal, 1);
-	jbd2_journal_start_thread(journal);
-	return 0;
+	return jbd2_journal_start_thread(journal);
 }
 
 /**

--------------020900000406050409030808--
