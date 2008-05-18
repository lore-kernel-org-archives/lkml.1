Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYERV7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYERV7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYERV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:58:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:44898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYERV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SNyh+IqQidfEldMxvJdsDVG1RV/ru6IrLJircsFaS6FkfuGyUnWxVzaSpztvyK4bRIN4t9qtRa3Q6R2q6oHXWagJ5f+lwCr/+aMODBp4p+U/iWNujatbOKY4Em3aAqhOhlmEnEwPiiAywuuEMEtTE8iNEfw5XI3No8caDwdwnfc=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] ERR_PTR: if errno value is known at compile time, make sure it's valid
Date: Sun, 18 May 2008 23:56:53 +0200
Message-Id: <1211147818-16056-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERR_PTR is easy to call with wrong argument (positive errno),
and this error lead to catastrophic event - oops or kernel panic
(dereference of invalid pointer).

As most of error handling code paths are rarely tested, this kind of
bug can be hidden for years.

(Currently there are > 1400 calls of ERR_PTR with constant argument.)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/err.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index ec87f31..7b5daa6 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -19,11 +19,13 @@
 
 #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
 
-static inline void *ERR_PTR(long error)
+static inline void *__ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
+#define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && !IS_ERR_VALUE(error)), __ERR_PTR(error))
+
 static inline long PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
-- 
1.5.4.5

