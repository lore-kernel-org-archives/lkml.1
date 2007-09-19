Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXISMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXISMq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbXISMqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:46:50 -0400
Received: from sacred.ru ([62.205.161.221]:58794 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbXISMqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:46:49 -0400
Message-ID: <46F11997.7030005@openvz.org>
Date: Wed, 19 Sep 2007 16:44:07 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Use list_first_entry in locks_wake_up_blocks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 19 Sep 2007 16:46:29 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This routine deletes all the elements from the list
with the "while (!list_empty())" loop, and we already
have a list_first_entry() macro to help it look nicer :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/locks.c b/fs/locks.c
index 746dc70..5fa072a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -534,7 +534,9 @@ static void locks_insert_block(struct fi
 static void locks_wake_up_blocks(struct file_lock *blocker)
 {
 	while (!list_empty(&blocker->fl_block)) {
-		struct file_lock *waiter = list_entry(blocker->fl_block.next,
+		struct file_lock *waiter;
+
+		waiter = list_first_entry(&blocker->fl_block,
 				struct file_lock, fl_block);
 		__locks_delete_block(waiter);
 		if (waiter->fl_lmops && waiter->fl_lmops->fl_notify)
