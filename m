Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbZAaDIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbZAaDIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbZAaCrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:42 -0500
Received: from kroah.org ([198.145.64.141]:55464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752998AbZAaCrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:33 -0500
Date: Fri, 30 Jan 2009 18:43:06 -0800
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
Subject: [patch 26/43] ext3: Add sanity check to make_indexed_dir
Message-ID: <20090131024306.GA12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext3-add-sanity-check-to-make_indexed_dir.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit a21102b55c4f8dfd3adb4a15a34cd62237b46039 upstream.

Make sure the rec_len field in the '..' entry is sane, lest we overrun
the directory block and cause a kernel oops on a purposefully
corrupted filesystem.

This fixes a bug related to a bug originally reported by Sami Liedes
for ext4 at:

http://bugzilla.kernel.org/show_bug.cgi?id=12430

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/namei.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1357,7 +1357,7 @@ static int make_indexed_dir(handle_t *ha
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk("Creating index\n"));
+	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
 	retval = ext3_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext3_std_error(dir->i_sb, retval);
@@ -1366,6 +1366,19 @@ static int make_indexed_dir(handle_t *ha
 	}
 	root = (struct dx_root *) bh->b_data;
 
+	/* The 0th block becomes the root, move the dirents out */
+	fde = &root->dotdot;
+	de = (struct ext3_dir_entry_2 *)((char *)fde +
+			ext3_rec_len_from_disk(fde->rec_len));
+	if ((char *) de >= (((char *) root) + blocksize)) {
+		ext3_error(dir->i_sb, __func__,
+			   "invalid rec_len for '..' in inode %lu",
+			   dir->i_ino);
+		brelse(bh);
+		return -EIO;
+	}
+	len = ((char *) root) + blocksize - (char *) de;
+
 	bh2 = ext3_append (handle, dir, &block, &retval);
 	if (!(bh2)) {
 		brelse(bh);
@@ -1374,11 +1387,6 @@ static int make_indexed_dir(handle_t *ha
 	EXT3_I(dir)->i_flags |= EXT3_INDEX_FL;
 	data1 = bh2->b_data;
 
-	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext3_dir_entry_2 *)((char *)fde +
-			ext3_rec_len_from_disk(fde->rec_len));
-	len = ((char *) root) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext3_dir_entry_2 *) data1;
 	top = data1 + len;

