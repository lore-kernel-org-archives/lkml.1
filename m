Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZGHRYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZGHRYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZGHRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:24:10 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:46339 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbZGHRYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=gGy77SdPqPUHuA5dhUCxzyU6V8rYZQkP5OeihjXpBVSe2z0wR9dQMR6mLh/5tQRzTt
         VmKHD3E8oXGjGA1w/6LRTVdT29/5G5g86Bys8955QXB5S6eLt+UMWWfihIEuBPf5XUn9
         zPwbvItfqWWU+zfMRWcISCBOYSHV51qEZdxsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jan Kara <jack@suse.cz>
Subject: [PATCH] isofs: fix Joliet regression
Date: Wed, 8 Jul 2009 19:29:52 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090618-10582-g427bc60; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081929.54372.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] isofs: fix Joliet regression

commit 5404ac8e4418ab3d254950ee4f9bcafc1da20b4a ("isofs: cleanup mount
option processing") missed conversion of joliet option flag resulting
in non-working Joliet support.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I really want to believe that this is just the unlucky coincidence with
the ongoing vfat madness...

 fs/isofs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/fs/isofs/inode.c
===================================================================
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -142,6 +142,7 @@ static const struct dentry_operations is
 
 struct iso9660_options{
 	unsigned int rock:1;
+	unsigned int joliet:1;
 	unsigned int cruft:1;
 	unsigned int hide:1;
 	unsigned int showassoc:1;
@@ -151,7 +152,6 @@ struct iso9660_options{
 	unsigned int gid_set:1;
 	unsigned int utf8:1;
 	unsigned char map;
-	char joliet;
 	unsigned char check;
 	unsigned int blocksize;
 	mode_t fmode;
@@ -632,7 +632,7 @@ static int isofs_fill_super(struct super
 			else if (isonum_711(vdp->type) == ISO_VD_SUPPLEMENTARY) {
 				sec = (struct iso_supplementary_descriptor *)vdp;
 				if (sec->escape[0] == 0x25 && sec->escape[1] == 0x2f) {
-					if (opt.joliet == 'y') {
+					if (opt.joliet) {
 						if (sec->escape[2] == 0x40)
 							joliet_level = 1;
 						else if (sec->escape[2] == 0x43)
