Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZLKFci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZLKFci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZLKFcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:32:35 -0500
Received: from kroah.org ([198.145.64.141]:53561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbZLKFaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:01 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:53 2009
Message-Id: <20091211052553.196951652@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [24/34] jbd2: Add ENOMEM checking in and for jbd2_journal_write_metadata_buffer()
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0020-jbd2-Add-ENOMEM-checking-in-and-for-jbd2_journal_wri.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -358,6 +358,10 @@ repeat:
 
 		jbd_unlock_bh_state(bh_in);
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
+		if (!tmp) {
+			jbd2_journal_put_journal_head(new_jh);
+			return -ENOMEM;
+		}
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
 			jbd2_free(tmp, bh_in->b_size);


