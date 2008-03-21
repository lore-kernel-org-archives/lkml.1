Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbYCUXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbYCUXQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764222AbYCUW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:56:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41391 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764213AbYCUW4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:56:34 -0400
Message-Id: <20080321224353.317466740@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Miklos Szeredi <mszeredi@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 25/76] fuse: fix permission checking
Content-Disposition: inline; filename=fuse-fix-permission-checking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Miklos Szeredi <mszeredi@suse.cz>

[upstream commit 1a823ac9ff09cbdf39201df37b7ede1f9395de83]

I added a nasty local variable shadowing bug to fuse in 2.6.24, with the
result, that the 'default_permissions' mount option is basically ignored.

How did this happen?

 - old err declaration in inner scope
 - new err getting declared in outer scope
 - 'return err' from inner scope getting removed
 - old declaration not being noticed

-Wshadow would have saved us, but it doesn't seem practical for
the kernel :(

More testing would have also saved us :((

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -905,7 +905,7 @@ static int fuse_permission(struct inode 
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
-		int err = generic_permission(inode, mask, NULL);
+		err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root

-- 
