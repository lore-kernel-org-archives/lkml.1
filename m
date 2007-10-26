Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXJZXlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXJZXlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764682AbXJZXi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXJZXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=cfPcouFZG/eZoriVJTfaxuDRkY0Riz4FP/oF8dyAiTYQ29G0dXSFMhFM9//9iGAJq
	XnBHsZQRu1b+rAYo4LgiQ==
Message-Id: <20071026233848.447619470@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:35 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 3/6][RFC] Move FIBMAP logic
Content-Disposition: inline; filename=move_fibmap_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move FIBMAP logic out of file_ioctl() in preparation for introducing FIBMAP64.

Signed-off-by: Mike Waychison <mikew@google.com>
 fs/ioctl.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:26:11.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 16:16:28.000000000 -0700
@@ -40,6 +40,21 @@ static long do_ioctl(struct file *filp, 
 	return error;
 }
 
+static int do_fibmap(struct address_space *mapping, sector_t block,
+		     sector_t *phys_block)
+{
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	if (!mapping->a_ops->bmap)
+		return -EINVAL;
+
+	lock_kernel();
+	*phys_block = mapping->a_ops->bmap(mapping, block);
+	unlock_kernel();
+
+	return 0;
+}
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
@@ -55,18 +70,14 @@ static int file_ioctl(struct file *filp,
 			sector_t phys_block;
 			int res;
 			/* do we support this mess? */
-			if (!mapping->a_ops->bmap)
-				return -EINVAL;
-			if (!capable(CAP_SYS_RAWIO))
-				return -EPERM;
 			if ((error = get_user(block, p)) != 0)
 				return error;
 			if (block < 0)
 				return -EINVAL;
 
-			lock_kernel();
-			phys_block = mapping->a_ops->bmap(mapping, block);
-			unlock_kernel();
+			error = do_fibmap(mapping, block, &phys_block);
+			if (error)
+				return error;
 
 			/* Make sure that the return value fits in the
 			 * user's buffer. */

--
