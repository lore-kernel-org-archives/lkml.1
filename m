Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbYENEuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbYENEuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYENEt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:49:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38483 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYENEt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:49:56 -0400
X-AuditID: 0ac90647-ab321ba000004aeb-41-482a6f728738
Message-ID: <482A6F6F.20002@hitachi.com>
Date: Wed, 14 May 2008 13:49:51 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers (rebased)
References: <482A6E00.6080303@hitachi.com>
In-Reply-To: <482A6E00.6080303@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers

If we failed to write metadata buffers to the journal space and
succeeded to write the commit record, stale data can be written
back to the filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers,
abort the journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc2/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc2.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc2/fs/jbd/commit.c
@@ -703,6 +703,9 @@ wait_for_iobuf:
 		__brelse(bh);
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
 	jbd_debug(3, "JBD: commit phase 5\n");


