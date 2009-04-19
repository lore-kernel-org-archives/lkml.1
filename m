Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbZDSQlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbZDSQlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbZDSQkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:40:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520AbZDSQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:40:46 -0400
Date: Sun, 19 Apr 2009 18:40:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: [PATCH] Don't set relatime when noatime is specified
Message-ID: <20090419164043.GA32469@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't set relatime when noatime is specified

Since 

commit 0a1c01c9477602ee8b44548a9405b2c1d587b5a2
Author: Matthew Garrett <mjg@redhat.com>
Date:   Thu Mar 26 17:53:14 2009 +0000

    Make relatime default

when a file system is mounted explicitely with noatime it gets both
relatime and noatime set. 

This shows up like this in /proc/mounts:

/dev/xxx /yyy ext3 rw,noatime,relatime,errors=continue,data=writeback 0 0

That looks strange.  The VFS uses noatime in this case, but both
flags are set. So it's more a cosmetic issue, but still better
to fix.

Cc: mjg@redhat.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/namespace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.30-rc2-ak/fs/namespace.c
===================================================================
--- linux-2.6.30-rc2-ak.orig/fs/namespace.c	2009-04-08 12:15:15.000000000 +0200
+++ linux-2.6.30-rc2-ak/fs/namespace.c	2009-04-19 18:13:11.000000000 +0200
@@ -1920,8 +1920,9 @@
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
-	/* Default to relatime */
-	mnt_flags |= MNT_RELATIME;
+	/* Default to relatime unless overriden */
+	if (!(flags & MS_NOATIME))
+		mnt_flags |= MNT_RELATIME;
 
 	/* Separate the per-mountpoint flags */
 	if (flags & MS_NOSUID)
