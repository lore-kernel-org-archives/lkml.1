Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYLCUbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYLCUbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYLCT6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:58:32 -0500
Received: from kroah.org ([198.145.64.141]:56806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753570AbYLCT6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:06 -0500
Date: Wed, 3 Dec 2008 11:56:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Eugene Dashevsky <eugene@ibrix.com>,
       Mike Snitzer <msnitzer@ibrix.com>
Subject: [patch 099/104] ext3: fix ext3_dx_readdir hash collision handling
Message-ID: <20081203195648.GV8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext3-fix-ext3_dx_readdir-hash-collision-handling.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eugene Dashevsky <eugene@ibrix.com>

commit 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d upstream.

This fixes a bug where readdir() would return a directory entry twice
if there was a hash collision in an hash tree indexed directory.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/dir.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -414,7 +414,7 @@ static int call_filldir(struct file * fi
 				get_dtype(sb, fname->file_type));
 		if (error) {
 			filp->f_pos = curr_pos;
-			info->extra_fname = fname->next;
+			info->extra_fname = fname;
 			return error;
 		}
 		fname = fname->next;
@@ -453,11 +453,21 @@ static int ext3_dx_readdir(struct file *
 	 * If there are any leftover names on the hash collision
 	 * chain, return them first.
 	 */
-	if (info->extra_fname &&
-	    call_filldir(filp, dirent, filldir, info->extra_fname))
-		goto finished;
+	if (info->extra_fname) {
+		if (call_filldir(filp, dirent, filldir, info->extra_fname))
+			goto finished;
 
-	if (!info->curr_node)
+		info->extra_fname = NULL;
+		info->curr_node = rb_next(info->curr_node);
+		if (!info->curr_node) {
+			if (info->next_hash == ~0) {
+				filp->f_pos = EXT3_HTREE_EOF;
+				goto finished;
+			}
+			info->curr_hash = info->next_hash;
+			info->curr_minor_hash = 0;
+		}
+	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {

