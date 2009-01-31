Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbZAaC75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbZAaC75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZAaCrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:19 -0500
Received: from kroah.org ([198.145.64.141]:55169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756251AbZAaCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:10 -0500
Date: Fri, 30 Jan 2009 18:42:21 -0800
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
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 04/43] fuse: destroy bdi on umount
Message-ID: <20090131024221.GE12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fuse-destroy-bdi-on-umount.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 26c3679101dbccc054dcf370143941844ba70531 upstream.

If a fuse filesystem is unmounted but the device file descriptor
remains open and a new mount reuses the old device number, then the
mount fails with EEXIST and the following warning is printed in the
kernel log:

  WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x35/0x3d()
  sysfs: duplicate filename '0:15' can not be created

The cause is that the bdi belonging to the fuse filesystem was
destoryed only after the device file was released.  Fix this by
calling bdi_destroy() from fuse_put_super() instead.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c   |    3 ++-
 fs/fuse/inode.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -281,7 +281,8 @@ static void request_end(struct fuse_conn
 			fc->blocked = 0;
 			wake_up_all(&fc->blocked_waitq);
 		}
-		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+		if (fc->num_background == FUSE_CONGESTION_THRESHOLD &&
+		    fc->connected) {
 			clear_bdi_congested(&fc->bdi, READ);
 			clear_bdi_congested(&fc->bdi, WRITE);
 		}
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -292,6 +292,7 @@ static void fuse_put_super(struct super_
 	list_del(&fc->entry);
 	fuse_ctl_remove_conn(fc);
 	mutex_unlock(&fuse_mutex);
+	bdi_destroy(&fc->bdi);
 	fuse_conn_put(fc);
 }
 
@@ -531,7 +532,6 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
 		mutex_destroy(&fc->inst_mutex);
-		bdi_destroy(&fc->bdi);
 		kfree(fc);
 	}
 }

