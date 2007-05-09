Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbXEIWXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbXEIWXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXEIWXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:23:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:32600 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbXEIWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QgQO+kQLANT1jC1UptCRcHEG14lF41hY62HcJ0o/d7KQRKwyuGmOxFLhmH7mCzcRVQLXji6sRYUhi8adGCh41FskmzgoZXJN4fT2eN1w8uzM1X2poDhLD8pUALao15bbCzny+op8BAYWuQRfB3YeJq9eq5rNe1osagRzXRFM3Pg=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix memory leak in UBI scanning unit
Date: Thu, 10 May 2007 00:26:12 +0200
User-Agent: KMail/1.9.6
Cc: dedekind@linutronix.de, dedekind@infradead.org,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100026.12639.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In drivers/mtd/ubi/scan.c::paranoid_check_si() there's a memory leak.
If the call 
	err = ubi_io_is_bad(ubi, pnum);
returns <0, then we'll return with out freeing (and thus leak) buf.
This patch eliminates the memory leak by freeing buf before returning.

Problem spotted by the Coverity checker.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
-- 

 drivers/mtd/ubi/scan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 473f320..8ff9730 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -1310,9 +1310,10 @@ static int paranoid_check_si(const struct ubi_device *ubi,
 	memset(buf, 1, ubi->peb_count);
 	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
 		err = ubi_io_is_bad(ubi, pnum);
-		if (err < 0)
+		if (err < 0) {
+			kfree(buf);
 			return err;
-		else if (err)
+		} else if (err)
 			buf[pnum] = 0;
 	}
 






-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

