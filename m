Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYGXMhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYGXMhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYGXMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:37:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33899 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYGXMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:37:23 -0400
X-AuditID: 0ac90650-ade2eba000003664-e1-488877819627
Message-ID: <48887776.4080504@hitachi.com>
Date: Thu, 24 Jul 2008 21:37:10 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu, adilger@clusterfs.com,
       snitzer@gmail.com, tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: [PATCH 1/4] jbd: abort when failed to log metadata buffers
References: <488876D3.80004@hitachi.com>
In-Reply-To: <488876D3.80004@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc8-mm1/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc8-mm1/fs/jbd/commit.c
@@ -762,6 +762,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 6\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))


