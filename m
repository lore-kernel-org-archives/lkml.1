Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbYFNA0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbYFNA0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762253AbYFNAPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:18 -0400
Received: from ns.suse.de ([195.135.220.2]:34597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761307AbYFNAPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:16 -0400
Date: Fri, 13 Jun 2008 17:12:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 41/47] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL
	is enabled
Message-ID: <20080614001209.GO24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcin Slusarz <marcin.slusarz@gmail.com>

simple "mount -t cifs //xxx /mnt" oopsed on strlen of options
http://kerneloops.org/guilty.php?guilty=cifs_get_sb&version=2.6.25-release&start=16711 \
68&end=1703935&class=oops

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsfs.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -97,9 +97,6 @@ cifs_read_super(struct super_block *sb, 
 {
 	struct inode *inode;
 	struct cifs_sb_info *cifs_sb;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	int len;
-#endif
 	int rc = 0;
 
 	/* BB should we make this contingent on mount parm? */
@@ -117,15 +114,17 @@ cifs_read_super(struct super_block *sb, 
 	 * complex operation (mount), and in case of fail
 	 * just exit instead of doing mount and attempting
 	 * undo it if this copy fails?*/
-	len = strlen(data);
-	cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
-	if (cifs_sb->mountdata == NULL) {
-		kfree(sb->s_fs_info);
-		sb->s_fs_info = NULL;
-		return -ENOMEM;
+	if (data) {
+		int len = strlen(data);
+		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
+		if (cifs_sb->mountdata == NULL) {
+			kfree(sb->s_fs_info);
+			sb->s_fs_info = NULL;
+			return -ENOMEM;
+		}
+		strncpy(cifs_sb->mountdata, data, len + 1);
+		cifs_sb->mountdata[len] = '\0';
 	}
-	strncpy(cifs_sb->mountdata, data, len + 1);
-	cifs_sb->mountdata[len] = '\0';
 #endif
 
 	rc = cifs_mount(sb, cifs_sb, data, devname);

-- 
