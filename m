Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZFTFGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZFTFGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZFTFGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:06:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:43760 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZFTFGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L585rizDyfNn3GX9spHxV+YhrCCKzubYimWFKZEQsTgW/lQcKrCVoZVEVvb7C236+s
         yKpY71njTPglmps5t/peOjqznzk5VaxNIx4/jn55FR1osoq+/2OBu0GlbrzAuNbTTzT7
         kqc4PLudE2qae6NO09zbklo/z5zjud9ITuQ8o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] tracing/urgent: warn in case of ftrace_start_up inbalance
Date: Sat, 20 Jun 2009 07:06:12 +0200
Message-Id: <1245474372-5249-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
References: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent from further ftrace_start_up inbalances so that we avoid
future nop patching omissions with dynamic ftrace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bb60732..3718d55 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1224,6 +1224,13 @@ static void ftrace_shutdown(int command)
 		return;
 
 	ftrace_start_up--;
+	/*
+	 * Just warn in case of unbalance, no need to kill ftrace, it's not
+	 * critical but the ftrace_call callers may be never nopped again after
+	 * further ftrace uses.
+	 */
+	WARN_ON_ONCE(ftrace_start_up < 0);
+
 	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
-- 
1.6.2.3

