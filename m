Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbXGOTEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbXGOTEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXGOTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:04:45 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33830
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750841AbXGOTEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:04:45 -0400
Date: Sun, 15 Jul 2007 21:06:12 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [4/5] fs/locks.c: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715190612.GI4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070715185409.GE4034@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715185409.GE4034@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/locks.c: use list_for_each_entry() instead of list_for_each() in
posix_locks_deadlock() and get_locks_status()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/locks.c b/fs/locks.c
index 431a8b8..d09c6bd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -702,13 +702,12 @@ EXPORT_SYMBOL(posix_test_lock);
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
-	struct list_head *tmp;
+	struct file_lock *fl;
 
 next_task:
 	if (posix_same_owner(caller_fl, block_fl))
 		return 1;
-	list_for_each(tmp, &blocked_list) {
-		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
+	list_for_each_entry(fl, &blocked_list, fl_link) {
 		if (posix_same_owner(fl, block_fl)) {
 			fl = fl->fl_next;
 			block_fl = fl;
@@ -2159,24 +2158,22 @@ static void move_lock_status(char **p, off_t* pos, off_t offset)
 
 int get_locks_status(char *buffer, char **start, off_t offset, int length)
 {
-	struct list_head *tmp;
+	struct file_lock *fl;
 	char *q = buffer;
 	off_t pos = 0;
 	int i = 0;
 
 	lock_kernel();
-	list_for_each(tmp, &file_lock_list) {
-		struct list_head *btmp;
-		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
+	list_for_each_entry(fl, &file_lock_list, fl_link) {
+		struct file_lock *bfl;
+
 		lock_get_status(q, fl, ++i, "");
 		move_lock_status(&q, &pos, offset);
 
 		if(pos >= offset+length)
 			goto done;
 
-		list_for_each(btmp, &fl->fl_block) {
-			struct file_lock *bfl = list_entry(btmp,
-					struct file_lock, fl_block);
+		list_for_each_entry(bfl, &fl->fl_block, fl_block) {
 			lock_get_status(q, bfl, i, " ->");
 			move_lock_status(&q, &pos, offset);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    I am incapable of conceiving infinity, and yet I do not accept finity
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
