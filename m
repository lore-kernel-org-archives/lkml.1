Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYGVXZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYGVXZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbYGVXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:22 -0400
Received: from mail.suse.de ([195.135.220.2]:53116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbYGVXTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:21 -0400
Date: Tue, 22 Jul 2008 16:16:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>
Subject: [patch 21/47] reiserfs: discard prealloc in reiserfs_delete_inode
Message-ID: <20080722231609.GV8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeff Mahoney <jeffm@suse.com>

commit eb35c218d83ec0780d9db869310f2e333f628702 upstream

With the removal of struct file from the xattr code,
reiserfs_file_release() isn't used anymore, so the prealloc isn't
discarded.  This causes hangs later down the line.

This patch adds it to reiserfs_delete_inode.  In most cases it will be a
no-op due to it already having been called, but will avoid hangs with
xattrs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode 
 			goto out;
 		reiserfs_update_inode_transaction(inode);
 
+		reiserfs_discard_prealloc(&th, inode);
+
 		err = reiserfs_delete_object(&th, inode);
 
 		/* Do quota update inside a transaction for journaled quotas. We must do that

-- 
