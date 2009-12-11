Return-Path: <linux-kernel-owner+w=401wt.eu-S934642AbZLKXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbZLKXaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934555AbZLKX3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:54 -0500
Received: from kroah.org ([198.145.64.141]:50546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934496AbZLKX3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/58] tty: Push the bkl down a bit in the hangup code
Date: Fri, 11 Dec 2009 15:28:40 -0800
Message-Id: <1260574122-10676-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We know that the redirect field is handled via its own locking in all
places

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c408c81..cc941a3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -505,8 +505,6 @@ static void do_tty_hangup(struct work_struct *work)
 	if (!tty)
 		return;
 
-	/* inuse_filps is protected by the single kernel lock */
-	lock_kernel();
 
 	spin_lock(&redirect_lock);
 	if (redirect && redirect->private_data == tty) {
@@ -515,6 +513,8 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	spin_unlock(&redirect_lock);
 
+	/* inuse_filps is protected by the single kernel lock */
+	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
-- 
1.6.5.5

