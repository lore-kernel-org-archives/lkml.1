Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbZLKXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbZLKXaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934574AbZLKX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:56 -0500
Received: from kroah.org ([198.145.64.141]:50551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500AbZLKX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/58] tty: split the lock up a bit further
Date: Fri, 11 Dec 2009 15:28:42 -0800
Message-Id: <1260574122-10676-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The tty count sanity check may need the BKL, that isn't clear. However it
is clear that the count use of the lock is internal and independant of the
bigger use of the lock.

Furthermore the file list locking is also separately locked already

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a19fef2..684f0e0 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -516,6 +516,8 @@ static void do_tty_hangup(struct work_struct *work)
 	/* inuse_filps is protected by the single kernel lock */
 	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
+	unlock_kernel();
+
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
@@ -529,6 +531,7 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	file_list_unlock();
 
+	lock_kernel();
 	tty_ldisc_hangup(tty);
 
 	read_lock(&tasklist_lock);
-- 
1.6.5.5

