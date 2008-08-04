Return-Path: <linux-kernel-owner+w=401wt.eu-S1765113AbYHDUd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765113AbYHDUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764876AbYHDUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:32:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:46251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764869AbYHDUc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:32:57 -0400
Date: Mon, 4 Aug 2008 13:16:31 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 33/33] vfs: fix lookup on deleted directory
Message-ID: <20080804201631.GH1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vfs-fix-lookup-on-deleted-directory.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit d70b67c8bc72ee23b55381bd6a884f4796692f77 upstream

Lookup can install a child dentry for a deleted directory.  This keeps
the directory dentry alive, and the inode pinned in the cache and on
disk, even after all external references have gone away.

This isn't a big problem normally, since memory pressure or umount
will clear out the directory dentry and its children, releasing the
inode.  But for UBIFS this causes problems because its orphan area can
overflow.

Fix this by returning ENOENT for all lookups on a S_DEAD directory
before creating a child dentry.

Thanks to Zoltan Sogor for noticing this while testing UBIFS, and
Artem for the excellent analysis of the problem and testing.

Reported-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -514,7 +514,14 @@ static struct dentry * real_lookup(struc
 	 */
 	result = d_lookup(parent, name);
 	if (!result) {
-		struct dentry * dentry = d_alloc(parent, name);
+		struct dentry *dentry;
+
+		/* Don't create child dentry for a dead directory. */
+		result = ERR_PTR(-ENOENT);
+		if (IS_DEADDIR(dir))
+			goto out_unlock;
+
+		dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
 		if (dentry) {
 			result = dir->i_op->lookup(dir, dentry, nd);
@@ -523,6 +530,7 @@ static struct dentry * real_lookup(struc
 			else
 				result = dentry;
 		}
+out_unlock:
 		mutex_unlock(&dir->i_mutex);
 		return result;
 	}
@@ -1313,7 +1321,14 @@ static struct dentry *__lookup_hash(stru
 
 	dentry = cached_lookup(base, name, nd);
 	if (!dentry) {
-		struct dentry *new = d_alloc(base, name);
+		struct dentry *new;
+
+		/* Don't create child dentry for a dead directory. */
+		dentry = ERR_PTR(-ENOENT);
+		if (IS_DEADDIR(inode))
+			goto out;
+
+		new = d_alloc(base, name);
 		dentry = ERR_PTR(-ENOMEM);
 		if (!new)
 			goto out;

-- 
