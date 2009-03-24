Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZCXKHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZCXKHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZCXKHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:07:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:58163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZCXKHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:07:30 -0400
Date: Tue, 24 Mar 2009 10:06:38 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237888763.25315.70.camel@penberg-laptop>
References: <1237888763.25315.70.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] fs: don't include <linux/gfp.h> to fix headers-export-check
Message-ID: <tip-f9ebc8b5fa7b574df0f8d39643879edc77cb2fe2@git.kernel.org>
Git-Commit-ID: f9ebc8b5fa7b574df0f8d39643879edc77cb2fe2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 10:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9ebc8b5fa7b574df0f8d39643879edc77cb2fe2
Gitweb:     http://git.kernel.org/tip/f9ebc8b5fa7b574df0f8d39643879edc77cb2fe2
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 11:59:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 11:04:19 +0100

fs: don't include <linux/gfp.h> to fix headers-export-check

Impact: fix build

This patch fixes a headers-export-check failure:

  /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
  /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
  make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
  make[2]: *** [linux] Error 2

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237888763.25315.70.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/fs.h |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index add95da..11fdc57 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,7 +8,6 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
-#include <linux/gfp.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -2233,15 +2232,12 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 
 
 #ifdef CONFIG_SECURITY
-static inline char *alloc_secdata(void)
-{
-	return (char *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void free_secdata(void *secdata)
-{
-	free_page((unsigned long)secdata);
-}
+/*
+ * These need to be macros because we cannot include <linux/gfp.h> in this
+ * header file.
+ */
+#define alloc_secdata()       (char *)get_zeroed_page(GFP_KERNEL)
+#define free_secdata(secdata) free_page((unsigned long) secdata)
 #else
 static inline char *alloc_secdata(void)
 {
