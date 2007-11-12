Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbXKLNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbXKLNXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbXKLNXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:23:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbXKLNXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:23:47 -0500
From: Michal Schmidt <mschmidt@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] proc: loadavg reading race
Date: Mon, 12 Nov 2007 14:23:44 +0100
Message-Id: <1194873824-29116-1-git-send-email-mschmidt@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The avenrun[] values are supposed to be protected by xtime_lock.
loadavg_read_proc does not use it. Theoretically this may result in an
occasional glitch when the value read from /proc/loadavg would be as much as
1<<11 times higher than it should be.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 fs/proc/proc_misc.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e0d064e..10cc9ad 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -83,10 +83,15 @@ static int loadavg_read_proc(char *page, char **start, off_t off,
 {
 	int a, b, c;
 	int len;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		a = avenrun[0] + (FIXED_1/200);
+		b = avenrun[1] + (FIXED_1/200);
+		c = avenrun[2] + (FIXED_1/200);
+	} while (read_seqretry(&xtime_lock, seq));
 
-	a = avenrun[0] + (FIXED_1/200);
-	b = avenrun[1] + (FIXED_1/200);
-	c = avenrun[2] + (FIXED_1/200);
 	len = sprintf(page,"%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
 		LOAD_INT(a), LOAD_FRAC(a),
 		LOAD_INT(b), LOAD_FRAC(b),
-- 
1.5.3.3

