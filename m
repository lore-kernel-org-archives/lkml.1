Return-Path: <linux-kernel-owner+w=401wt.eu-S935728AbZLQEE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935728AbZLQEE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761937AbZLQEET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:19 -0500
Received: from kroah.org ([198.145.64.141]:55477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763963AbZLQEEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:49 2009
Message-Id: <20091217035649.016670805@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>
Subject: [047/151] jbd2: dont wipe the journal on a failed journal checksum
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e6a47428de84e19fda52f21ab73fde2906c40d09 upstream.

If there is a failed journal checksum, don't reset the journal.  This
allows for userspace programs to decide how to recover from this
situation.  It may be that ignoring the journal checksum failure might
be a better way of recovering the file system.  Once we add per-block
checksums, we can definitely do better.  Until then, a system
administrator can try backing up the file system image (or taking a
snapshot) and and trying to determine experimentally whether ignoring
the checksum failure or aborting the journal replay results in less
data loss.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/journal.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1253,6 +1253,13 @@ int jbd2_journal_load(journal_t *journal
 	if (jbd2_journal_recover(journal))
 		goto recovery_error;
 
+	if (journal->j_failed_commit) {
+		printk(KERN_ERR "JBD2: journal transaction %u on %s "
+		       "is corrupt.\n", journal->j_failed_commit,
+		       journal->j_devname);
+		return -EIO;
+	}
+
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
 	 * and reset them on disk. */


