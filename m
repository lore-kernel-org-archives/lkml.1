Return-Path: <linux-kernel-owner+w=401wt.eu-S936737AbXHGVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936737AbXHGVLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964924AbXHGUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59553 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXHGUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:02 -0400
Date: Tue, 7 Aug 2007 13:47:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kristian H?gsberg <krh@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [2.6.22.2 review 48/84] firewire: fix memory leak of fw_request
	instances
Message-ID: <20070807204718.GX23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="firewire-fix-memory-leak-of-fw_request-instances.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Found and debugged by Jay Fenlason <fenlason@redhat.com>.
The bug was especially noticeable with direct I/O over fw-sbp2.

Same as commit 9c9bdf4d50730fd04b06077e22d7a83b585f26b5.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-transaction.c |    4 +++-
 drivers/firewire/fw-transaction.h |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -605,8 +605,10 @@ fw_send_response(struct fw_card *card, s
 	 * check is sufficient to ensure we don't send response to
 	 * broadcast packets or posted writes.
 	 */
-	if (request->ack != ACK_PENDING)
+	if (request->ack != ACK_PENDING) {
+		kfree(request);
 		return;
+	}
 
 	if (rcode == RCODE_COMPLETE)
 		fw_fill_response(&request->response, request->request_header,
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -124,6 +124,10 @@ typedef void (*fw_transaction_callback_t
 					  size_t length,
 					  void *callback_data);
 
+/*
+ * Important note:  The callback must guarantee that either fw_send_response()
+ * or kfree() is called on the @request.
+ */
 typedef void (*fw_address_callback_t)(struct fw_card *card,
 				      struct fw_request *request,
 				      int tcode, int destination, int source,

-- 
