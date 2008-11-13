Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYKMTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYKMTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYKMTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:43:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbYKMTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:43:05 -0500
Date: Thu, 13 Nov 2008 13:42:30 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fix for 2.6.28-rc4
Message-ID: <20081113194229.GB13163@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a dlm regression fix (included below) for 2.6.28-rc4 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Thanks,
Dave

>From 278afcbf4fe964230eba67f8fb8235e8b7e63ffb Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 13 Nov 2008 13:22:34 -0600
Subject: [PATCH] dlm: fix shutdown cleanup

Fixes a regression from commit 0f8e0d9a317406612700426fad3efab0b7bbc467,
"dlm: allow multiple lockspace creates".

An extraneous 'else' slipped into a code fragment being moved from
release_lockspace() to dlm_release_lockspace().  The result of the
unwanted 'else' is that dlm threads and structures are not stopped
and cleaned up when the final dlm lockspace is removed.  Trying to
create a new lockspace again afterward will fail with
"kmem_cache_create: duplicate cache dlm_conn" because the cache
was not previously destroyed.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index d910501..8d86b79 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -812,7 +812,7 @@ int dlm_release_lockspace(void *lockspace, int force)
 	error = release_lockspace(ls, force);
 	if (!error)
 		ls_count--;
-	else if (!ls_count)
+	if (!ls_count)
 		threads_stop();
 	mutex_unlock(&ls_lock);
 
-- 
1.5.5.1

