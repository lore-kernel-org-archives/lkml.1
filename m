Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYLCUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYLCUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYLCT57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:59 -0500
Received: from kroah.org ([198.145.64.141]:56659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755237AbYLCT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:52 -0500
Date: Wed, 3 Dec 2008 11:56:22 -0800
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
Subject: [patch 088/104] jbd2: Fix buffer head leak when writing the commit
	block
Message-ID: <20081203195622.GK8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd2-fix-buffer-head-leak-when-writing-the-commit-block.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 45a90bfd90c1215bf824c0f705b409723f52361b)

Also make sure the buffer heads are marked clean before submitting bh
for writing.  The previous code was marking the buffer head dirty,
which would have forced an unneeded write (and seek) to the journal
for no good reason.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/commit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -126,8 +126,7 @@ static int journal_submit_commit_record(
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-	get_bh(bh);
-	set_buffer_dirty(bh);
+	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
@@ -160,7 +159,7 @@ static int journal_submit_commit_record(
 		/* And try again, without the barrier */
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
-		set_buffer_dirty(bh);
+		clear_buffer_dirty(bh);
 		ret = submit_bh(WRITE, bh);
 	}
 	*cbh = bh;

