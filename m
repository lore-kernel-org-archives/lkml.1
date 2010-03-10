Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0CJMdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:33:05 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:22873 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049Ab0CJMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:33:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJYfl0vCTtAn/2dsb2JhbACbB3O7foR5BA
Date: Wed, 10 Mar 2010 13:32:57 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH vfat] allow retrieving entries with trailing dots
Message-ID: <20100310123257.GA2899@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ogawa,

This fixes accessing vfat entries with trailing dots created by an external
vfat driver (like the one in IOMEGA home network hard drives)

Philippe

--

Some vfat-formatted network disks that are also usb disk do not discard
trailing dots when creating files or directories via ftp.
Connecting afterwards this drive via usb to a linux machine leads to the
following problem :
if one issues the `ls' or `find' command, one gets this message :

find: ./Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.: No such file or directory

Fix that by first trying to retrieve the entry with the full name, and only if
that fails and there are trailing dots in the searched name, try then to find
the truncated name.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

--- a/fs/fat/namei_vfat.c	2009-09-10 00:13:59.000000000 +0200
+++ b/fs/fat/namei_vfat.c	2010-02-08 02:28:37.010096903 +0100
@@ -702,9 +702,22 @@
 static int vfat_find(struct inode *dir, struct qstr *qname,
 		     struct fat_slot_info *sinfo)
 {
-	unsigned int len = vfat_striptail_len(qname);
+	int err;
+	unsigned int len;
+
+	/* Some combined ethernet + usb external hard drive do not
+	 * remove the trailing dots when creating entries in ethernet mode.
+	 * (e.g. Iomega Home Network Hard Drive)
+	 * Make accessing those entries possible.
+	 */
+	err = fat_search_long(dir, qname->name, qname->len, sinfo);
+	if (!err)
+		return err;
+	len = vfat_striptail_len(qname);
 	if (len == 0)
 		return -ENOENT;
+	if (len == qname->len)
+		return err;
 	return fat_search_long(dir, qname->name, len, sinfo);
 }
 

