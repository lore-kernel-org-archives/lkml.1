Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZKROmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZKROmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbZKROmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:42:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36890 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932089AbZKROmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:42:38 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/5] tty: Push the bkl down a bit in the hangup code
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:26:16 +0000
Message-ID: <20091118142608.3806.91703.stgit@localhost.localdomain>
In-Reply-To: <20091118142313.3806.47368.stgit@localhost.localdomain>
References: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know that the redirect field is handled via its own locking in all
places

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a1b1ff6..f4a0404 100644
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

