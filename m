Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYJQMjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYJQMjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYJQMjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:39:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:3906 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbYJQMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PBN/TiyPO1RoHi2vvemu6jWyYVra8YxE3azV07HgrFNprSOl3iMWSH3CIh35M6MaGE
         JgojZcH7QD4i9gQkO0u06NrB9dvWwn6swyIjjACGp2UZGAuEPW3bVwGiFFPgWi9faXWO
         pEwTC36Zg2uOf1BpmVzBIGQ/4otlOhvoVjbes=
Date: Fri, 17 Oct 2008 16:42:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: [PATCH 06/31] proc: move /proc/stram to m68k-specific code
Message-ID: <20081017124222.GG22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 0b0306563d7b79ad215c62499ed538d15372f574 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 13:49:34 +0400
Subject: [PATCH 06/31] proc: move /proc/stram to m68k-specific code

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/m68k/atari/stram.c |   28 ++++++++++++++++++++++------
 fs/proc/proc_misc.c     |   13 -------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index 04c69ff..6ec3b7f 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -42,6 +42,7 @@
 /* abbrev for the && above... */
 #define DO_PROC
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #endif
 
 /*
@@ -323,19 +324,16 @@ static int remove_region( BLOCK *block )
 
 #ifdef DO_PROC
 
-#define	PRINT_PROC(fmt,args...) len += sprintf( buf+len, fmt, ##args )
+#define	PRINT_PROC(fmt,args...) seq_printf( m, fmt, ##args )
 
-int get_stram_list( char *buf )
+static int stram_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	BLOCK *p;
 
 	PRINT_PROC("Total ST-RAM:      %8u kB\n",
 			   (stram_end - stram_start) >> 10);
 	PRINT_PROC( "Allocated regions:\n" );
 	for( p = alloc_list; p; p = p->next ) {
-		if (len + 50 >= PAGE_SIZE)
-			break;
 		PRINT_PROC("0x%08lx-0x%08lx: %s (",
 			   virt_to_phys(p->start),
 			   virt_to_phys(p->start+p->size-1),
@@ -346,9 +344,27 @@ int get_stram_list( char *buf )
 			PRINT_PROC( "??)\n" );
 	}
 
-	return( len );
+	return 0;
+}
+
+static int stram_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stram_proc_show, NULL);
 }
 
+static const struct file_operations stram_proc_fops = {
+	.open		= stram_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_stram_init(void)
+{
+	proc_create("stram", 0, NULL, &stram_proc_fops);
+	return 0;
+}
+module_init(proc_stram_init);
 #endif
 
 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 8a9fc90..c70e2f5 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -62,7 +62,6 @@
  * have a way to deal with that gracefully. Right now I used straightforward
  * wrappers, but this needs further analysis wrt potential overflows.
  */
-extern int get_stram_list(char *);
 extern int get_exec_domain_list(char *);
 
 static int proc_calc_metrics(char *page, char **start, off_t off,
@@ -196,15 +195,6 @@ static const struct file_operations proc_vmstat_file_operations = {
 	.release	= seq_release,
 };
 
-#ifdef CONFIG_STRAM_PROC
-static int stram_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len = get_stram_list(page);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-#endif
-
 #ifdef CONFIG_BLOCK
 static int partitions_open(struct inode *inode, struct file *file)
 {
@@ -660,9 +650,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-#ifdef CONFIG_STRAM_PROC
-		{"stram",	stram_read_proc},
-#endif
 		{"filesystems",	filesystems_read_proc},
 		{"cmdline",	cmdline_read_proc},
 		{"execdomains",	execdomains_read_proc},
-- 
1.5.6.5

