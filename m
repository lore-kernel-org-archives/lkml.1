Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZAMBcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZAMBcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZAMB3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:05 -0500
Received: from kroah.org ([198.145.64.141]:35985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756538AbZAMB3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:01 -0500
Date: Mon, 12 Jan 2009 17:27:07 -0800
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
Subject: [patch 09/21] ioat: wait for self-test completion
Message-ID: <20090113012707.GJ4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ioat-wait-for-self-test-completion.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 532d3b1f86f41834a25373e3ded981d68e4ce17f upstream.

As part of the ioat_dma self-test it performs a printk from a completion
callback.  Depending on the system console configuration this output can
take longer than a millisecond causing the self-test to fail.  Introduce a
completion with a generous timeout to mitigate this failure.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat_dma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1337,10 +1337,12 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
+DECLARE_COMPLETION(test_completion);
 static void ioat_dma_test_callback(void *dma_async_param)
 {
 	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
 		dma_async_param);
+	complete(&test_completion);
 }
 
 /**
@@ -1406,7 +1408,8 @@ static int ioat_dma_self_test(struct ioa
 		goto free_resources;
 	}
 	device->common.device_issue_pending(dma_chan);
-	msleep(1);
+
+	wait_for_completion_timeout(&test_completion, msecs_to_jiffies(3000));
 
 	if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
 					!= DMA_SUCCESS) {

