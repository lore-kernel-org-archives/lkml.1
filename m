Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbZIWRZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbZIWRZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZIWRZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:25:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZIWRZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:25:04 -0400
Date: Wed, 23 Sep 2009 19:24:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
       Elina Pasheva <epasheva@sierrawireless.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [origin tree build failure] [PATCH] USB sierra: Fix build if
	!CONFIG_PM
Message-ID: <20090923172456.GA8948@elte.hu>
References: <20090923135539.GA6542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923135539.GA6542@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>       USB: support for autosuspend in sierra while online

FYI, -tip testing found a build failure with the sierra driver on 
!CONFIG_PM - fixed via the patch below.

Thanks,

	Ingo

-------------------->
>From 26f8ed899041199caa9315e057a28d10f81b5b88 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Sep 2009 19:19:47 +0200
Subject: [PATCH] USB sierra: Fix build if !CONFIG_PM

This build failure:

  drivers/usb/serial/sierra.c: In function 'sierra_suspend':
  drivers/usb/serial/sierra.c:936: error: 'struct usb_device' has no member named 'auto_pm'

Triggers because the ->auto_pm functionality depends on CONFIG_PM.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/usb/serial/sierra.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 68fa0e4..b089a70 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -912,6 +912,8 @@ static void sierra_release(struct usb_serial *serial)
 	}
 }
 
+#ifdef CONFIG_PM
+
 static void stop_read_write_urbs(struct usb_serial *serial)
 {
 	int i, j;
@@ -989,6 +991,8 @@ static int sierra_resume(struct usb_serial *serial)
 	return ec ? -EIO : 0;
 }
 
+#endif /* CONFIG_PM */
+
 static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -1009,8 +1013,10 @@ static struct usb_serial_driver sierra_device = {
 	.tiocmset          = sierra_tiocmset,
 	.attach            = sierra_startup,
 	.release           = sierra_release,
+#ifdef CONFIG_PM
 	.suspend	   = sierra_suspend,
 	.resume		   = sierra_resume,
+#endif
 	.read_int_callback = sierra_instat_callback,
 };
 
