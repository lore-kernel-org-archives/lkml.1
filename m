Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZDSWI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZDSWI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZDSWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:07:55 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:36461 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WOmiye7PWXX8OZk+OK0RE4tasvMep7dbTkNUHd7IqbHSJodGnIvXWTdhRTY69HgVeO
         5Yy7lyGpXzm8T0uTpjCBIucYz8SY/qoKNIlPNGifPQlYF/dn8mxeWLjIgtxQGA+VwSX/
         Vn74zL6QOr8DCAxZQywys6dVu2Vr4ygZr1E2c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2 v3] tracing/core: Add current context on tracing recursion warning
Date: Mon, 20 Apr 2009 00:07:47 +0200
Message-Id: <1240178868-18218-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
References: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of tracing recursion detection, we only get the stacktrace.
But the current context may be very useful to debug the issue.

This patch adds the softirq/hardirq/nmi context with the warning
using lockdep context display to have a familiar output.

v2: Use printk_once()
v3: drop {hardirq,softirq}_context which depend on lockdep,
    only keep what is part of current->trace_recursion,
    sufficient to debug the warning source.

[ Impact: print context necessary to debug recursion ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b421b0e..bffde63 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1495,6 +1495,13 @@ static int trace_recursive_lock(void)
 	if (unlikely(current->trace_recursion & (1 << level))) {
 		/* Disable all tracing before we do anything else */
 		tracing_off_permanent();
+
+		printk_once(KERN_WARNING "Tracing recursion: "
+			    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
+			    hardirq_count() >> HARDIRQ_SHIFT,
+			    softirq_count() >> SOFTIRQ_SHIFT,
+			    in_nmi());
+
 		WARN_ON_ONCE(1);
 		return -1;
 	}
-- 
1.6.2.3

