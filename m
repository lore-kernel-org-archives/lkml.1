Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbZFPPEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbZFPPEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbZFPPDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:03:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44049 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759029AbZFPPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:03:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/9] tty: fix sanity check
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:01:33 +0100
Message-ID: <20090616160118.10041.47059.stgit@t61.ukuu.org.uk>
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

The WARN_ON() that was added to tty_reopen can be triggered in the specific
case of a hangup occurring during a re-open of a tty which is not in the
middle of being otherwise closed.

In that case however the WARN() is bogus as we don't hold the neccessary
locks to make a correct decision.

The case we should be checking is "if the ldisc is not changing and reopen
is occuring". We could drop the WARN_ON but for the moment the debug is more
valuable even if it means taking a mutex as it will find any other cases.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 939e198..a3afa0c 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1263,7 +1263,9 @@ static int tty_reopen(struct tty_struct *tty)
 	tty->count++;
 	tty->driver = driver; /* N.B. why do this every time?? */
 
+	mutex_lock(&tty->ldisc_mutex);
 	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
+	mutex_unlock(&tty->ldisc_mutex);
 
 	return 0;
 }

