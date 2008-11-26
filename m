Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYKZPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYKZPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYKZPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:48:16 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:22689 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbYKZPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:48:15 -0500
Message-ID: <492D6FB8.80401@panasas.com>
Date: Wed, 26 Nov 2008 17:48:08 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: WARN_ON out of range error in ERR_PTR?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2008 15:46:36.0906 (UTC) FILETIME=[2A6054A0:01C94FDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

After hitting a bug where an nfs error -10021 wasn't handled
correctly since IS_ERR returned false on its ERR_PTR value
I realized that adding a BUG_ON to make sure the mapped error
is in the valid range would have caught this.

Since ERR_PTR is not called on the critical path
(unlike IS_ERR) but rather on the error handling path I believe
we can tolerate the extra cost.

The reason this is just a WARN_ON and not BUG_ON is to make
fixing it easier, although I do consider calling ERR_PTR on an
out of range error a pretty dangerous bug as the error might go
unnoticed.

How about committing the following patch to -mm?

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 include/linux/err.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index ec87f31..81df84f 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -2,7 +2,7 @@
 #define _LINUX_ERR_H
 
 #include <linux/compiler.h>
-
+#include <asm/bug.h>
 #include <asm/errno.h>
 
 /*
@@ -21,6 +21,7 @@
 
 static inline void *ERR_PTR(long error)
 {
+	WARN_ON(error && !IS_ERR_VALUE(error));
 	return (void *) error;
 }
 
-- 
1.6.0.2

