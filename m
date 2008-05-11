Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYEKUMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYEKUMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYEKUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:12:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:44269 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYEKUMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gstFtbdxhExomglmm9mjcEXWN0s2NBPTvoQJR11L80Y/WoTV4cqpjHg/6Ca2E43rssTFg2LHPa+ss+AYrfWd3NoJCZ7H8T6iSGO66XQNdqRsPfz5PUwa0ri4f1JGiDfwP0gKtgzb/ZXbfkLRtXWBcKzLeIDC+PTcv/qpwGiensc=
Date: Sun, 11 May 2008 22:12:14 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] let ERR_PTR BUILD_BUG_ON when we know its argument is not
	a valid errno
Message-ID: <20080511201209.GO19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>
---
allmodconfig compile tested (on x86_64)

should be applied after:
net/sunrpc/xprtrdma: fix svc_rdma_create out of memory error path
jfs: 0 is not valid errno value
---
 include/linux/err.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -19,11 +19,13 @@
 
 #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
 
-static inline void *ERR_PTR(long error)
+static inline void *__ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
+#define ERR_PTR(error) (BUILD_BUG_ON(!IS_ERR_VALUE(error)), __ERR_PTR(error))
+
 static inline long PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
-- 
