Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXC3VMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXC3VMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbXC3VMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51714 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbXC3VMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:13 -0400
Date: Fri, 30 Mar 2007 14:06:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Prasad Potluri <pvp@us.ibm.com>,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 30/37] CIFS: Allow reset of file to ATTR_NORMAL when
	archive bit not set
Message-ID: <20070330210644.GG29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-allow-reset-of-file-to-attr_normal-when-archive-bit-not-set.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

[CIFS] Allow reset of file to ATTR_NORMAL when archive bit not set

When a file had a dos attribute of 0x1 (readonly - but dos attribute
of archive was not set) - doing chmod 0777 or equivalent would
try to set a dos attribute of 0 (which some servers ignore)
rather than ATTR_NORMAL (0x20) which most servers accept.
Does not affect servers which support the CIFS Unix Extensions.

[<cebbert@redhat.com>: removed changelog part of patch]

Cc: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Prasad Potluri <pvp@us.ibm.com>
Acked-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/inode.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1133,6 +1133,7 @@ int cifs_setattr(struct dentry *direntry
 	struct cifsFileInfo *open_file = NULL;
 	FILE_BASIC_INFO time_buf;
 	int set_time = FALSE;
+	int set_dosattr = FALSE;
 	__u64 mode = 0xFFFFFFFFFFFFFFFFULL;
 	__u64 uid = 0xFFFFFFFFFFFFFFFFULL;
 	__u64 gid = 0xFFFFFFFFFFFFFFFFULL;
@@ -1269,15 +1270,23 @@ int cifs_setattr(struct dentry *direntry
 	else if (attrs->ia_valid & ATTR_MODE) {
 		rc = 0;
 		if ((mode & S_IWUGO) == 0) /* not writeable */ {
-			if ((cifsInode->cifsAttrs & ATTR_READONLY) == 0)
+			if ((cifsInode->cifsAttrs & ATTR_READONLY) == 0) {
+				set_dosattr = TRUE;
 				time_buf.Attributes =
 					cpu_to_le32(cifsInode->cifsAttrs |
 						    ATTR_READONLY);
+			}
 		} else if ((mode & S_IWUGO) == S_IWUGO) {
-			if (cifsInode->cifsAttrs & ATTR_READONLY)
+			if (cifsInode->cifsAttrs & ATTR_READONLY) {
+				set_dosattr = TRUE;
 				time_buf.Attributes =
 					cpu_to_le32(cifsInode->cifsAttrs &
 						    (~ATTR_READONLY));
+				/* Windows ignores set to zero */
+				if(time_buf.Attributes == 0)
+					time_buf.Attributes |=
+						cpu_to_le32(ATTR_NORMAL);
+			}
 		}
 		/* BB to be implemented -
 		   via Windows security descriptors or streams */
@@ -1315,7 +1324,7 @@ int cifs_setattr(struct dentry *direntry
 	} else
 		time_buf.ChangeTime = 0;
 
-	if (set_time || time_buf.Attributes) {
+	if (set_time || set_dosattr) {
 		time_buf.CreationTime = 0;	/* do not change */
 		/* In the future we should experiment - try setting timestamps
 		   via Handle (SetFileInfo) instead of by path */

-- 
