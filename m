Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbXLMW6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbXLMW6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbXLMW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:57:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:5831 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbXLMW55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=BsGSYyuPreBtkdlSv6z6CDT1S78gLRfG/6yBVEkvr1bofNxlDfWZUJwnXfXA8rkYR0qnbkY3wfAFXgPjJzVcJzpGnk/9Ye4r/NWSIOG90g43w393/IQaPTXvb0gHl0O/717ilFdqIyFCIHDqJBhEe3LQFsKAXoAruD1IVCZ4Cvk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: [PATCH] UBI: silence warning about possibly uninitialized use of variable in drivers/mtd/ubi/vmt.c ...
Date: Thu, 13 Dec 2007 23:53:08 +0100
User-Agent: KMail/1.9.7
Cc: linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <4761b8f2.1c89420a.7f10.ffffe9db@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

This patch silences the following warning :

  drivers/mtd/ubi/vmt.c:73: warning: 'ret' may be used uninitialized in this function

gcc can't see that we always initialize ret in all situations where it is 
actually used. The one case where it's not initialized is when we BUG(), 
but gcc doesn't know that we won't then continue and use an uninitialized 
'ret'.

This patch results in code that does exactely the same as before, but it 
also makes gcc shut up, so we generate one less line of warning noise.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 vmt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 88629a3..e44948d 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -70,13 +70,14 @@ static struct device_attribute attr_vol_upd_marker =
 static ssize_t vol_attribute_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	int ret;
+	int ret = -ENODEV;
+
 	struct ubi_volume *vol = container_of(dev, struct ubi_volume, dev);
 
 	spin_lock(&vol->ubi->volumes_lock);
 	if (vol->removed) {
 		spin_unlock(&vol->ubi->volumes_lock);
-		return -ENODEV;
+		return ret;
 	}
 	if (attr == &attr_vol_reserved_ebs)
 		ret = sprintf(buf, "%d\n", vol->reserved_pebs);
