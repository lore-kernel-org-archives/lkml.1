Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbZAONa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbZAONa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZAONaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755299AbZAONaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:08 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/8] tty: Fix race in the flush for some ldiscs
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:30:25 +0000
Message-ID: <20090115133000.21366.28884.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

If you issue an ioctl to flush a tty as the line discipline is changing or
otherwise unplugged you can get a crash. The bug is very old but the rest
of the BKL lock dropping and some very "good" luck on Ingo's part caught
an example.

Use the correct ldisc_ref form so that we wait for the ldisc change to
complete and then flush

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index a408c8e..6f4c7d0 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -1057,7 +1057,7 @@ int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
 	if (retval)
 		return retval;
 
-	ld = tty_ldisc_ref(tty);
+	ld = tty_ldisc_ref_wait(tty);
 	switch (arg) {
 	case TCIFLUSH:
 		if (ld && ld->ops->flush_buffer)

