Return-Path: <linux-kernel-owner+w=401wt.eu-S969309AbXGaEil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969309AbXGaEil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968302AbXGaEcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34629 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967661AbXGaEcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:21 -0400
Date: Mon, 30 Jul 2007 21:33:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jeffm@suse.com, mchehab@infradead.org,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/26] saa7134: fix thread shutdown handling
Message-ID: <20070731043330.GU3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="saa7134-fix-thread-shutdown-handling.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

This patch changes the test for the thread pid from >= 0 to > 0.

When the saa8134 driver initialization fails after a certain point, it goes
through the complete shutdown process for the driver.  Part of shutting it
down includes tearing down the thread for tv audio.

The test for tearing down the thread tests for >= 0.  Since the dev
structure is kzalloc'd, the test will always be true if we haven't tried to
start the thread yet.  We end up waiting on pid 0 to complete, which will
never happen, so we lock up.

This bug was observed in Novell Bugzilla 284718, when request_irq() failed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.6.orig/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ linux-2.6.21.6/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -1006,7 +1006,7 @@ int saa7134_tvaudio_init2(struct saa7134
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
 	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
+	if (dev->thread.pid > 0) {
 		dev->thread.shutdown = 1;
 		wake_up_interruptible(&dev->thread.wq);
 		wait_for_completion(&dev->thread.exit);

-- 
