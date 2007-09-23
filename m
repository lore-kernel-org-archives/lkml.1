Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXIWJjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXIWJjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 05:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXIWJi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 05:38:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48265 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXIWJi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 05:38:59 -0400
Date: Sun, 23 Sep 2007 11:38:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [RFC] New kernel-message logging API
In-Reply-To: <19f34abd0709230220h6d37c27bva2d5502f9f0d6931@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709231134480.15712@fbirervta.pbzchgretzou.qr>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> 
 <1190506383.30132.11.camel@localhost>  <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
  <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
 <19f34abd0709230220h6d37c27bva2d5502f9f0d6931@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23 2007 11:20, Vegard Nossum wrote:
>> >printk(KERN_INFO "Message.\n");
>> >kprint_info("Message.");
>>
>> I'd rather fix up code to reduce its indent rather than
>> trying microoptimizations at the function name level!
>
>Well, that's a different discussion, really. Is fixing the body of
>[v]printk() enough?

I mean the bodies of functions calling printk. (where possible)
Like this:

diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index c519a58..49e04e7 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -86,12 +86,12 @@ static int v2_write_file_info(struct super_block *sb, int type)
 	dinfo.dqi_free_entry = cpu_to_le32(info->u.v2_i.dqi_free_entry);
 	size = sb->s_op->quota_write(sb, type, (char *)&dinfo,
 	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
-	if (size != sizeof(struct v2_disk_dqinfo)) {
-		printk(KERN_WARNING "Can't write info structure on device %s.\n",
-			sb->s_id);
-		return -1;
-	}
-	return 0;
+	if (size == sizeof(struct v2_disk_dqinfo))
+		return 0;
+
+	printk(KERN_WARNING "Can't write info structure on device %s.\n",
+		sb->s_id);
+	return -1;
 }
 
 static void disk2memdqb(struct mem_dqblk *m, struct v2_disk_dqblk *d)


I gained 8 columns _without_ fiddling with the names.
