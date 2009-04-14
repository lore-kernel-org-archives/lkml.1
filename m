Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZDNM6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZDNM6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZDNM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:58:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32933 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755314AbZDNM6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:58:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/4] cdc-acm: Fix long standing abuse of tty->low_latency
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 14:57:36 +0100
Message-ID: <20090414135728.13935.47954.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
References: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACM sets the low latency flag but calls the flip buffer routines from IRQ
context which isn't permitted (and as of 2.6.29 causes a warning hence this
one was caught)

Fortunatelt ACM doesn't need to set this flag in the first place as it only
set it to work around problems in ancient (pre tty flip rewrite) kernels.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/class/cdc-acm.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 869d47c..0a69c09 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -546,10 +546,6 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = acm;
 	acm->tty = tty;
 
-	/* force low_latency on so that our tty_push actually forces the data through,
-	   otherwise it is scheduled, and with high data rates data can get lost. */
-	tty->low_latency = 1;
-
 	if (usb_autopm_get_interface(acm->control) < 0)
 		goto early_bail;
 	else

