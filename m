Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbYHDUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbYHDUVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761980AbYHDUUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:20:47 -0400
Received: from mail.suse.de ([195.135.220.2]:48319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205AbYHDUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:20:47 -0400
Date: Mon, 4 Aug 2008 13:14:47 -0700
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
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 04/33] return to old errno choice in mkdir() et.al.
Message-ID: <20080804201447.GE1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="return-to-old-errno-choice-in-mkdir-et.al.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e9baf6e59842285bcf9570f5094e4c27674a0f7c upstream

	In case when both EEXIST and EROFS would apply we used to
return the former in mkdir(2) and friends.  Lest anyone suspects
us of being consistent, in the same situation knfsd gave clients
nfs_erofs...

	ro-bind series had switched the syscall side of things to
returning -EROFS and immediately broke an application - namely,
mkdir -p.  Patch restores the original behaviour...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1904,18 +1904,22 @@ struct dentry *lookup_create(struct name
 	if (IS_ERR(dentry))
 		goto fail;
 
+	if (dentry->d_inode)
+		goto eexist;
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
 	 * From the vfs_mknod() POV we just have a negative dentry -
 	 * all is fine. Let's be bastards - you had / on the end, you've
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
-	if (!is_dir && nd->last.name[nd->last.len] && !dentry->d_inode)
-		goto enoent;
+	if (unlikely(!is_dir && nd->last.name[nd->last.len])) {
+		dput(dentry);
+		dentry = ERR_PTR(-ENOENT);
+	}
 	return dentry;
-enoent:
+eexist:
 	dput(dentry);
-	dentry = ERR_PTR(-ENOENT);
+	dentry = ERR_PTR(-EEXIST);
 fail:
 	return dentry;
 }

-- 
