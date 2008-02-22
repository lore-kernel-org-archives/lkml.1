Return-Path: <linux-kernel-owner+w=401wt.eu-S936479AbYBVWae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479AbYBVWae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbYBVWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:30:25 -0500
Received: from eucd.info ([88.191.250.43]:39812 "EHLO snail.fsffrance.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755828AbYBVWaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:30:25 -0500
X-Greylist: delayed 2977 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 17:30:24 EST
From: Segher Boessenkool <segher@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Subject: [PATCH] Prevent the loop in timespec_add_ns() to be optimised away
Date: Fri, 22 Feb 2008 22:40:45 +0100
Message-Id: <6a95d77ad55b29ff2d856c9e1f7dd79682370300.1203715782.git.segher@kernel.crashing.org>
X-Mailer: git-send-email 1.5.4.2.184.gb23b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...since some architectures don't support __udivdi3() (and
we don't want to use that, anyway).

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
---
 include/linux/time.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 2091a19..d32ef0a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
 	ns += a->tv_nsec;
 	while(unlikely(ns >= NSEC_PER_SEC)) {
+		/* The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation.  */
+		asm("" : "+r"(ns));
+
 		ns -= NSEC_PER_SEC;
 		a->tv_sec++;
 	}
-- 
1.5.4.2.184.gb23b

