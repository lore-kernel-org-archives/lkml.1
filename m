Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZG0Suy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZG0Suy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZG0Suy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:50:54 -0400
Received: from mout7.freenet.de ([195.4.92.97]:35395 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbZG0Sux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:50:53 -0400
X-Greylist: delayed 5094 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 14:50:53 EDT
Date: Mon, 27 Jul 2009 19:25:42 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: fs_other@kernel-bugs.osdl.org, Russell Bell <russellbell@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, josef@redhat.com,
       Eric Paris <eparis@redhat.com>, Robert Love <rlove@rlove.org>,
       John McCutchan <john@johnmccutchan.com>
Subject: [PATCH] inotify: fix the running away counter of user watches
Message-ID: <20090727172542.GA5104@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-purgate-ID: 149285::1248715551-00006ABE-0F5D2F02/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The counter of userspace inotify watches is incremented when a watch is
added, but was never decremented. This patch uses the fsnotify callback
(freeing_marks, which in turn calls inotify_ignored_and_remove_idr of
inotify userspace interface) called when an fsnotify mark is removed.

The bug has been reported in

    http://bugzilla.kernel.org/show_bug.cgi?id=12754

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---

Sorry for long Cc:, I'm a little confused about "fs_other@" (and the
list of participants) in the bug report.

The patch works in my limited testing. I just did:

    # echo 10 >/proc/sys/fs/inotify/max_user_watches
    # inotify-watch -r /lib # to max the counter
    Ctrl-C
    # inotify-watch /bin/true # must work

in a clean environment (init=/bin/bash).

But I don't know whether it safe to access the counter in this
callback, nor am I sure the patch is enough.

 fs/notify/inotify/inotify_user.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index ff27a29..c2d94df 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -404,6 +404,7 @@ skip_send_ignore:
 
 	/* removed from idr, drop that reference */
 	fsnotify_put_mark(entry);
+	atomic_dec(&group->inotify_data.user->inotify_watches);
 }
 
 /* ding dong the mark is dead */
-- 
1.6.4.rc3.56.g32a7


