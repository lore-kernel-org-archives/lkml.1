Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYFBKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYFBKqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYFBKqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:46:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52506 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFBKqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:46:09 -0400
X-AuditID: 0ac90648-add7dba000000c2f-25-4843cf6fd964
Message-ID: <4843CF6A.7090107@hitachi.com>
Date: Mon, 02 Jun 2008 19:46:02 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com
Cc: adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 3/5] jbd: abort when failed to log metadata buffers
References: <4843CE15.6080506@hitachi.com>
In-Reply-To: <4843CE15.6080506@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3/5] jbd: abort when failed to log metadata buffers

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc4/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc4/fs/jbd/commit.c
@@ -734,6 +734,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 6\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))


