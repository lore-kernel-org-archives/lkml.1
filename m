Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYJJJCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYJJJCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbYJJJCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:02:24 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33420 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbYJJJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:02:22 -0400
X-AuditID: 0ac90650-ac8ccba000006fc9-da-48ef1a1bfcd3
Message-ID: <48EF1A11.9090303@hitachi.com>
Date: Fri, 10 Oct 2008 18:02:09 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: tytso@mit.edu, adilger@sun.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 4/4] jbd2: don't dirty original metadata buffer on abort
References: <48EF168A.4000705@hitachi.com>
In-Reply-To: <48EF168A.4000705@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, original metadata buffers are dirtied when they are
unfiled whether the journal has aborted or not.  Eventually these
buffers will be written-back to the filesystem by pdflush.  This
means some metadata buffers are written to the filesystem without
journaling if the journal aborts.  So if both journal abort and
system crash happen at the same time, the filesystem would become
inconsistent state.  Additionally, replaying journaled metadata
can overwrite the latest metadata on the filesystem partly.
Because, if the journal gets aborted, journaled metadata are
preserved and replayed during the next mount not to lose
uncheckpointed metadata.  This would also break the consistency
of the filesystem.

This patch prevents original metadata buffers from being dirtied
on abort by clearing BH_JBDDirty flag from those buffers.  Thus,
no metadata buffers are written to the filesystem without journaling.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd2/commit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/jbd2/commit.c
+++ linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
@@ -504,9 +504,10 @@ void jbd2_journal_commit_transaction(jou
 		jh = commit_transaction->t_buffers;
 
 		/* If we're in abort mode, we just un-journal the buffer and
-		   release it for background writing. */
+		   release it. */
 
 		if (is_journal_aborted(journal)) {
+			clear_buffer_jbddirty(jh2bh(jh));
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
 			jbd2_journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
@@ -884,6 +885,8 @@ restart_loop:
 		if (buffer_jbddirty(bh)) {
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__jbd2_journal_insert_checkpoint(jh, commit_transaction);
+			if (is_journal_aborted(journal))
+				clear_buffer_jbddirty(bh);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
 			__jbd2_journal_refile_buffer(jh);
 			jbd_unlock_bh_state(bh);


