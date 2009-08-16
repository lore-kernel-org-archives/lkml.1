Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZHPU3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZHPU3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZHPU3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:29:21 -0400
Received: from gon.proformatique.com ([91.194.178.5]:47828 "EHLO
	mx1.corp.proformatique.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbZHPU3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:29:20 -0400
Date: Sun, 16 Aug 2009 22:29:21 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] poll/select: avoid arithmetic overflow in
 __estimate_accuracy()
Message-ID: <20090816222921.26c92ccd@xilun.lan.proformatique.com>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__estimate_accuracy() was prone to integer overflow, for example
if *tv == {2147, 483648000} on a 32 bit computer (or even for delays
as small as {429, 500000000} if the task is niced).

Because the result was already forced between 0 and 100ms, the effect
of the overflow was not too problematic, but the use of the hrtimer
range feature was not optimal in overflow cases.

This patch ensures that there can not be an integer overflow in this
function.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
---
 fs/select.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 8084834..a201fc3 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -41,22 +41,28 @@
  * better solutions..
  */
 
+#define MAX_SLACK	(100 * NSEC_PER_MSEC)
+
 static long __estimate_accuracy(struct timespec *tv)
 {
 	long slack;
 	int divfactor = 1000;
 
+	if (tv->tv_sec < 0)
+		return 0;
+
 	if (task_nice(current) > 0)
 		divfactor = divfactor / 5;
 
+	if (tv->tv_sec > MAX_SLACK / (NSEC_PER_SEC/divfactor))
+		return MAX_SLACK;
+
 	slack = tv->tv_nsec / divfactor;
 	slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);
 
-	if (slack > 100 * NSEC_PER_MSEC)
-		slack =  100 * NSEC_PER_MSEC;
+	if (slack > MAX_SLACK)
+		return MAX_SLACK;
 
-	if (slack < 0)
-		slack = 0;
 	return slack;
 }
 
