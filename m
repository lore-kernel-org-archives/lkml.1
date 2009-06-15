Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZFOOaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZFOOaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZFOO37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:29:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33242 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753470AbZFOO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:29:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix leaks introduced by the shift to separate ldisc
	objects
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jun 2009 16:28:29 +0100
Message-ID: <20090615152829.3915.23655.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Gold star for the kmemleak detector.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 39c8f86..94b3e06 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -148,8 +148,10 @@ static struct tty_ldisc *tty_ldisc_try_get(int disc)
 		}
 	}
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	if (err)
+	if (err) {
+		kfree(ld);
 		return ERR_PTR(err);
+	}
 	return ld;
 }
 
@@ -262,7 +264,7 @@ const struct file_operations tty_ldiscs_proc_fops = {
  *	@ld: line discipline
  *
  *	Install an instance of a line discipline into a tty structure. The
- *	ldisc must have a reference count above zero to ensure it remains/
+ *	ldisc must have a reference count above zero to ensure it remains.
  *	The tty instance refcount starts at zero.
  *
  *	Locking:

