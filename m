Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbYCUW5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbYCUW5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763038AbYCUWuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59210 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763077AbYCUWua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:30 -0400
Message-Id: <20080321224353.846992844@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>, Mark Glines <mark@glines.org>,
       linux-usb@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 26/76] usb-storage: dont access beyond the end of the sg buffer
Content-Disposition: inline; filename=usb-storage-don-t-access-beyond-the-end-of-the-sg-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1038) fixes a bug in usb_stor_access_xfer_buf() and
usb_stor_set_xfer_buf() (the bug was originally found by Boaz
Harrosh): The routine must not attempt to write beyond the end of a
scatter-gather list or beyond the number of bytes requested.

This is the minimal 2.6.24 equivalent to as1035 +
as1037 (7084191d53b224b953c8e1db525ea6c31aca5fc7 "USB:
usb-storage: don't access beyond the end of the sg buffer" +
6d512a80c26d87f8599057c86dc920fbfe0aa3aa "usb-storage: update earlier
scatter-gather bug fix").  Mark Glines has confirmed that it fixes
his problem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Glines <mark@glines.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/protocol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -194,7 +194,7 @@ unsigned int usb_stor_access_xfer_buf(un
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen) {
+		while (cnt < buflen && sg) {
 			struct page *page = sg_page(sg) +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
@@ -249,7 +249,8 @@ void usb_stor_set_xfer_buf(unsigned char
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
+	buflen = min(buflen, srb->request_bufflen);
+	buflen = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
 	if (buflen < srb->request_bufflen)
 		srb->resid = srb->request_bufflen - buflen;

-- 
