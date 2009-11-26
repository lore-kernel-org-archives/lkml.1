Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZKZEfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZKZEfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 23:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZKZEfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 23:35:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46712 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbZKZEfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 23:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fiYovxtNIUl+2JRMkCcONGzWsAoRRyq5AzGgxs3favhIwSe1OIRgQCQOah6BfXu432
         vIIHKfOBUHu9Q2NFtqdQc50zt+Q+oTWXWMu0FzruUAg6pFqcwK33+E1WOoWNnT9Ne3sb
         6ef/Ig8Z0n44BSURe6R8T/VLzvyEeiBK2PzW4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ksym_tracer: Fix breakpoint removal after modification
Date: Thu, 26 Nov 2009 05:35:40 +0100
Message-Id: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error path of a breakpoint modification is broken in
the ksym tracer. A modified breakpoint hlist node is immediately
released after its removal. Also we leak a breakpoint in this
case.

Fix the path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/trace/trace_ksym.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 11935b5..9f040e4 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -339,14 +339,20 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 					ksym_hbp_handler, true);
 			if (IS_ERR(entry->ksym_hbp))
 				entry->ksym_hbp = NULL;
-			if (!entry->ksym_hbp)
+
+			/* modified without problem */
+			if (entry->ksym_hbp) {
+				ret = 0;
 				goto out;
+			}
+		} else {
+			ret = 0;
 		}
+		/* Error or "symbol:---" case: drop it */
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry);
-		ret = 0;
 		goto out;
 	} else {
 		/* Check for malformed request: (4) */
-- 
1.6.2.3

