Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbYLCUWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbYLCUWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYLCT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:46 -0500
Received: from kroah.org ([198.145.64.141]:56572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754012AbYLCT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:43 -0500
Date: Wed, 3 Dec 2008 11:56:08 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [patch 081/104] jbd2: fix /proc setup for devices that contain /
	in their names
Message-ID: <20081203195608.GD8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd2-fix-proc-setup-for-devices-that-contain-in-their-names.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

trimed down version of commit 05496769e5da83ce22ed97345afd9c7b71d6bd24 upstream.

Some devices such as "cciss/c0d0p9" will cause jbd2 setup and teardown
failures when /proc filenames are created with embedded slashes.  This
is a slimmed down version of commit 05496769, with the stack reduction
aspects of the patch omitted to meet the -stable criteria.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/journal.c    |   22 ++++++++++++++--------
 include/linux/jbd2.h |    3 ++-
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -901,10 +901,7 @@ static struct proc_dir_entry *proc_jbd2_
 
 static void jbd2_stats_proc_init(journal_t *journal)
 {
-	char name[BDEVNAME_SIZE];
-
-	bdevname(journal->j_dev, name);
-	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
+	journal->j_proc_entry = proc_mkdir(journal->j_devname, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
 		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
 				 &jbd2_seq_history_fops, journal);
@@ -915,12 +912,9 @@ static void jbd2_stats_proc_init(journal
 
 static void jbd2_stats_proc_exit(journal_t *journal)
 {
-	char name[BDEVNAME_SIZE];
-
-	bdevname(journal->j_dev, name);
 	remove_proc_entry("info", journal->j_proc_entry);
 	remove_proc_entry("history", journal->j_proc_entry);
-	remove_proc_entry(name, proc_jbd2_stats);
+	remove_proc_entry(journal->j_devname, proc_jbd2_stats);
 }
 
 static void journal_init_stats(journal_t *journal)
@@ -1018,6 +1012,7 @@ journal_t * jbd2_journal_init_dev(struct
 {
 	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
+	char *p;
 	int n;
 
 	if (!journal)
@@ -1039,6 +1034,10 @@ journal_t * jbd2_journal_init_dev(struct
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
@@ -1061,6 +1060,7 @@ journal_t * jbd2_journal_init_inode (str
 {
 	struct buffer_head *bh;
 	journal_t *journal = journal_init_common();
+	char *p;
 	int err;
 	int n;
 	unsigned long long blocknr;
@@ -1070,6 +1070,12 @@ journal_t * jbd2_journal_init_inode (str
 
 	journal->j_dev = journal->j_fs_dev = inode->i_sb->s_bdev;
 	journal->j_inode = inode;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
+	p = journal->j_devname + strlen(journal->j_devname);
+	sprintf(p, ":%lu", journal->j_inode->i_ino);
 	jbd_debug(1,
 		  "journal %p: inode %s/%ld, size %Ld, bits %d, blksize %ld\n",
 		  journal, inode->i_sb->s_id, inode->i_ino,
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -850,7 +850,8 @@ struct journal_s
 	 */
 	struct block_device	*j_dev;
 	int			j_blocksize;
-	unsigned long long		j_blk_offset;
+	unsigned long long	j_blk_offset;
+	char			j_devname[BDEVNAME_SIZE+24];
 
 	/*
 	 * Device which holds the client fs.  For internal journal this will be

