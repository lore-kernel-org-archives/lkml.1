Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZAaDAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZAaDAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZAaCrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:20 -0500
Received: from kroah.org ([198.145.64.141]:55184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756291AbZAaCrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:11 -0500
Date: Fri, 30 Jan 2009 18:42:23 -0800
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
Subject: [patch 05/43] fuse: fix missing fput on error
Message-ID: <20090131024223.GF12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fuse-fix-missing-fput-on-error.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 3ddf1e7f57237ac7c5d5bfb7058f1ea4f970b661 upstream.

Fix the leaking file reference if allocation or initialization of
fuse_conn failed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -825,12 +825,16 @@ static int fuse_fill_super(struct super_
 	if (!file)
 		return -EINVAL;
 
-	if (file->f_op != &fuse_dev_operations)
+	if (file->f_op != &fuse_dev_operations) {
+		fput(file);
 		return -EINVAL;
+	}
 
 	fc = new_conn(sb);
-	if (!fc)
+	if (!fc) {
+		fput(file);
 		return -ENOMEM;
+	}
 
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;

