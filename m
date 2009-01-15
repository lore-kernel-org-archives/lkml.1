Return-Path: <linux-kernel-owner+w=401wt.eu-S934306AbZAOWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbZAOWFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbZAOWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:01:57 -0500
Received: from kroah.org ([198.145.64.141]:38104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756476AbZAOWBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:01:55 -0500
Date: Thu, 15 Jan 2009 13:59:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [patch 07/85] ioat: fix self test for multi-channel case
Message-ID: <20090115215907.GH17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ioat-fix-self-test-for-multi-channel-case.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit b9bdcbba010c2e49c8f837ea7a49fe006b636f41 upstream.

In the multiple device case we need to re-arm the completion and protect
against concurrent self-tests.  The printk from the test callback is
removed as it can arbitrarily delay completion of the test.

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat_dma.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1337,12 +1337,11 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
-DECLARE_COMPLETION(test_completion);
 static void ioat_dma_test_callback(void *dma_async_param)
 {
-	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
-		dma_async_param);
-	complete(&test_completion);
+	struct completion *cmp = dma_async_param;
+
+	complete(cmp);
 }
 
 /**
@@ -1359,6 +1358,7 @@ static int ioat_dma_self_test(struct ioa
 	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	int err = 0;
+	struct completion cmp;
 
 	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -1398,8 +1398,9 @@ static int ioat_dma_self_test(struct ioa
 	}
 
 	async_tx_ack(tx);
+	init_completion(&cmp);
 	tx->callback = ioat_dma_test_callback;
-	tx->callback_param = (void *)0x8086;
+	tx->callback_param = &cmp;
 	cookie = tx->tx_submit(tx);
 	if (cookie < 0) {
 		dev_err(&device->pdev->dev,
@@ -1409,7 +1410,7 @@ static int ioat_dma_self_test(struct ioa
 	}
 	device->common.device_issue_pending(dma_chan);
 
-	wait_for_completion_timeout(&test_completion, msecs_to_jiffies(3000));
+	wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
 	if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
 					!= DMA_SUCCESS) {

