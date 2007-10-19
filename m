Return-Path: <linux-kernel-owner+w=401wt.eu-S964999AbXJSOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbXJSOEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762173AbXJSOEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:04:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38542 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758483AbXJSOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:04:33 -0400
Date: Fri, 19 Oct 2007 16:05:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix mm/util.c:krealloc()
Message-ID: <20071019140502.GD3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ef8b4520bd9f8294ffce9abd6158085bde5dc902 added one NULL check for 
"p" in krealloc(), but that doesn't seem to be enough since there 
doesn't seem to be any guarantee that memcpy(ret, NULL, 0) works 
(spotted by the Coverity checker).

For making it clearer what happens this patch also removes the
pointless min().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/mm/util.c.old	2007-10-19 15:10:43.000000000 +0200
+++ linux-2.6/mm/util.c	2007-10-19 15:32:01.000000000 +0200
@@ -94,10 +94,10 @@ void *krealloc(const void *p, size_t new
 	if (ks >= new_size)
 		return (void *)p;
 
 	ret = kmalloc_track_caller(new_size, flags);
-	if (ret) {
-		memcpy(ret, p, min(new_size, ks));
+	if (ret && p) {
+		memcpy(ret, p, ks);
 		kfree(p);
 	}
 	return ret;
 }
