Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYJQMvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYJQMvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbYJQMvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:51:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:4884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbYJQMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dVIhR1GMGZuoeocE6zh29DM2xAcn2gMnb6urjJMBfTGY2C8Qo1VS0gknQfl9i2bh1Q
         pCV+3Nl8dQS1qizPXZzNB+gN8jKjp7gTbsUuXljV6kvxj1s9SWjjiRFSntH7z2Za8Wf4
         Y5CG11EfPzzFRYB4A0nx4qIqzuT01HhOUVS5o=
Date: Fri, 17 Oct 2008 16:54:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@in.ibm.com
Subject: [PATCH 30/31] proc: move /proc/vmcore creation to fs/proc/vmcore.c
Message-ID: <20081017125420.GE22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 6c6dd71532e42437146e938afbba34471deba04f Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 14:36:31 +0400
Subject: [PATCH 30/31] proc: move /proc/vmcore creation to fs/proc/vmcore.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c        |    3 ---
 fs/proc/vmcore.c           |    6 +++---
 include/linux/crash_dump.h |    2 --
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 32a80b7..b0d3b34 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -61,7 +61,4 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_PROC_VMCORE
-	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
-#endif
 }
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 841368b..9074762 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -35,7 +35,7 @@ static u64 vmcore_size;
 /* Stores the physical address of elf header of crash image. */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
-struct proc_dir_entry *proc_vmcore = NULL;
+static struct proc_dir_entry *proc_vmcore = NULL;
 
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
@@ -165,7 +165,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	return acc;
 }
 
-const struct file_operations proc_vmcore_operations = {
+static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 };
 
@@ -655,7 +655,7 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
-	/* Initialize /proc/vmcore size if proc is already up. */
+	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
 	return 0;
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 025e4f5..0f60b58 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -17,8 +17,6 @@ static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
-extern const struct file_operations proc_vmcore_operations;
-extern struct proc_dir_entry *proc_vmcore;
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
-- 
1.5.6.5

