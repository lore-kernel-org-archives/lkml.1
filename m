Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZBWWC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZBWWC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBWWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:02:18 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1520 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZBWWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:02:18 -0500
Message-ID: <49A31CE6.3080109@cybernetics.com>
Date: Mon, 23 Feb 2009 17:02:14 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] improve comment describing fget_light
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the description of fget_light, which is currently incorrect
about needing a prior refcnt (judging by the way it is actually used).

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
diff -urpN a/fs/file_table.c b/fs/file_table.c
--- a/fs/file_table.c	2009-02-23 12:38:10.000000000 -0500
+++ b/fs/file_table.c	2009-02-23 16:45:51.000000000 -0500
@@ -315,11 +315,20 @@ struct file *fget(unsigned int fd)
 EXPORT_SYMBOL(fget);
 
 /*
- * Lightweight file lookup - no refcnt increment if fd table isn't shared. 
- * You can use this only if it is guranteed that the current task already 
- * holds a refcnt to that file. That check has to be done at fget() only
- * and a flag is returned to be passed to the corresponding fput_light().
- * There must not be a cloning between an fget_light/fput_light pair.
+ * Lightweight file lookup - no refcnt increment if fd table isn't shared.
+ *
+ * You can use this instead of fget if you satisfy all of the following
+ * conditions:
+ * 1) You must call fput_light before exiting the syscall and returning control
+ *    to userspace (i.e. you cannot remember the returned struct file * after
+ *    returning to userspace).
+ * 2) You must not call filp_close on the returned struct file * in between
+ *    calls to fget_light and fput_light.
+ * 3) You must not clone the current task in between the calls to fget_light
+ *    and fput_light.
+ *
+ * The fput_needed flag returned by fget_light should be passed to the
+ * corresponding fput_light.
  */
 struct file *fget_light(unsigned int fd, int *fput_needed)
 {


