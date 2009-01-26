Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZAZVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZAZVDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZAZVCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:02:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39093 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZAZVCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:02:51 -0500
Subject: tty: tty_open can return to userspace holding tty_mutex
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: sgrubb@redhat.com, esandeen@redhat.com, sukadev@us.ibm.com,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain
Date: Mon, 26 Jan 2009 16:02:40 -0500
Message-Id: <1233003761.9850.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__tty_open could return (to userspace) holding the tty_mutex thanks to a
regression introduced by 4a2b5fddd53b80efcb3266ee36e23b8de28e761a.  This was
found by bisecting an fsfuzzer problem.  Admittedly I have no idea how it
managed to tickle this 100% reliably, but it is clearly a regression and
when hit leaves the box in a completely unusable state.  This patch lets
the fsfuzzer test complete every time.
    
Signed-off-by: Eric Paris <eparis@redhat.com>

---
 drivers/char/tty_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d33e5ab..bc84e12 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1817,8 +1817,10 @@ got_driver:
 		/* check whether we're reopening an existing tty */
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
-		if (IS_ERR(tty))
+		if (IS_ERR(tty)) {
+			mutex_unlock(&tty_mutex);
 			return PTR_ERR(tty);
+		}
 	}
 
 	if (tty) {


