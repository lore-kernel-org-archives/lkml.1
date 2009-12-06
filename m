Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZLFXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZLFXi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZLFXiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:38:54 -0500
Received: from kroah.org ([198.145.64.141]:33818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZLFXir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:10 2009
Message-Id: <20091206233210.067773370@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Anand V. Avati" <avati@gluster.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [13/20] fuse: prevent fuse_put_request on invalid pointer
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=fuse-prevent-fuse_put_request-on-invalid-pointer.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Anand V. Avati <avati@gluster.com>

commit f60311d5f7670d9539b424e4ed8b5c0872fc9e83 upstream.

fuse_direct_io() has a loop where requests are allocated in each
iteration. if allocation fails, the loop is broken out and follows
into an unconditional fuse_put_request() on that invalid pointer.

Signed-off-by: Anand V. Avati <avati@gluster.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1005,7 +1005,8 @@ static ssize_t fuse_direct_io(struct fil
 				break;
 		}
 	}
-	fuse_put_request(fc, req);
+	if (!IS_ERR(req))
+		fuse_put_request(fc, req);
 	if (res > 0) {
 		if (write)
 			fuse_write_update_size(inode, pos);


