Return-Path: <linux-kernel-owner+w=401wt.eu-S1762365AbYFESiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762365AbYFESiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYFESiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:38:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYFESiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:38:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=plx8hJqjPIGyFJ+vD+F1FzehKuCEuJuwIlosrMDdnegoNUgqx29c3NYbnX5I2jIhp
	hReHQoY1Eimg1PThLNeWg==
Message-ID: <4ca0a85e0806051138q2a6a6aeav941e46c67ee12bd0@mail.gmail.com>
Date: Thu, 5 Jun 2008 14:38:10 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] pagemap: Require reads of /proc/pid/pagemap to be multiples of 8 (v2 of series)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This matches the behavior of /proc/kpage{count,flags}, and simplifies
the logic a bit.

I also changed out and end in struct pagemapread to be u64* instead of
char*, which makes put_user work the way it was intended.  (Before, it
was only copying the bottom byte of a pagemap entry, because the target
of the copy was a char*.)

Signed-off-by: Thomas Tuttle
---
 fs/proc/task_mmu.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 88717c0..01f9bff 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -496,7 +496,7 @@ const struct file_operations proc_clear_refs_operations = {
 };

 struct pagemapread {
-       char __user *out, *end;
+       u64 __user *out, *end;
 };

 #define PM_ENTRY_BYTES      sizeof(u64)
@@ -519,21 +519,11 @@ struct pagemapread {
 static int add_to_pagemap(unsigned long addr, u64 pfn,
                          struct pagemapread *pm)
 {
-       /*
-        * Make sure there's room in the buffer for an
-        * entire entry.  Otherwise, only copy part of
-        * the pfn.
-        */
-       if (pm->out + PM_ENTRY_BYTES >= pm->end) {
-               if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
-                       return -EFAULT;
-               pm->out = pm->end;
-               return PM_END_OF_BUFFER;
-       }
-
        if (put_user(pfn, pm->out))
                return -EFAULT;
-       pm->out += PM_ENTRY_BYTES;
+       pm->out++;
+       if (pm->out >= pm->end)
+               return PM_END_OF_BUFFER;
        return 0;
 }

@@ -634,7 +624,7 @@ static ssize_t pagemap_read(struct file *file,
char __user * buf,

        ret = -EINVAL;
        /* file position must be aligned */
-       if (*ppos % PM_ENTRY_BYTES)
+       if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
                goto out_task;

        ret = 0;
@@ -664,8 +654,8 @@ static ssize_t pagemap_read(struct file *file,
char __user * buf,
                goto out_pages;
        }

-       pm.out = buf;
-       pm.end = buf + count;
+       pm.out = (u64*)buf;
+       pm.end = (u64*)(buf + count);

        if (!ptrace_may_attach(task)) {
                ret = -EIO;
@@ -690,9 +680,9 @@ static ssize_t pagemap_read(struct file *file,
char __user * buf,
                if (ret == PM_END_OF_BUFFER)
                        ret = 0;
                /* don't need mmap_sem for these, but this looks cleaner */
-               *ppos += pm.out - buf;
+               *ppos += (char*)pm.out - buf;
                if (!ret)
-                       ret = pm.out - buf;
+                       ret = (char*)pm.out - buf;
        }

 out_pages:
--
1.5.3.6
