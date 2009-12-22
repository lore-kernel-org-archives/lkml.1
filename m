Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZLVP6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZLVP6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZLVP6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:58:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZLVP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:58:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1261406150-7543-1-git-send-email-vapier@gentoo.org>
References: <1261406150-7543-1-git-send-email-vapier@gentoo.org> <20419.1260982769@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH v2] NOMMU: add [stack] label to per-process maps output
Date: Tue, 22 Dec 2009 15:58:10 +0000
Message-ID: <19310.1261497490@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay.  I've adjusted the desciption of the patch a little (see attached).

David
---
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] NOMMU: Add '[stack]' label to /proc/pid/maps output

Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
of the original thread after execve.  This is largely based on the MMU code.
Subsidiary thread stacks are not indicated.

For FDPIC, we now get:

	root:/> cat /proc/self/maps
	02064000-02067ccc rw-p 0004d000 00:01 22         /bin/busybox
	0206e000-0206f35c rw-p 00006000 00:01 295        /lib/ld-uClibc.so.0
	025f0000-025f6f0c r-xs 00000000 00:01 295        /lib/ld-uClibc.so.0
	02680000-026ba6b0 r-xs 00000000 00:01 297        /lib/libc.so.0
	02700000-0274d384 r-xs 00000000 00:01 22         /bin/busybox
	02816000-02817000 rw-p 00000000 00:00 0
	02848000-0284c0d8 rw-p 00000000 00:00 0
	02860000-02880000 rw-p 00000000 00:00 0          [stack]

The semi-downside here is that for FLAT, we get:

	root:/> cat /proc/155/maps
	029f0000-029f9000 rwxp 00000000 00:00 0          [stack]

The reason being that FLAT combines a whole lot of stuff into one map
(including the stack).  But this isn't any worse than the current output (which
is nothing), so screw it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/task_nommu.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 5d9fd64..11827c0 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -121,11 +121,20 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 	return size;
 }
 
+static void pad_len_spaces(struct seq_file *m, int len)
+{
+	len = 25 + sizeof(void*) * 6 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c", len, ' ');
+}
+
 /*
  * display a single VMA to a sequenced file
  */
 static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
@@ -154,11 +163,14 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
-		len = 25 + sizeof(void *) * 6 - len;
-		if (len < 1)
-			len = 1;
-		seq_printf(m, "%*c", len, ' ');
+		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "");
+	} else if (mm) {
+		if (vma->vm_start <= mm->start_stack &&
+			vma->vm_end >= mm->start_stack) {
+			pad_len_spaces(m, len);
+			seq_puts(m, "[stack]");
+		}
 	}
 
 	seq_putc(m, '\n');
