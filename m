Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbZKFWaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbZKFWaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZKFWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:22 -0500
Received: from kroah.org ([198.145.64.141]:57021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbZKFWXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221547.995120375@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>
Subject: [67/99] fsnotify: do not set group for a mark before it is on the i_list
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=fsnotify-do-not-set-group-for-a-mark-before-it-is-on-the-i_list.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Paris <eparis@redhat.com>

commit 9f0d793b52eb2266359661369ef6303838904855 upstream.

fsnotify_add_mark is supposed to add a mark to the g_list and i_list and to
set the group and inode for the mark.  fsnotify_destroy_mark_by_entry uses
the fact that ->group != NULL to know if this group should be destroyed or
if it's already been done.

But fsnotify_add_mark sets the group and inode before it actually adds the
mark to the i_list and g_list.  This can result in a race in inotify, it
requires 3 threads.

sys_inotify_add_watch("file")	sys_inotify_add_watch("file")	sys_inotify_rm_watch([a])
inotify_update_watch()
inotify_new_watch()
inotify_add_to_idr()
   ^--- returns wd = [a]
				inotfiy_update_watch()
				inotify_new_watch()
				inotify_add_to_idr()
				fsnotify_add_mark()
				   ^--- returns wd = [b]
				returns to userspace;
								inotify_idr_find([a])
								   ^--- gives us the pointer from task 1
fsnotify_add_mark()
   ^--- this is going to set the mark->group and mark->inode fields, but will
return -EEXIST because of the race with [b].
								fsnotify_destroy_mark()
								   ^--- since ->group != NULL we call back
									into inotify_freeing_mark() which calls
								inotify_remove_from_idr([a])

since fsnotify_add_mark() failed we call:
inotify_remove_from_idr([a])     <------WHOOPS it's not in the idr, this could
					have been any entry added later!

The fix is to make sure we don't set mark->group until we are sure the mark is
on the inode and fsnotify_add_mark will return success.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inode_mark.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -324,11 +324,11 @@ int fsnotify_add_mark(struct fsnotify_ma
 	spin_lock(&group->mark_lock);
 	spin_lock(&inode->i_lock);
 
-	entry->group = group;
-	entry->inode = inode;
-
 	lentry = fsnotify_find_mark_entry(group, inode);
 	if (!lentry) {
+		entry->group = group;
+		entry->inode = inode;
+
 		hlist_add_head(&entry->i_list, &inode->i_fsnotify_mark_entries);
 		list_add(&entry->g_list, &group->mark_entries);
 


