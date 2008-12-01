Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYLALgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYLALgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYLALf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:35:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36947 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbYLALf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:35:56 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] drivers/char/tty_io.c: Avoid panic when no console is
	configured.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Dec 2008 11:36:06 +0000
Message-ID: <20081201113558.29458.31607.stgit@localhost.localdomain>
In-Reply-To: <20081201113445.29458.35295.stgit@localhost.localdomain>
References: <20081201113445.29458.35295.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: \"Will Newton\" <will.newton@gmail.com>

When no console is configured tty_open tries to call kref_get on a NULL
pointer, return ENODEV instead.

Signed-off-by: Will Newton <will.newton@gmail.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 966be86..ac73fd9 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1793,12 +1793,15 @@ retry_open:
 	}
 #endif
 	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
-		driver = tty_driver_kref_get(console_device(&index));
-		if (driver) {
-			/* Don't let /dev/console block */
-			filp->f_flags |= O_NONBLOCK;
-			noctty = 1;
-			goto got_driver;
+		struct tty_driver *console_driver = console_device(&index);
+		if (console_driver) {
+			driver = tty_driver_kref_get(console_driver);
+			if (driver) {
+				/* Don't let /dev/console block */
+				filp->f_flags |= O_NONBLOCK;
+				noctty = 1;
+				goto got_driver;
+			}
 		}
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;

