Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZCNBlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZCNBlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZCNBVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:01 -0400
Received: from kroah.org ([198.145.64.141]:35355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbZCNBUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:40 2009
Message-Id: <20090314011040.152887304@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Adrian Hunter <adrian.hunter@nokia.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 059/114] mmc: fix data timeout for SEND_EXT_CSD
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mmc-fix-data-timeout-for-send_ext_csd.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adrian Hunter <adrian.hunter@nokia.com>

commit cda56ac29f2d8288d62978272856884d26e0b47b upstream.

Commit 0d3e0460f307e84904968aad6cff97bd688583d8
"MMC: CSD and CID timeout values" inadvertently broke
the timeout for the MMC command SEND_EXT_CSD.

This patch puts it back again.

Depending on the characteristics of the controller,
this bug may prevent the use of MMC cards.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/mmc_ops.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -248,12 +248,15 @@ mmc_send_cxd_data(struct mmc_card *card,
 
 	sg_init_one(&sg, data_buf, len);
 
-	/*
-	 * The spec states that CSR and CID accesses have a timeout
-	 * of 64 clock cycles.
-	 */
-	data.timeout_ns = 0;
-	data.timeout_clks = 64;
+	if (opcode == MMC_SEND_CSD || opcode == MMC_SEND_CID) {
+		/*
+		 * The spec states that CSR and CID accesses have a timeout
+		 * of 64 clock cycles.
+		 */
+		data.timeout_ns = 0;
+		data.timeout_clks = 64;
+	} else
+		mmc_set_data_timeout(&data, card);
 
 	mmc_wait_for_req(host, &mrq);
 


