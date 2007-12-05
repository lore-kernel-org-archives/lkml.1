Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXLEIZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXLEIZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXLEIY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:24:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60610 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXLEIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:24:58 -0500
Date: Wed, 5 Dec 2007 08:24:38 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shirish Pargaonkar <shirishp@us.ibm.com>, sfrench@samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] regression: cifs endianness bug
Message-ID: <20071205082438.GD8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	access_flags_to_mode() gets on-the-wire data (little-endian)
and treats it as host-endian.

Introduced in commit e01b64001359034d04c695388870936ed3d1b56b
([CIFS] enable get mode from ACL when cifsacl mount option specified)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f02fdef..c312adc 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -134,9 +134,10 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
    pmode is the existing mode (we only want to overwrite part of this
    bits to set can be: S_IRWXU, S_IRWXG or S_IRWXO ie 00700 or 00070 or 00007
 */
-static void access_flags_to_mode(__u32 ace_flags, int type, umode_t *pmode,
+static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 				 umode_t *pbits_to_set)
 {
+	__u32 flags = le32_to_cpu(ace_flags);
 	/* the order of ACEs is important.  The canonical order is to begin with
 	   DENY entries followed by ALLOW, otherwise an allow entry could be
 	   encountered first, making the subsequent deny entry like "dead code"
@@ -146,17 +147,17 @@ static void access_flags_to_mode(__u32 ace_flags, int type, umode_t *pmode,
 	/* For deny ACEs we change the mask so that subsequent allow access
 	   control entries do not turn on the bits we are denying */
 	if (type == ACCESS_DENIED) {
-		if (ace_flags & GENERIC_ALL) {
+		if (flags & GENERIC_ALL) {
 			*pbits_to_set &= ~S_IRWXUGO;
 		}
-		if ((ace_flags & GENERIC_WRITE) ||
-			((ace_flags & FILE_WRITE_RIGHTS) == FILE_WRITE_RIGHTS))
+		if ((flags & GENERIC_WRITE) ||
+			((flags & FILE_WRITE_RIGHTS) == FILE_WRITE_RIGHTS))
 			*pbits_to_set &= ~S_IWUGO;
-		if ((ace_flags & GENERIC_READ) ||
-			((ace_flags & FILE_READ_RIGHTS) == FILE_READ_RIGHTS))
+		if ((flags & GENERIC_READ) ||
+			((flags & FILE_READ_RIGHTS) == FILE_READ_RIGHTS))
 			*pbits_to_set &= ~S_IRUGO;
-		if ((ace_flags & GENERIC_EXECUTE) ||
-			((ace_flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
+		if ((flags & GENERIC_EXECUTE) ||
+			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 			*pbits_to_set &= ~S_IXUGO;
 		return;
 	} else if (type != ACCESS_ALLOWED) {
@@ -165,25 +166,25 @@ static void access_flags_to_mode(__u32 ace_flags, int type, umode_t *pmode,
 	}
 	/* else ACCESS_ALLOWED type */
 
-	if (ace_flags & GENERIC_ALL) {
+	if (flags & GENERIC_ALL) {
 		*pmode |= (S_IRWXUGO & (*pbits_to_set));
 #ifdef CONFIG_CIFS_DEBUG2
 		cFYI(1, ("all perms"));
 #endif
 		return;
 	}
-	if ((ace_flags & GENERIC_WRITE) ||
-			((ace_flags & FILE_WRITE_RIGHTS) == FILE_WRITE_RIGHTS))
+	if ((flags & GENERIC_WRITE) ||
+			((flags & FILE_WRITE_RIGHTS) == FILE_WRITE_RIGHTS))
 		*pmode |= (S_IWUGO & (*pbits_to_set));
-	if ((ace_flags & GENERIC_READ) ||
-			((ace_flags & FILE_READ_RIGHTS) == FILE_READ_RIGHTS))
+	if ((flags & GENERIC_READ) ||
+			((flags & FILE_READ_RIGHTS) == FILE_READ_RIGHTS))
 		*pmode |= (S_IRUGO & (*pbits_to_set));
-	if ((ace_flags & GENERIC_EXECUTE) ||
-			((ace_flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
+	if ((flags & GENERIC_EXECUTE) ||
+			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
 #ifdef CONFIG_CIFS_DEBUG2
-	cFYI(1, ("access flags 0x%x mode now 0x%x", ace_flags, *pmode));
+	cFYI(1, ("access flags 0x%x mode now 0x%x", flags, *pmode));
 #endif
 	return;
 }
