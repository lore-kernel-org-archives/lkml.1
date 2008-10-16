Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYJPGTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYJPGTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYJPGNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:22 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:55052 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYJPGNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:21 -0400
X-Authority-Analysis: v=1.0 c=1 a=xMhxSk1wTlIA:10 a=o38CLdX0wXAA:10
 a=N2zm75lOJe27phbO3U8A:9 a=nxEKVtk913c-g_7V9q4A:7
 a=xyhgqto2oOUw8r_6w9-l2BFxNCsA:4 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 20/21]  Call padding callback on flush.
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 01:06:55 -0500
Message-Id: <1224137215.16328.239.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 kernel/relay_pagewriter.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
index 9bc1461..c3369f5 100644
--- a/kernel/relay_pagewriter.c
+++ b/kernel/relay_pagewriter.c
@@ -137,10 +137,18 @@ void pagewriter_flush(struct pagewriter *pagewriter)
 		return;
 
 	mutex_lock(&pagewriters_mutex);
-	for_each_possible_cpu(i)
-		if (pagewriter->buf[i])
-			pagewriter->cb->switch_page(pagewriter->buf[i], 0,
-						    NULL);
+	for_each_possible_cpu(i) {
+		struct pagewriter_buf *buf = pagewriter->buf[i];
+		if (buf) {
+			if (buf->pagewriter->flags & PAGEWRITER_PAD_WRITES) {
+				void *padding = buf->data + buf->offset;
+				size_t padlen = PAGE_SIZE - buf->offset;
+				pagewriter->cb->write_padding(buf, padlen,
+							      padding);
+			}
+			pagewriter->cb->switch_page(buf, 0, NULL);
+		}
+	}
 	relay_flush(pagewriter->rchan);
 	mutex_unlock(&pagewriters_mutex);
 }
-- 
1.5.3.5



