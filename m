Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbXJZXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbXJZXmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbXJZXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:39:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12233 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764314AbXJZXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=ar7ODvAFDv05n1GfdRB8CMjcC6zn5Rsz21ByXmJ0KE6szbV3VRdk76qfwqWY6ZZQs
	TggThl05Z/ueUAk5RQy9w==
Message-Id: <20071026233848.192539989@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:34 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 2/6][RFC] Allow FIBMAP to return EFBIG on large filesystems.
Content-Disposition: inline; filename=add_fibmap_check_32bit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate an error (EFBIG) to userspace if the physical block is too large to return in a 32bit int instead of truncating it.

Signed-off-by: Mike Waychison <mikew@google.com>

 fs/ioctl.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:26:10.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 16:16:28.000000000 -0700
@@ -52,6 +52,7 @@ static int file_ioctl(struct file *filp,
 		case FIBMAP:
 		{
 			struct address_space *mapping = filp->f_mapping;
+			sector_t phys_block;
 			int res;
 			/* do we support this mess? */
 			if (!mapping->a_ops->bmap)
@@ -64,8 +65,15 @@ static int file_ioctl(struct file *filp,
 				return -EINVAL;
 
 			lock_kernel();
-			res = mapping->a_ops->bmap(mapping, block);
+			phys_block = mapping->a_ops->bmap(mapping, block);
 			unlock_kernel();
+
+			/* Make sure that the return value fits in the
+			 * user's buffer. */
+			if ((u32)phys_block < phys_block)
+				return -EFBIG;
+
+			res = phys_block;
 			return put_user(res, p);
 		}
 		case FIGETBSZ:

--
