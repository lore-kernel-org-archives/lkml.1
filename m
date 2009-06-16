Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZFPPCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZFPPCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZFPPCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:02:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44022 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbZFPPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:02:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/9] tty: Fix leaks introduced by the shift to separate ldisc
	objects
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:00:26 +0100
Message-ID: <20090616160002.10041.79781.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
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

