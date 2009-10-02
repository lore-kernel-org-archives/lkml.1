Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZJBShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZJBShu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZJBSht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:60368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbZJBShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:37:47 -0400
Date: Fri, 2 Oct 2009 18:36:55 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       arjan@linux.intel.com, arjan@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090926205150.30797709@infradead.org>
References: <20090926205150.30797709@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Simplify bound checks in the MTRR code
Message-ID: <tip-11879ba5d9ab8174af9b9cefbb2396a54dfbf8c1@git.kernel.org>
Git-Commit-ID: 11879ba5d9ab8174af9b9cefbb2396a54dfbf8c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 18:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11879ba5d9ab8174af9b9cefbb2396a54dfbf8c1
Gitweb:     http://git.kernel.org/tip/11879ba5d9ab8174af9b9cefbb2396a54dfbf8c1
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 26 Sep 2009 20:51:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 19:51:56 +0200

x86: Simplify bound checks in the MTRR code

The current bound checks for copy_from_user in the MTRR driver are
not as obvious as they could be, and gcc agrees with that.

This patch simplifies the boundary checks to the point that gcc can
now prove to itself that the copy_from_user() is never going past
its bounds.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090926205150.30797709@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/if.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index f04e725..3c1b12d 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -96,17 +96,24 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	unsigned long long base, size;
 	char *ptr;
 	char line[LINE_SIZE];
+	int length;
 	size_t linelen;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (!len)
-		return -EINVAL;
 
 	memset(line, 0, LINE_SIZE);
-	if (len > LINE_SIZE)
-		len = LINE_SIZE;
-	if (copy_from_user(line, buf, len - 1))
+
+	length = len;
+	length--;
+
+	if (length > LINE_SIZE - 1)
+		length = LINE_SIZE - 1;
+
+	if (length < 0)
+		return -EINVAL;
+
+	if (copy_from_user(line, buf, length))
 		return -EFAULT;
 
 	linelen = strlen(line);
