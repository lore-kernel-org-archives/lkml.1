Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYHZRji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYHZRji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbYHZRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:38:07 -0400
Received: from proofpoint3.lanl.gov ([204.121.3.28]:59224 "EHLO
	proofpoint3.lanl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbYHZRiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:38:06 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 13:38:06 EDT
X-CTN-5-Virus-Scanner: amavisd-new at mailrelay2.lanl.gov
Subject: [PATCH] 9p bug fix: return non-zero error value in p9_put_data
From: Abhishek Kulkarni <kulkarni@lanl.gov>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, ericvh@gmail.com
Content-Type: text/plain
Date: Tue, 26 Aug 2008 11:30:31 -0600
Message-Id: <1219771831.16125.12.camel@blender>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-CTN-5-MailScanner-Information: Please see http://network.lanl.gov/email/virus-scan.php
X-CTN-5-MailScanner: Found to be clean
X-CTN-5-MailScanner-From: kulkarni@lanl.gov
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.7161:2.4.4,1.2.40,4.0.164 definitions=2008-08-26_11:2008-08-25,2008-08-26,2008-08-26 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p9_put_data is called by p9_create_twrite which expects it to return a
non-zero value on error. This was the reason why every p9_client_write
was failing. This patch also adds a check for buffer overflow in
p9_put_data.

Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
---
 net/9p/conv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)
diff --git a/net/9p/conv.c b/net/9p/conv.c
index 4454720..7f6db15 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -451,8 +451,11 @@ p9_put_data(struct cbuf *bufp, const char *data,
int count,
 		   unsigned char **pdata)
 {
 	*pdata = buf_alloc(bufp, count);
+	if (buf_check_overflow(bufp))
+		return -EIO;
+
 	memmove(*pdata, data, count);
-	return count;
+	return 0;
 }
 
 static int


Thanks,
 -- Abhishek

