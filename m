Return-Path: <linux-kernel-owner+w=401wt.eu-S1765224AbXG0NXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765224AbXG0NXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbXG0NXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:23:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46701 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbXG0NXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:23:44 -0400
Date: Fri, 27 Jul 2007 14:23:44 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix preprocessor idiocy in reiserfs
Message-ID: <20070727132344.GA27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	#x blocks expansion of macro argument, but it won't do you any
good if it's already been expanded...  As it is, RFALSE(cond, ....)
ended up with stringified _expanded_ cond.  Real fun when cond contains
something like le32_to_cpu() and you are on a big-endian box...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 965d5b3..180a9d8 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -81,14 +81,16 @@ void reiserfs_warning(struct super_block *s, const char *fmt, ...);
 /* assertions handling */
 
 /** always check a condition and panic if it's false. */
-#define RASSERT( cond, format, args... )					\
+#define __RASSERT( cond, scond, format, args... )					\
 if( !( cond ) ) 								\
-  reiserfs_panic( NULL, "reiserfs[%i]: assertion " #cond " failed at "	\
+  reiserfs_panic( NULL, "reiserfs[%i]: assertion " scond " failed at "	\
 		  __FILE__ ":%i:%s: " format "\n",		\
 		  in_interrupt() ? -1 : current -> pid, __LINE__ , __FUNCTION__ , ##args )
 
+#define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
+
 #if defined( CONFIG_REISERFS_CHECK )
-#define RFALSE( cond, format, args... ) RASSERT( !( cond ), format, ##args )
+#define RFALSE(cond, format, args...) __RASSERT(!(cond), "!(" #cond ")", format, ##args)
 #else
 #define RFALSE( cond, format, args... ) do {;} while( 0 )
 #endif
