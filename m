Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYEVQwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYEVQwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbYEVQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:51:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:44447 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbYEVQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EbRRN2hK97e186fckL1PsZ6yWDfVquVw8IC/5gqxVKxHs1v/HxfhRht9+NpuGUT083zwRk8rSD/bt3+4vtLu/Zlna2JryOeiLktG8uS4RStfHLdwGDMq85+E6RHSSn1DcnIfdMWY25hgpgkPGe4qJuus07HQKsMSOSWB3eO9PtI=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] ERR_PTR: if errno value is known at compile time, make sure it's valid
Date: Thu, 22 May 2008 18:50:18 +0200
Message-Id: <1211475019-5596-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERR_PTR is easy to call with wrong argument (positive errno),
and this error lead to catastrophic event - oops or kernel panic
(dereference of invalid pointer).

As most of error handling code paths are rarely tested, this kind of
bug can be hidden for years. Currently there are > 1400 calls of ERR_PTR
with constant argument.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
---
 include/linux/err.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index ec87f31..4773ed3 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -18,12 +18,21 @@
 #ifndef __ASSEMBLY__
 
 #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
+#define VALID_ERR_PTR_ARG(error) (error == 0 || IS_ERR_VALUE(error))
 
-static inline void *ERR_PTR(long error)
+static inline void *__ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
+/*
+ * implementation note: we have to make it a macro, otherwise
+ * gcc won't break the build on wrong argument
+ */
+#define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && \
+					!VALID_ERR_PTR_ARG(error)), \
+			__ERR_PTR(error))
+
 static inline long PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
-- 
1.5.4.5

