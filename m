Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYDRNia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYDRNia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYDRNiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:38:18 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34536 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYDRNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:38:17 -0400
X-AuditID: 0ac90648-ab79fba000001009-8d-4808a4472c58
Message-ID: <4808A444.1080507@hitachi.com>
Date: Fri, 18 Apr 2008 22:38:12 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers
References: <48089B86.5020108@hitachi.com>
In-Reply-To: <48089B86.5020108@hitachi.com>
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

Index: linux-2.6.25/fs/jbd/commit.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/commit.c
+++ linux-2.6.25/fs/jbd/commit.c
@@ -716,6 +716,9 @@ wait_for_iobuf:
 		__brelse(bh);
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
 	jbd_debug(3, "JBD: commit phase 5\n");


