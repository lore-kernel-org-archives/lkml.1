Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZIQCqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZIQCqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZIQCqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:46:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZIQCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:46:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 11:44:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Am?rico_Wang <xiyou.wangcong@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3][mmotm] showing size of kcore
Message-Id: <20090917114404.d87b155d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	<20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, size of /proc/kcore which can be read by 'ls -l' is 0.
But it's not correct value.

This is a patch for showing size of /proc/kcore as following.

On x86-64, ls -l shows
 ... root root 140737486266368 2009-09-17 10:29 /proc/kcore
Then, 7FFFFFFE02000. This comes from vmalloc area's size.
(*) This shows "core" size, not  memory size.

This patch shows the size by updating "size" field in struct proc_dir_entry.
Later, lookup routine will create inode and fill inode->i_size based
on this value. Then, this has a problem.

 - Once inode is cached, inode->i_size will never be updated.

Then, this patch is not memory-hotplug-aware.

To update inode->i_size, we have to know dentry or inode.
But there is no way to lookup them by inside kernel. Hmmm....
Next patch will try it.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
@@ -107,6 +107,8 @@ static void free_kclist_ents(struct list
  */
 static void __kcore_update_ram(struct list_head *list)
 {
+	int nphdr;
+	size_t size;
 	struct kcore_list *tmp, *pos;
 	LIST_HEAD(garbage);
 
@@ -124,6 +126,7 @@ static void __kcore_update_ram(struct li
 	write_unlock(&kclist_lock);
 
 	free_kclist_ents(&garbage);
+	proc_root_kcore->size = get_kcore_size(&nphdr, &size);
 }
 
 
@@ -429,7 +432,8 @@ read_kcore(struct file *file, char __use
 	unsigned long start;
 
 	read_lock(&kclist_lock);
-	proc_root_kcore->size = size = get_kcore_size(&nphdr, &elf_buflen);
+	size = get_kcore_size(&nphdr, &elf_buflen);
+
 	if (buflen == 0 || *fpos >= size) {
 		read_unlock(&kclist_lock);
 		return 0;

