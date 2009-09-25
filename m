Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZIYTqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZIYTqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZIYTqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:46:46 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:32615 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbZIYTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:46:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0FAF+6vErCTtAn/2dsb2JhbACBUdVShB4FgVg
Date: Fri, 25 Sep 2009 21:46:36 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
Subject: [PATCH RFC] vfat and Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
Message-ID: <20090925194636.GA15700@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <20090323140005.GB25840@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323140005.GB25840@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello vfat guru's

I have an IOMEGA home network hard disk that I can connect either by
ethernet (ftp or cifs) or by USB. because of the ftp server mode
firmware, I must keep it formatted as a vfat filesystem.

I have copied my music files on it using the ftp mode.  Using the same
ftp mode, I can also retrieve my music files without problem, and
when I list them, they have the exact names that they had on my linux
ext3 partition.

When I connected this disk via USB, now relying on the vfat module
of linux, there were some directories that I could not reread.  The
common factor of these directories names is that they end with one or
more dots, e.g.

	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.

If I issue the `ls' or `find' command, I get this strange message :

find: ./Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.: No such file or directory

Adding printk's in `fat_search_long' revealed that on this disk, the
file/directory NAMES ENDING WITH DOTS ARE STORED WITH THEIR TRAILING DOTS.

Here is a patch squetch that make accessing my
 Simon_&_Garfunkel-Wednesday_Morning,_3_a.m. directory possible, but I
don't know if storing long filenames ending with dot's should not also
be fixed.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r f2c5827a8d44 fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c	Mon Aug 31 17:44:05 2009 -1000
+++ b/fs/fat/namei_vfat.c	Fri Sep 25 21:30:36 2009 +0200
@@ -702,10 +702,7 @@
 static int vfat_find(struct inode *dir, struct qstr *qname,
 		     struct fat_slot_info *sinfo)
 {
-	unsigned int len = vfat_striptail_len(qname);
-	if (len == 0)
-		return -ENOENT;
-	return fat_search_long(dir, qname->name, len, sinfo);
+	return fat_search_long(dir, qname->name, qname->len, sinfo);
 }
 
 static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
