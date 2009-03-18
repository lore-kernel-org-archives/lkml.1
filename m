Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZCRRec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZCRRec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbZCRReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:34:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:32857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759297AbZCRReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:34:10 -0400
Date: Wed, 18 Mar 2009 17:33:26 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237394936.3132.1.camel@localhost.localdomain>
References: <1237394936.3132.1.camel@localhost.localdomain>
Subject: [tip:tracing/ftrace] tracing: fix oops in tracepoint_update_probe_range()
Message-ID: <tip-7d1832698e6e422cc2cf0d80b9c50ca567e758a3@git.kernel.org>
Git-Commit-ID: 7d1832698e6e422cc2cf0d80b9c50ca567e758a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 17:33:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d1832698e6e422cc2cf0d80b9c50ca567e758a3
Gitweb:     http://git.kernel.org/tip/7d1832698e6e422cc2cf0d80b9c50ca567e758a3
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 18 Mar 2009 22:18:56 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 18:30:43 +0100

tracing: fix oops in tracepoint_update_probe_range()

Change this crash:

 BUG: unable to handle kernel NULL pointer dereference at (null)
 IP: [<ffffffff8107d4de>] tracepoint_update_probe_range+0x1f/0x9b
 PGD 13d5fb067 PUD 13d688067 PMD 0
 Oops: 0000 [#1] SMP

To a more debuggable WARN_ONCE().

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237394936.3132.1.camel@localhost.localdomain>
[ moved the check outside the lock and added a WARN_ON(). ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/tracepoint.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 7960274..8bc1a06 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -272,12 +272,17 @@ static void disable_tracepoint(struct tracepoint *elem)
  *
  * Updates the probe callback corresponding to a range of tracepoints.
  */
-void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
+void
+tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 {
 	struct tracepoint *iter;
 	struct tracepoint_entry *mark_entry;
 
+	if (!iter) {
+		WARN_ON_ONCE(1);
+		goto out;
+	}
+
 	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_tracepoint(iter->name);
