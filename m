Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXGSTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXGSTXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXGSTW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:22:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:8928 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762499AbXGSTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=a9Vsmzf58Itrlps2MBuC41ssiGO2/wXynYOmzd8lPcjLr/ZVh+Oavyl6UQhPmgDBllkPODltKx3obZWG2uBVElU4MCP8k59dn1Li49g21uvuZAChR7J8igfAE9v0xkEgl+GqqBXwRtNcFCZJj3VhHs5o4JbcmIuZUDjDKIrygHo=
Message-ID: <469FBA01.80107@gmail.com>
Date: Thu, 19 Jul 2007 15:22:41 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: dedekind@infradead.org
CC: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] UBI: potential leak in ubi_scan_erase_peb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity (1769) found the following problem: if the erase counter 
overflow check triggers, ec_hdr is leaked.

Moving the allocation after the overflow check should take care of it.


Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/mtd/ubi/scan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 94ee549..80c73d8 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -673,10 +673,6 @@ int ubi_scan_erase_peb(const struct ubi_device *ubi,
 	int err;
 	struct ubi_ec_hdr *ec_hdr;
 
-	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
-	if (!ec_hdr)
-		return -ENOMEM;
-
 	if ((long long)ec >= UBI_MAX_ERASECOUNTER) {
 		/*
 		 * Erase counter overflow. Upgrade UBI and use 64-bit
@@ -686,6 +682,10 @@ int ubi_scan_erase_peb(const struct ubi_device *ubi,
 		return -EINVAL;
 	}
 
+	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	if (!ec_hdr)
+		return -ENOMEM;
+
 	ec_hdr->ec = cpu_to_be64(ec);
 
 	err = ubi_io_sync_erase(ubi, pnum, 0);

