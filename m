Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZDFDnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZDFDnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 23:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZDFDnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 23:43:35 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47749 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZDFDne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 23:43:34 -0400
Date: Sun, 5 Apr 2009 20:44:20 -0700
From: Randy Robertson <rmrobert@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH] initramfs: Fix initramfs to work with hardlinked init.
Message-ID: <20090406034420.GB13424@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change cb6ff208076b5f434db1b8c983429269d719cef5 seems to have broken
booting from initramfs with /sbin/init being a hardlink.  It seems like
the logic required for XIP on nommu, i.e. ftruncate to reported cpio
header file size (body_len) is broken for hardlinks, which have
a reported size of 0, and the truncate thus nukes the contents of the
file (in my case busybox), making boot impossible and ending with runaway
loop modprobe binfmt-0000 - and of course 0000 is not a valid binary format.

My fix is to only call ftruncate if size is non-zero which fixes things
for me, but I'm not certain whether this will break XIP for those files
on nommu systems, although I would guess not.

Signed-off-by: Randy Robertson <rmrobert@vmware.com>
---
diff --git a/init/initramfs.c b/init/initramfs.c
index d9c941c..4675f62 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -317,7 +317,8 @@ static int __init do_name(void)
			if (wfd >= 0) {
				sys_fchown(wfd, uid, gid);
				sys_fchmod(wfd, mode);
-			       sys_ftruncate(wfd, body_len);
+			       if (body_len)
+				       sys_ftruncate(wfd, body_len);
				vcollected = kstrdup(collected, GFP_KERNEL);
				state = CopyFile;
			}
