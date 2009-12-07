Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbZLGA1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbZLGA1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934385AbZLGA1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:27:46 -0500
Received: from kroah.org ([198.145.64.141]:34423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbZLGANK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000649.452381615@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Csaba Henk <csaba@gluster.com>, Miklos Szeredi <mszeredi@suse.cz>,
       Harshavardhana <harsha@gluster.com>
Subject: [052/119] fuse: reject O_DIRECT flag also in fuse_create
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=fuse-reject-o_direct-flag-also-in-fuse_create.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Csaba Henk <csaba@gluster.com>

commit 1b7323965a8c6eee9dc4e345a7ae4bff1dc93149 upstream.

The comment in fuse_open about O_DIRECT:

  "VFS checks this, but only _after_ ->open()"

also holds for fuse_create, however, the same kind of check was missing there.

As an impact of this bug, open(newfile, O_RDWR|O_CREAT|O_DIRECT) fails, but a
stub newfile will remain if the fuse server handled the implied FUSE_CREATE
request appropriately.

Other impact: in the above situation ima_file_free() will complain to open/free
imbalance if CONFIG_IMA is set.

Signed-off-by: Csaba Henk <csaba@gluster.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Harshavardhana <harsha@gluster.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dir.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -385,6 +385,9 @@ static int fuse_create_open(struct inode
 	if (fc->no_create)
 		return -ENOSYS;
 
+	if (flags & O_DIRECT)
+		return -EINVAL;
+
 	forget_req = fuse_get_req(fc);
 	if (IS_ERR(forget_req))
 		return PTR_ERR(forget_req);


