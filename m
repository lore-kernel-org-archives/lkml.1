Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZDFTVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZDFTVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDFTVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:21:46 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58782 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZDFTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:21:45 -0400
Date: Mon, 6 Apr 2009 12:22:38 -0700
From: Randy Robertson <rmrobert@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH] initramfs: Fix initramfs to work with hardlinked init
Message-ID: <20090406192238.GA6621@vmware.com>
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

This update adds David's ack and fixes whitespace.

Signed-off-by: Randy Robertson <rmrobert@vmware.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 init/initramfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 80cd713..ddf30d1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -310,7 +310,8 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
-				sys_ftruncate(wfd, body_len);
+				if (body_len)
+					sys_ftruncate(wfd, body_len);
 				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
