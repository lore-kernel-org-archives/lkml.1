Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZCHTCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZCHTCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZCHTCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:02:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:20727 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZCHTCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HsdBwq/1p0snBqwFE00+2JWBJKn/H9eY18qFN6IGTyWtrrUpsaYtIz0SwwUu7xzjna
         sSKDHupt2ks64zraFrU1jNu+Papkimt0x1gl6l59J52YH8jqpn/FWVvbY4Mf4FGzgzNr
         6BkET5nrJi00qNwxNZiwcJII5oWjJ+Et+mfKA=
Date: Sun, 8 Mar 2009 22:09:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc_dointvec_userhz_jiffies "breakage"
Message-ID: <20090308190931.GA15348@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i386, HZ=1000, jiffies_to_clock_t() convert time in somewhat
strange way from user's point of view:

	# echo 500 >/proc/sys/vm/dirty_writeback_centisecs 
	# cat /proc/sys/vm/dirty_writeback_centisecs 
	499

So, we have 5000 jiffies converted to only 499 clock ticks and reported
back.

TICK_NSEC = 999848
ACTHZ = 256039

Keeping in-kernel variable in units passed from userspace will fix issue
of course, but this probably won't be right for every sysctl.

http://bugzilla.kernel.org/show_bug.cgi?id=9838


diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 7300ecd..9344547 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -109,8 +109,8 @@ extern int dirty_background_ratio;
 extern unsigned long dirty_background_bytes;
 extern int vm_dirty_ratio;
 extern unsigned long vm_dirty_bytes;
-extern int dirty_writeback_interval;
-extern int dirty_expire_interval;
+extern unsigned int dirty_writeback_interval;
+extern unsigned int dirty_expire_interval;
 extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..2e490a3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1010,7 +1010,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_userhz_jiffies,
+		.proc_handler	= &proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 74dc57c..8aeb3ae 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -92,14 +92,14 @@ int vm_dirty_ratio = 10;
 unsigned long vm_dirty_bytes;
 
 /*
- * The interval between `kupdate'-style writebacks, in jiffies
+ * The interval between `kupdate'-style writebacks
  */
-int dirty_writeback_interval = 5 * HZ;
+unsigned int dirty_writeback_interval = 5 * 100; /* sentiseconds */
 
 /*
- * The longest number of jiffies for which data is allowed to remain dirty
+ * The longest time for which data is allowed to remain dirty
  */
-int dirty_expire_interval = 30 * HZ;
+unsigned int dirty_expire_interval = 30 * 100; /* sentiseconds */
 
 /*
  * Flag that makes the machine dump writes/reads and block dirtyings.
@@ -770,9 +770,9 @@ static void wb_kupdate(unsigned long arg)
 
 	sync_supers();
 
-	oldest_jif = jiffies - dirty_expire_interval;
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
 	start_jif = jiffies;
-	next_jif = start_jif + dirty_writeback_interval;
+	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
@@ -801,9 +801,9 @@ static void wb_kupdate(unsigned long arg)
 int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_userhz_jiffies(table, write, file, buffer, length, ppos);
+	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+		mod_timer(&wb_timer, jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	else
 		del_timer(&wb_timer);
 	return 0;
@@ -905,7 +905,7 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+	mod_timer(&wb_timer, jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
