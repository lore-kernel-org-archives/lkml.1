Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbYBUI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbYBUI4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYBUI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:56:07 -0500
Received: from sacred.ru ([62.205.161.221]:45986 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbYBUI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:56:05 -0500
Message-ID: <47BD3C96.40501@openvz.org>
Date: Thu, 21 Feb 2008 11:55:50 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuri Per <Yuri.Per@acronis.com>,
       Max Lyadvinsky <Max.Lyadvinsky@acronis.com>,
       Vladimir Simonov <Vladimir.Simonov@acronis.com>,
       Andrew Neporada <Andrew.Neporada@acronis.com>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH] UDF: fix anchor point detection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 21 Feb 2008 11:55:40 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to ECMA 167 rev. 3 (see 3/8.4.2.1), Anchor Volume
Descriptor Pointer should be recorded at two or more anchor 
points located at sectors 256, N, N - 256, where N - is a 
largest logical sector number at volume space.

So we should always try to detect N on UDF volume before 
trying to find Anchor Volume Descriptor (i.e. calling to 
udf_find_anchor()).

That said, all this patch does is updates the s_last_block 
even if the udf_vrs() returns positive value.

Originally written and tested by Yuri Per, ported on latest 
mainline by me.

Signed-off-by: Yuri Per <Yuri.Per@acronis.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Max Lyadvinsky <Max.Lyadvinsky@acronis.com>
Cc: Vladimir Simonov <Vladimir.Simonov@acronis.com>
Cc: Andrew Neporada <Andrew.Neporada@acronis.com>
Cc: Kirill Korotaev <dev@openvz.org>

---

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f3ac4ab..abd5e30 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1486,16 +1486,17 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
 	else {
+		struct udf_sb_info *sbi = UDF_SB(sb);
+
 		block = udf_vrs(sb, silent);
-		if (block == -1) {
-			struct udf_sb_info *sbi = UDF_SB(sb);
+		if (block == -1)
 			udf_debug("Failed to read byte 32768. Assuming open "
 				  "disc. Skipping validity check\n");
-			if (!sbi->s_last_block)
-				sbi->s_last_block = udf_get_last_block(sb);
-			return 0;
-		} else
-			return !block;
+
+		if (block && !sbi->s_last_block)
+			sbi->s_last_block = udf_get_last_block(sb);
+
+		return !block;
 	}
 }
 
