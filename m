Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbYH2PVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbYH2PVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYH2PVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:21:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:42531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYH2PVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:21:03 -0400
Date: Fri, 29 Aug 2008 08:07:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [PATCH 2/5] select: return accurate remainer in select() and
 ppoll()
Message-ID: <20080829080708.4a301d23@infradead.org>
In-Reply-To: <20080829080549.6906b744@infradead.org>
References: <20080829080549.6906b744@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 28 Aug 2008 13:40:29 -0700
Subject: [PATCH] select: return accurate remainer in select() and ppoll()

On Linux, select() and ppoll() write back the time remaining into the timeout
value. Now that we have a nanosecond level end time, we can also give a very
accurate remainder back; this patch adds the logic to do this.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c |   39 ++++++++++++++++++++++++++++++---------
 fs/select.c |   47 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 7c9b2a1..b7c68f1 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1615,11 +1615,22 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 
 	if (tvp) {
 		struct compat_timeval rtv;
+		struct timespec now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
 		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
 		rtv.tv_sec = timeout;
+
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0) {
+			memset(&rtv, 0, sizeof(rtv));
+		} else {
+			rtv.tv_sec = now.tv_sec;
+			rtv.tv_usec = now.tv_nsec / NSEC_PER_USEC;
+		}
+
 		if (compat_timeval_compare(&rtv, &tv) >= 0)
 			rtv = tv;
 		if (copy_to_user(tvp, &rtv, sizeof(rtv))) {
@@ -1697,16 +1708,20 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 
 	if (tsp) {
 		struct compat_timespec rts;
+		struct timespec now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
 
-		rts.tv_sec = timeout / HZ;
-		rts.tv_nsec = (timeout % HZ) * (NSEC_PER_SEC/HZ);
-		if (rts.tv_nsec >= NSEC_PER_SEC) {
-			rts.tv_sec++;
-			rts.tv_nsec -= NSEC_PER_SEC;
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0) {
+			memset(&rts, 0, sizeof(rts));
+		} else {
+			rts.tv_nsec = now.tv_nsec;
+			rts.tv_sec = now.tv_sec;
 		}
+
 		if (compat_timespec_compare(&rts, &ts) >= 0)
 			rts = ts;
 		if (copy_to_user(tsp, &rts, sizeof(rts))) {
@@ -1818,13 +1833,19 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 
 	if (tsp && timeout >= 0) {
 		struct compat_timespec rts;
+		struct timespec now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		/* Yes, we know it's actually an s64, but it's also positive. */
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-					1000;
-		rts.tv_sec = timeout;
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0) {
+			memset(&rts, 0, sizeof(rts));
+		} else {
+			rts.tv_nsec = now.tv_nsec;
+			rts.tv_sec = now.tv_sec;
+		}
+
 		if (compat_timespec_compare(&rts, &ts) >= 0)
 			rts = ts;
 		if (copy_to_user(tsp, &rts, sizeof(rts))) {
diff --git a/fs/select.c b/fs/select.c
index 6a6e33a..3ce5943 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -409,13 +409,24 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 
 	if (tvp) {
 		struct timeval rtv;
+		struct timespec now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
-		rtv.tv_sec = timeout;
+
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0) {
+			rtv.tv_usec = 0;
+			rtv.tv_sec = 0;
+		} else {
+			rtv.tv_usec = now.tv_nsec / NSEC_PER_USEC;
+			rtv.tv_sec = now.tv_sec;
+		}
+
 		if (timeval_compare(&rtv, &tv) >= 0)
 			rtv = tv;
+
 		if (copy_to_user(tvp, &rtv, sizeof(rtv))) {
 sticky:
 			/*
@@ -481,15 +492,24 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 	ret = core_sys_select(n, inp, outp, exp, &timeout, &end_time);
 
 	if (tsp) {
-		struct timespec rts;
+		struct timespec rts, now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-						1000;
-		rts.tv_sec = timeout;
+
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0) {
+			rts.tv_nsec = 0;
+			rts.tv_sec = 0;
+		} else {
+			rts.tv_nsec = now.tv_nsec;
+			rts.tv_sec = now.tv_sec;
+		}
+
 		if (timespec_compare(&rts, &ts) >= 0)
 			rts = ts;
+
 		if (copy_to_user(tsp, &rts, sizeof(rts))) {
 sticky:
 			/*
@@ -847,16 +867,21 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
 	if (tsp && timeout >= 0) {
-		struct timespec rts;
+		struct timespec rts, now;
 
 		if (current->personality & STICKY_TIMEOUTS)
 			goto sticky;
-		/* Yes, we know it's actually an s64, but it's also positive. */
-		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-						1000;
-		rts.tv_sec = timeout;
+
+		ktime_get_ts(&now);
+		now = timespec_sub(end_time, now);
+		if (now.tv_sec < 0 || now.tv_nsec < 0)
+			memset(&rts, 0, sizeof(rts));
+		else
+			rts = now;
+
 		if (timespec_compare(&rts, &ts) >= 0)
 			rts = ts;
+
 		if (copy_to_user(tsp, &rts, sizeof(rts))) {
 		sticky:
 			/*
-- 
1.5.5.1

