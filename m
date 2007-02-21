Return-Path: <linux-kernel-owner+w=401wt.eu-S1751085AbXBUBjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbXBUBjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXBUBit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:38:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:34477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXBUBiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:38:24 -0500
Date: Tue, 20 Feb 2007 17:36:34 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hancock <hancockr@shaw.ca>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 01/21] V4L: cx88: Fix lockup on suspend
Message-ID: <20070221013634.GB30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="V4L-cx88-Fix-lockup-on-suspend.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
Suspending with the cx88xx module loaded causes the system to lock up
because the cx88_audio_thread kthread was missing a try_to_freeze()
call, which caused it to go into a tight loop and result in softlockup
when suspending. Fix that.

(cherry picked from commit a96afb3e9428f2e7463344f12dbc85faf08e2e09)

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-tvaudio.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.19.4.orig/drivers/media/video/cx88/cx88-tvaudio.c
+++ linux-2.6.19.4/drivers/media/video/cx88/cx88-tvaudio.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/freezer.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -974,6 +975,7 @@ int cx88_audio_thread(void *data)
 		msleep_interruptible(1000);
 		if (kthread_should_stop())
 			break;
+		try_to_freeze();
 
 		/* just monitor the audio status for now ... */
 		memset(&t, 0, sizeof(t));

--
