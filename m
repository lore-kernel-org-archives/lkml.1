Return-Path: <linux-kernel-owner+w=401wt.eu-S1030914AbXDJPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030914AbXDJPvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030919AbXDJPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:51:35 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13763 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030914AbXDJPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:51:34 -0400
Subject: [Patch] statistics: small cleanup in debugfs write function
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Date: Tue, 10 Apr 2007 17:51:33 +0200
Message-Id: <1176220293.5572.16.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code looks more sane with this little cleanup, although both memcpy()
and kfree() are supposed to cope with NULL pointer or zero length
respectively.

(Patch cleans up
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch)

Patch is against 2.6.21-rc6-mm1.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 statistic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/lib/statistic.c
===================================================================
--- linux.orig/lib/statistic.c
+++ linux/lib/statistic.c
@@ -631,11 +631,13 @@ static ssize_t statistic_write_def(struc
 	if (!larger)
 		return -ENOMEM;
 	larger[*offset + len] = '\0';
-	memcpy(larger, seq_priv->w_buf, *offset);
+	if (seq_priv->w_buf) {
+		memcpy(larger, seq_priv->w_buf, *offset);
+		kfree(seq_priv->w_buf);
+	}
 	if (copy_from_user(larger + *offset, buf, len))
 		return -EFAULT;
 	*offset += len;
-	kfree(seq_priv->w_buf);
 	seq_priv->w_buf = larger;
 	seq_priv->w_offset = *offset;
 	return len;


