Return-Path: <linux-kernel-owner+w=401wt.eu-S1767425AbXECP56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767425AbXECP56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767430AbXECP56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:57:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:3798 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767425AbXECP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=d2W+ws+V2OddP1tFtwnaFHyPlXlmqqQmMP1meLkIFoJvdeDc7ec5TfNIb4u8wIZvVB/LTP1Mjo5m2w8igaC5ykl+XtgAYd/U2958N2tiUptSWaHmHY2i7bEmrCJpXKL4sJCrWIjjaVCbxygKPXXXBI+enJwuLdFYuWOBxbJNgiA=
Message-ID: <463A04A5.5030103@gmail.com>
Date: Thu, 03 May 2007 11:49:57 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: dedekind@infradead.org
CC: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] UBI: dereference after kfree in create_vtbl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity (CID 1614) spotted new_seb being dereferenced after kfree() in 
create_vtbl's write_error path.


Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 vtbl.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index b6fd6bb..91e3619 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -317,14 +317,13 @@ retry:
 	return err;
 
 write_error:
-	kfree(new_seb);
-	/* May be this physical eraseblock went bad, try to pick another one */
-	if (++tries <= 5) {
+	/* Maybe this physical eraseblock went bad, try to pick another one */
+	if (++tries <= 5)
 		err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
 					   &si->corr);
-		if (!err)
-			goto retry;
-	}
+	kfree(new_seb);	
+	if (!err)
+		goto retry;
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;

