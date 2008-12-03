Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYLCUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYLCUap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYLCT6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:58:31 -0500
Received: from kroah.org ([198.145.64.141]:56816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756101AbYLCT6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:07 -0500
Date: Wed, 3 Dec 2008 11:56:51 -0800
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
       alan@lxorguk.ukuu.org.uk
Subject: [patch 100/104] ext3: Fix duplicate entries returned from
	getdents() system call
Message-ID: <20081203195651.GW8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext3-fix-duplicate-entries-returned-from-getdents-system-call.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Theodore Ts'o <tytso@mit.edu>

commit 8c9fa93d51123c5540762b1a9e1919d6f9c4af7c upstream.

Fix a regression caused by commit 6a897cf4, "ext3: fix ext3_dx_readdir
hash collision handling", where deleting files in a large directory
(requiring more than one getdents system call), results in some
filenames being returned twice.  This was caused by a failure to
update info->curr_hash and info->curr_minor_hash, so that if the
directory had gotten modified since the last getdents() system call
(as would be the case if the user is running "rm -r" or "git clean"),
a directory entry would get returned twice to the userspace.

This patch fixes the bug reported by Markus Trippelsdorf at:
http://bugzilla.kernel.org/show_bug.cgi?id=11844

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/dir.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -456,17 +456,8 @@ static int ext3_dx_readdir(struct file *
 	if (info->extra_fname) {
 		if (call_filldir(filp, dirent, filldir, info->extra_fname))
 			goto finished;
-
 		info->extra_fname = NULL;
-		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
-			if (info->next_hash == ~0) {
-				filp->f_pos = EXT3_HTREE_EOF;
-				goto finished;
-			}
-			info->curr_hash = info->next_hash;
-			info->curr_minor_hash = 0;
-		}
+		goto next_node;
 	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
@@ -498,9 +489,14 @@ static int ext3_dx_readdir(struct file *
 		info->curr_minor_hash = fname->minor_hash;
 		if (call_filldir(filp, dirent, filldir, fname))
 			break;
-
+	next_node:
 		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
+		if (info->curr_node) {
+			fname = rb_entry(info->curr_node, struct fname,
+					 rb_hash);
+			info->curr_hash = fname->hash;
+			info->curr_minor_hash = fname->minor_hash;
+		} else {
 			if (info->next_hash == ~0) {
 				filp->f_pos = EXT3_HTREE_EOF;
 				break;

