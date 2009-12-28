Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZL1KLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZL1KLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZL1KLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:11:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:48096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZL1KLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:11:48 -0500
Date: Mon, 28 Dec 2009 10:10:23 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1258603932-4590-1-git-send-email-akinobu.mita@gmail.com>
References: <1258603932-4590-1-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, core: Optimize hweight32()
Message-ID: <tip-39d997b514e12d5aff0dca206eb8996b3957927e@git.kernel.org>
Git-Commit-ID: 39d997b514e12d5aff0dca206eb8996b3957927e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39d997b514e12d5aff0dca206eb8996b3957927e
Gitweb:     http://git.kernel.org/tip/39d997b514e12d5aff0dca206eb8996b3957927e
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Mon, 21 Dec 2009 16:20:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:41:39 +0100

x86, core: Optimize hweight32()

Optimize hweight32 by using the same technique in hweight64.

The proof of this technique can be found in the commit log for
f9b4192923fa6e38331e88214b1fe5fc21583fcc ("bitops: hweight()
speedup").

The userspace benchmark on x86_32 showed 20% speedup with
bitmap_weight() which uses hweight32 to count bits for each
unsigned long on 32bit architectures.

 int main(void)
 {
	#define SZ (1024 * 1024 * 512)

	static DECLARE_BITMAP(bitmap, SZ) = {
	        [0 ... 100] = 1,
	};

	return bitmap_weight(bitmap, SZ);
 }

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1258603932-4590-1-git-send-email-akinobu.mita@gmail.com>
[ only x86 sets ARCH_HAS_FAST_MULTIPLIER so we do this via the x86 tree]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/hweight.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/lib/hweight.c b/lib/hweight.c
index 389424e..63ee4eb 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -11,11 +11,18 @@
 
 unsigned int hweight32(unsigned int w)
 {
+#ifdef ARCH_HAS_FAST_MULTIPLIER
+	w -= (w >> 1) & 0x55555555;
+	w =  (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w =  (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+#else
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
 	res = (res + (res >> 4)) & 0x0F0F0F0F;
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
+#endif
 }
 EXPORT_SYMBOL(hweight32);
 
