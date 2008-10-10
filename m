Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYJJI57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYJJI57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJJI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:57:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36150 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYJJI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:57:48 -0400
X-AuditID: 0ac90648-aad1eba000004214-9f-48ef190a786f
Message-ID: <48EF1902.5050905@hitachi.com>
Date: Fri, 10 Oct 2008 17:57:38 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: tytso@mit.edu, adilger@sun.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 1/4] jbd2: abort when failed to log metadata buffers
References: <48EF168A.4000705@hitachi.com>
In-Reply-To: <48EF168A.4000705@hitachi.com>
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

We can also avoid this kind of corruption by using check-summing
feature because it can detect invalid metadata blocks in the
journal and avoid them from being replayed.  So we don't need to
care about asynchronous commit record writeout with a check sum.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd2/commit.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/jbd2/commit.c
+++ linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
@@ -783,6 +783,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		jbd2_journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 5\n");
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,


