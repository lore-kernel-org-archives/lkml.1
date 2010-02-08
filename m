Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0BHJjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:39:32 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:56232 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab0BHJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:39:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFABtpb0vCTtAn/2dsb2JhbACBMtVYhFQE
Date: Mon, 8 Feb 2010 10:39:24 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH vfat] allow retrieving entries with trailing dots
Message-ID: <20100208093924.GA29937@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <20090323140005.GB25840@frolo.macqel> <20090925194636.GA15700@frolo.macqel> <87vdj2ysk8.fsf@devron.myhome.or.jp> <20090929102559.GA4590@frolo.macqel> <20090929224340.GA9730@frolo.macqel> <87ljjwzoeu.fsf@devron.myhome.or.jp> <20090930221957.GA31007@frolo.macqel> <87bpkrz98e.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpkrz98e.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes accessing vfat entries with trailing dots created by an external
vfat driver (like the one in IOMEGA home network hard drives)

Philippe

--

Some vfat-formatted network disks that are also usb disk do not discard
trailing dots when creating files or directories via ftp.
When connected via usb to a linux machine, that leads to this problem :
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
 
