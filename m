Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZGFFgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZGFFgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGFFgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:36:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZGFFgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:36:07 -0400
Date: Mon, 6 Jul 2009 01:35:30 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>
Message-Id: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>
Subject: [Patch] pipe: use file_update_time() when hold i_mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


file_update_time() should be called with i_mutex held,
move it before mutex_unlock().

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>

---
diff --git a/fs/pipe.c b/fs/pipe.c
index f7dd21a..724b035 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -602,13 +602,14 @@ redo2:
 		pipe->waiting_writers--;
 	}
 out:
+	if (ret > 0)
+		file_update_time(filp);
+
 	mutex_unlock(&inode->i_mutex);
 	if (do_wakeup) {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
-	if (ret > 0)
-		file_update_time(filp);
 	return ret;
 }
 
