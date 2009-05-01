Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZEACpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZEACpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbZEACoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:34532 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZEACo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bG0ERc3DThFICn1VCs6C4aYsvOURFbnKquorNdjhW/uDhaqsQJtbmQ3eIVQD+JHTFy
         A2wxDycxVTsvtFzvPaKrgmTusoSHCfswSKgzvQ5X7ZH8/CH/tIn0pTZprrZ+L0aojqao
         iYkXmA9x2oRb+O1fKIEPYa9FLswSItKdbrR0Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/6] kill-the-BKL/reiserfs: release the write lock before rescheduling on do_journal_end()
Date: Fri,  1 May 2009 04:44:18 +0200
Message-Id: <1241145862-21700-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do_journal_end() copies data to the journal blocks buffers in memory,
it reschedules if needed between each block copied and dirtyfied.

We can also release the write lock at this rescheduling stage,
like did the bkl implicitly.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/journal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 7976d7d..373d080 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -4232,7 +4232,9 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 		next = cn->next;
 		free_cnode(sb, cn);
 		cn = next;
+		reiserfs_write_unlock(sb);
 		cond_resched();
+		reiserfs_write_lock(sb);
 	}
 
 	/* we are done  with both the c_bh and d_bh, but
-- 
1.6.2.3

