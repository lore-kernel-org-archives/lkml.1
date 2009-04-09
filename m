Return-Path: <linux-kernel-owner+w=401wt.eu-S935435AbZDIPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435AbZDIPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZDIPhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:37:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbZDIPhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:37:09 -0400
Date: Thu, 9 Apr 2009 17:36:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core fixes
Message-ID: <20090409153644.GA19326@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (1):
      futex: comment requeue key reference semantics

Zhaolei (1):
      printk: fix wrong format string iter for printk


 kernel/futex.c |    7 ++++++-
 lib/vsprintf.c |   16 ----------------
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6b50a02..eef8cd2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -883,7 +883,12 @@ retry_private:
 out_unlock:
 	double_unlock_hb(hb1, hb2);
 
-	/* drop_futex_key_refs() must be called outside the spinlocks. */
+	/*
+	 * drop_futex_key_refs() must be called outside the spinlocks. During
+	 * the requeue we moved futex_q's from the hash bucket at key1 to the
+	 * one at key2 and updated their key pointer.  We no longer need to
+	 * hold the references to key1.
+	 */
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index be3001f..7536ace 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1051,13 +1051,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1339,8 +1332,6 @@ do {									\
 			break;
 
 		case FORMAT_TYPE_INVALID:
-			if (!*fmt)
-				--fmt;
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1523,13 +1514,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS:
