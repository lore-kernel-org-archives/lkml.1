Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYAXVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYAXVwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYAXVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:51:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:50748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYAXVv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=OzsrP+xWoro23l2OCEAFqnyhy8kMdsfOlS81S7y+efDQJPr+QJ/Jur8adDqSdWo5n99Duvm441TeGytIJoV715gpqooZMmiDcymMRiNhA9T3tUngPQQiNfRc6N+0eB+h59J86JaCGhJPJrJ5+UefZFjJSwk+MDXiJGsoPVTtEYY=
Date: Thu, 24 Jan 2008 22:50:26 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-Id: <20080124225026.55fc6c20.diegocg@gmail.com>
In-Reply-To: <200801242336.00340.a1426z@gawab.com>
References: <200801242336.00340.a1426z@gawab.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 24 Jan 2008 23:36:00 +0300, Al Boldi <a1426z@gawab.com> escribió:

> Greetings!
> 
> data=ordered mode has proven reliable over the years, and it does this by 
> ordering filedata flushes before metadata flushes.  But this sometimes 
> causes contention in the order of a 10x slowdown for certain apps, either 
> due to the misuse of fsync or due to inherent behaviour like db's, as well 
> as inherent starvation issues exposed by the data=ordered mode.

There's a related bug in bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=9546

The diagnostic from Jan Kara is different though, but I think it may be the same
problem...

"One process does data-intensive load. Thus in the ordered mode the
transaction is tiny but has tons of data buffers attached. If commit
happens, it takes a long time to sync all the data before the commit
can proceed... In the writeback mode, we don't wait for data buffers, in
the journal mode amount of data to be written is really limited by the
maximum size of a transaction and so we write by much smaller chunks
and better latency is thus ensured."


I'm hitting this bug too...it's surprising that there's not many people
reporting more bugs about this, because it's really annoying.


There's a patch by Jan Kara (that I'm including here because bugzilla didn't
include it and took me a while to find it) which I don't know if it's supposed to
fix the problem , but it'd be interesting to try:




Don't allow too much data buffers in a transaction.

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 08ff6c7..e6f9dd6 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -163,7 +163,7 @@ repeat_locked:
 	spin_lock(&transaction->t_handle_lock);
 	needed = transaction->t_outstanding_credits + nblocks;
 
-	if (needed > journal->j_max_transaction_buffers) {
+	if (needed > journal->j_max_transaction_buffers || atomic_read(&transaction->t_data_buf_count) > 32768) {
 		/*
 		 * If the current transaction is already too large, then start
 		 * to commit it: we can then go back and attach this handle to
@@ -1528,6 +1528,7 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 		return;
 	case BJ_SyncData:
 		list = &transaction->t_sync_datalist;
+		atomic_dec(&transaction->t_data_buf_count);
 		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers--;
@@ -1989,6 +1990,7 @@ void __journal_file_buffer(struct journal_head *jh,
 		return;
 	case BJ_SyncData:
 		list = &transaction->t_sync_datalist;
+		atomic_inc(&transaction->t_data_buf_count);
 		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers++;
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index d9ecd13..6dd284a 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -541,6 +541,12 @@ struct transaction_s
 	int			t_outstanding_credits;
 
 	/*
+	 * Number of data buffers on t_sync_datalist attached to
+	 * the transaction.
+	 */
+	atomic_t		t_data_buf_count;
+
+	/*
 	 * Forward and backward links for the circular list of all transactions
 	 * awaiting checkpoint. [j_list_lock]
 	 */
