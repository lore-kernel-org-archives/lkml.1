Return-Path: <linux-kernel-owner+w=401wt.eu-S1751096AbXBMVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbXBMVjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXBMVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:39:18 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43337 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXBMVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:39:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       devel@openvz.org, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Fix SAK_work workqueue initialization.
References: <20070213144814.GA6017@localhost.sw.ru>
Date: Tue, 13 Feb 2007 14:38:58 -0700
In-Reply-To: <20070213144814.GA6017@localhost.sw.ru> (Alexey Dobriyan's
	message of "Tue, 13 Feb 2007 17:48:14 +0300")
Message-ID: <m1ejotspot.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Somewhere in the rewrite of the work queues my cleanup of SAK handling
got broken.  Maybe I didn't retest it properly or possibly the API
was changing so fast I missed something.  Regardless currently
triggering a SAK now generates an ugly BUG_ON and kills the kernel.

Thanks to Alexey Dobriyan <adobriyan@openvz.org> for spotting this.

This modifies the use of SAK_work to initialize it when the data
structure it resides in is initialized, and to simply call
schedule_work when we need to generate a SAK.  I update both
data structures that have a SAK_work member for consistency.

All of the old PREPARE_WORK calls that are now gone.

If we call schedule_work again before it has processed it
has generated the first SAK it will simply ignore the duplicate
schedule_work request.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/keyboard.c |    1 -
 drivers/char/sysrq.c    |    1 -
 drivers/char/tty_io.c   |    3 +--
 drivers/char/vt.c       |    1 +
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index c654a3e..cb8d691 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -596,7 +596,6 @@ static void fn_spawn_con(struct vc_data *vc)
 static void fn_SAK(struct vc_data *vc)
 {
 	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
-	PREPARE_WORK(SAK_work, vc_SAK);
 	schedule_work(SAK_work);
 }
 
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 3757610..be73c80 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -89,7 +89,6 @@ static struct sysrq_key_op sysrq_loglevel_op = {
 static void sysrq_handle_SAK(int key, struct tty_struct *tty)
 {
 	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
-	PREPARE_WORK(SAK_work, vc_SAK);
 	schedule_work(SAK_work);
 }
 static struct sysrq_key_op sysrq_SAK_op = {
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 65672c5..5289254 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3442,7 +3442,6 @@ void do_SAK(struct tty_struct *tty)
 {
 	if (!tty)
 		return;
-	PREPARE_WORK(&tty->SAK_work, do_SAK_work);
 	schedule_work(&tty->SAK_work);
 }
 
@@ -3568,7 +3567,7 @@ static void initialize_tty_struct(struct tty_struct *tty)
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->read_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
-	INIT_WORK(&tty->SAK_work, NULL);
+	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
 
 /*
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 94ce3e7..c3f8e38 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2635,6 +2635,7 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
 		vc->vc_kmalloced = 0;
-- 
1.4.4.1.g278f

