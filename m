Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbZLKEou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbZLKEou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZLKEos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:44:48 -0500
Received: from kroah.org ([198.145.64.141]:37095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762230AbZLKEgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:41 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:15 2009
Message-Id: <20091211042815.186798204@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [76/90] jbd2: Add ENOMEM checking in and for jbd2_journal_write_metadata_buffer()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0076-jbd2-Add-ENOMEM-checking-in-and-for-jbd2_journal_wri.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit e6ec116b67f46e0e7808276476554727b2e6240b)

OOM happens.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd2/commit.c  |    4 ++++
 fs/jbd2/journal.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -636,6 +636,10 @@ void jbd2_journal_commit_transaction(jou
 		JBUFFER_TRACE(jh, "ph3: write metadata");
 		flags = jbd2_journal_write_metadata_buffer(commit_transaction,
 						      jh, &new_jh, blocknr);
+		if (flags < 0) {
+			jbd2_journal_abort(journal, flags);
+			continue;
+		}
 		set_bit(BH_JWrite, &jh2bh(new_jh)->b_state);
 		wbuf[bufs++] = jh2bh(new_jh);
 
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -361,6 +361,10 @@ repeat:
 
 		jbd_unlock_bh_state(bh_in);
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
+		if (!tmp) {
+			jbd2_journal_put_journal_head(new_jh);
+			return -ENOMEM;
+		}
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
 			jbd2_free(tmp, bh_in->b_size);


