Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZFXByN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZFXByN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFXBx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:53:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59155 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZFXBx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:53:57 -0400
Message-ID: <4A41876E.2060407@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:54:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] ftrace: fix t_hash_start()
References: <4A4186C6.9090706@cn.fujitsu.com>
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the output of set_ftrace_filter is larger than PAGE_SIZE,
t_hash_start() will be called the 2nd time, and then we start
from the head of a hlist, which is wrong and causes some entries
to be outputed twice.

The worse is, if the hlist is large enough, reading set_ftrace_filter
won't stop but in a dead loop.

[ Impact: fix output of set_ftrace_filter for selected functions ]

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7946938..5771cc1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1416,10 +1416,20 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
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
-- 
1.5.4.rc3
