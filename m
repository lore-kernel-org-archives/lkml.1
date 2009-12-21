Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZLUOex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZLUOex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZLUOew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:34:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:51819 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZLUOev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:34:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH v2] NOMMU: add [stack] label to per-process maps output
Date: Mon, 21 Dec 2009 09:35:50 -0500
Message-Id: <1261406150-7543-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <20419.1260982769@redhat.com>
References: <20419.1260982769@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the NOMMU per-process proc maps file to show which mapping
is the stack.  This is largely based on the MMU code.

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
(including the stack).  But this isn't any worse than the current output
(which is nothing), so screw it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- use start_stack rather than brk to find the mapping

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
-- 
1.6.5.4

