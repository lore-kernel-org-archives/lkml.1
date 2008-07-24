Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYGXMlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYGXMlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYGXMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:41:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49645 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYGXMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:41:39 -0400
X-AuditID: 0ac90648-aaaa0ba000004920-22-488878803b51
Message-ID: <4888787A.7000903@hitachi.com>
Date: Thu, 24 Jul 2008 21:41:30 +0900
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
Subject: [PATCH 4/4] jbd: don't dirty original metadata buffer on abort
References: <488876D3.80004@hitachi.com>
In-Reply-To: <488876D3.80004@hitachi.com>
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
Because, if the journal aborts, journaled metadata are preserved
and replayed during the next mount not to lose uncheckpointed
metadata.  This would also break the consistency of the filesystem.

This patch prevents original metadata buffers from being dirtied
on abort by clearing BH_JBDDirty flag from those buffers.  Thus,
no metadata buffers are written to the filesystem without journaling.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/commit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc8-mm1/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc8-mm1/fs/jbd/commit.c
@@ -518,9 +518,10 @@ void journal_commit_transaction(journal_
 		jh = commit_transaction->t_buffers;
 
 		/* If we're in abort mode, we just un-journal the buffer and
-		   release it for background writing. */
+		   release it. */
 
 		if (is_journal_aborted(journal)) {
+			clear_buffer_jbddirty(jh2bh(jh));
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
 			journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
@@ -855,6 +856,8 @@ restart_loop:
 		if (buffer_jbddirty(bh)) {
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__journal_insert_checkpoint(jh, commit_transaction);
+			if (is_journal_aborted(journal))
+				clear_buffer_jbddirty(bh);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
 			__journal_refile_buffer(jh);
 			jbd_unlock_bh_state(bh);


