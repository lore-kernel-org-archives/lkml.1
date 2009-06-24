Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZFXJrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZFXJrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbZFXJrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:47:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891AbZFXJre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:47:34 -0400
Date: Wed, 24 Jun 2009 09:46:55 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A41876E.2060407@cn.fujitsu.com>
References: <4A41876E.2060407@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Fix t_hash_start()
Message-ID: <tip-d82d62444f87e5993af2fa82ed636b2206e052ea@git.kernel.org>
Git-Commit-ID: d82d62444f87e5993af2fa82ed636b2206e052ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:46:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d82d62444f87e5993af2fa82ed636b2206e052ea
Gitweb:     http://git.kernel.org/tip/d82d62444f87e5993af2fa82ed636b2206e052ea
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:54:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:53 +0200

ftrace: Fix t_hash_start()

When the output of set_ftrace_filter is larger than PAGE_SIZE,
t_hash_start() will be called the 2nd time, and then we start
from the head of a hlist, which is wrong and causes some entries
to be outputed twice.

The worse is, if the hlist is large enough, reading set_ftrace_filter
won't stop but in a dead loop.

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A41876E.2060407@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dc81020..71a52c1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1417,10 +1417,20 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
+	loff_t l;
+
+	if (!(iter->flags & FTRACE_ITER_HASH))
+		*pos = 0;
 
 	iter->flags |= FTRACE_ITER_HASH;
 
-	return t_hash_next(m, p, pos);
+	iter->hidx = 0;
+	for (l = 0; l <= *pos; ) {
+		p = t_hash_next(m, p, &l);
+		if (!p)
+			break;
+	}
+	return p;
 }
 
 static int t_hash_show(struct seq_file *m, void *v)
