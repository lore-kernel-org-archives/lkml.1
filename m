Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYFGBNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYFGBNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbYFGBJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:01 -0400
Received: from sous-sol.org ([216.99.217.87]:42365 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbYFGBI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:59 -0400
Message-Id: <20080607010603.799687966@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:32 -0700
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
       Steve French <smfrench@gmail.com>, Steve French <sfrench@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 17/50] CIFS: Fix UNC path prefix on QueryUnixPathInfo to have correct slash
Content-Disposition: inline; filename=cifs-fix-unc-path-prefix-on-queryunixpathinfo-to-have-correct-slash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Steve French <sfrench@us.ibm.com>

upstream commit: 076d8423a98659a92837b07aa494cb74bfefe77c


When a share was in DFS and the server was Unix/Linux, we were sending paths of the form
    \\server\share/dir/file
rather than
    //server/share/dir/file

There was some discussion between me and jra over whether we should use
    /server/share/dir/file
as MS sometimes says - but the documentation for this claims it should be
doubleslash for this type of UNC-like path format and that works, so leaving
it as doubleslash but converting the \ to / in the the //server/share portion.

This gets Samba to now correctly return STATUS_PATH_NOT_COVERED when it is
supposed to (Windows already did since the direction of the slash was not an issue
for them).  Still need another minor change to fully enable DFS (need to finish
some chages to SMBGetDFSRefer

Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/inode.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -161,12 +161,14 @@ static void cifs_unix_info_to_inode(stru
 	spin_unlock(&inode->i_lock);
 }
 
-static const unsigned char *cifs_get_search_path(struct cifsTconInfo *pTcon,
-					const char *search_path)
+static const unsigned char *cifs_get_search_path(struct cifs_sb_info *cifs_sb,
+						const char *search_path)
 {
 	int tree_len;
 	int path_len;
+	int i;
 	char *tmp_path;
+	struct cifsTconInfo *pTcon = cifs_sb->tcon;
 
 	if (!(pTcon->Flags & SMB_SHARE_IS_IN_DFS))
 		return search_path;
@@ -180,6 +182,11 @@ static const unsigned char *cifs_get_sea
 		return search_path;
 
 	strncpy(tmp_path, pTcon->treeName, tree_len);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+		for (i = 0; i < tree_len; i++) {
+			if (tmp_path[i] == '\\')
+				tmp_path[i] = '/';
+		}
 	strncpy(tmp_path+tree_len, search_path, path_len);
 	tmp_path[tree_len+path_len] = 0;
 	return tmp_path;
@@ -199,7 +206,7 @@ int cifs_get_inode_info_unix(struct inod
 	pTcon = cifs_sb->tcon;
 	cFYI(1, ("Getting info on %s", search_path));
 
-	full_path = cifs_get_search_path(pTcon, search_path);
+	full_path = cifs_get_search_path(cifs_sb, search_path);
 
 try_again_CIFSSMBUnixQPathInfo:
 	/* could have done a find first instead but this returns more info */
@@ -402,7 +409,7 @@ int cifs_get_inode_info(struct inode **p
 			return -ENOMEM;
 		pfindData = (FILE_ALL_INFO *)buf;
 
-		full_path = cifs_get_search_path(pTcon, search_path);
+		full_path = cifs_get_search_path(cifs_sb, search_path);
 
 try_again_CIFSSMBQPathInfo:
 		/* could do find first instead but this returns more info */

-- 
