Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbXHCX1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbXHCX1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXHCX1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:27:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:27156 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXHCX1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GSqEU+3WKuTDLiCsy/N9FIzimTcE1EVmI3I8lUjG5HXjW6R9X5zKYYyHYtc5XFzTKcTxHVMxM6EpRFqLm/1YN0TTz2SEC605yAlfezO4dDqt9BVXo40zffDAvDyUKwaRWcBwCtWIdUh7zWejGXbAgkM7/UytBTdhlAspyT1xmXw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: [PATCH] UBI: Don't use signed int as array index before testing if it is negative
Date: Sat, 4 Aug 2007 01:25:26 +0200
User-Agent: KMail/1.9.7
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708040125.26861.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can't find anything guaranteeing that 'ubi_num' cannot be <0 in 
drivers/mtd/ubi/kapi.c::ubi_open_volume(), and in fact the code 
even tests for that and errors out if so. Unfortunately the test 
for "ubi_num < 0" happens after we've already used 'ubi_num' as 
an array index - bad thing to do if it is negative.
This patch moves the test earlier in the function and then moves 
the indexing using that variable after the check. A bit safer :-) 


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/mtd/ubi/kapi.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 4a458e8..5130e54 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -99,16 +99,21 @@ struct ubi_volume_desc *ubi_open_volume(int ubi_num, int vol_id, int mode)
 {
 	int err;
 	struct ubi_volume_desc *desc;
-	struct ubi_device *ubi = ubi_devices[ubi_num];
+	struct ubi_device *ubi;
 	struct ubi_volume *vol;
 
 	dbg_msg("open device %d volume %d, mode %d", ubi_num, vol_id, mode);
 
 	err = -ENODEV;
+	if (ubi_num < 0)
+		return ERR_PTR(err);
+
+	ubi = ubi_devices[ubi_num];
+	
 	if (!try_module_get(THIS_MODULE))
 		return ERR_PTR(err);
 
-	if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES || !ubi)
+	if (ubi_num >= UBI_MAX_DEVICES || !ubi)
 		goto out_put;
 
 	err = -EINVAL;


