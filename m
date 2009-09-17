Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZIQGMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZIQGMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZIQGMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:12:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49827 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZIQGMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:12:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 15:10:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 2/3][mmotm] showing size of kcore v2
Message-Id: <20090917151016.99f7c5ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2375c9f90909162302m1fb89414o4f72b6b36e7cbb06@mail.gmail.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	<20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917114404.d87b155d.kamezawa.hiroyu@jp.fujitsu.com>
	<2375c9f90909162302m1fb89414o4f72b6b36e7cbb06@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 14:02:39 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > @@ -124,6 +126,7 @@ static void __kcore_update_ram(struct li
> >        write_unlock(&kclist_lock);
> >
> >        free_kclist_ents(&garbage);
> > +       proc_root_kcore->size = get_kcore_size(&nphdr, &size);
> 
> 
> This makes me to think if we will have some race condition here?
> Two processes can open kcore at the same time...
> 
Finally,
==
static void __kcore_update_ram(struct list_head *list)
{
 write_lock(&kclist_lock);
        if (kcore_need_update) {
                list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
                        if (pos->type == KCORE_RAM
                                || pos->type == KCORE_VMEMMAP)
                                list_move(&pos->list, &garbage);
                }
                list_splice_tail(list, &kclist_head);
        } else
                list_splice(list, &garbage);
        kcore_need_update = 0;
        write_unlock(&kclist_lock);
}

kclist itself is double checked under write_lock.
And, once updated, get_kcore_size()'s return vaule is static.
So, I think there are no race. But..Hmm...is this clearer ?

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, size of /proc/kcore which can be read by 'ls -l' is 0.
But it's not correct value.

This is a patch for showing size of /proc/kcore as following.

On x86-64, ls -l shows
 ... root root 140737486266368 2009-09-17 10:29 /proc/kcore
Then, 7FFFFFFE02000. This comes from vmalloc area's size.
This shows "core" size, not  memory size.

This patch shows the size by updating "size" field in struct proc_dir_entry.
Later, lookup routine will create inode and fill inode->i_size based
on this value. Then, this has a problem.

 - Once inode is cached, inode->i_size will never be updated.

Then, this patch is not memory-hotplug-aware.

To update inode->i_size, we have to know dentry or inode.
But there is no way to lookup them by inside kernel. Hmmm....
Next patch will try it.

Changelog:
 -moved upadting ->size under lock.

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
 
@@ -121,6 +123,7 @@ static void __kcore_update_ram(struct li
 	} else
 		list_splice(list, &garbage);
 	kcore_need_update = 0;
+	proc_root_kcore->size = get_kcore_size(&nphdr, &size);
 	write_unlock(&kclist_lock);
 
 	free_kclist_ents(&garbage);
@@ -429,7 +432,8 @@ read_kcore(struct file *file, char __use
 	unsigned long start;
 
 	read_lock(&kclist_lock);
-	proc_root_kcore->size = size = get_kcore_size(&nphdr, &elf_buflen);
+	size = get_kcore_size(&nphdr, &elf_buflen);
+
 	if (buflen == 0 || *fpos >= size) {
 		read_unlock(&kclist_lock);
 		return 0;







