Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbZKROnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbZKROnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZKROnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:43:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36896 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757392AbZKROnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:43:08 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] tty: split the lock up a bit further
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:26:45 +0000
Message-ID: <20091118142634.3806.11729.stgit@localhost.localdomain>
In-Reply-To: <20091118142313.3806.47368.stgit@localhost.localdomain>
References: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty count sanity check may need the BKL, that isn't clear. However it
is clear that the count use of the lock is internal and independant of the
bigger use of the lock.

Furthermore the file list locking is also separately locked already

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_io.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index aee68f5..4c2f793 100644
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

