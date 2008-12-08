Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYLHNOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYLHNOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYLHNOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:14:41 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27281 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYLHNOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:14:40 -0500
To: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] initify: fix IN_ONESHOT unmount event watcher.
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 08 Dec 2008 16:13:20 +0300
Message-ID: <m31vwiizdb.fsf@openvz.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two weeks ago i've send the patch to lkml http://lkml.org/lkml/2008/11/26/229,
but unfortunately without response. Seems the issue wasn't fixed yet.
Who currently are responsible for inotify interface.

On umount two event will be dispatched to watcher:
1: inotify_dev_queue_event(.., IN_UNMOUNT,..)
2: remove_watch(watch, dev)
    ->inotify_dev_queue_event(.., IN_IGNORED, ..)
But if watcher has IN_ONESHOT bit set then the watcher will be released
inside first event. Which result in accessing invalid object later.
IMHO it is not pure regression. This bug wasn't triggered while initial
inotify interface testing phase because of another bug in IN_ONESHOT
handling logic :)
  commit ac74c00e499ed276a965e5b5600667d5dc04a84a
  Author: Ulisses Furquim <ulissesf@gmail.com>
  Date:   Fri Feb 8 04:18:16 2008 -0800
    inotify: fix check for one-shot watches before destroying them
    As the IN_ONESHOT bit is never set when an event is sent we must check it
    in the watch's mask and not in the event's mask.


TESTCASE:
mkdir mnt
mount -ttmpfs none mnt
mkdir mnt/d
./inotify mnt/d&
umount mnt ## << lockup or crash here

TESTSOURCE:
/* gcc -oinotify inotify.c */
#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>

int main(int argc, char **argv)
{
        char buf[1024];
        struct inotify_event *ie;
        char *p;
        int i;
        ssize_t l;

        p = argv[1];
        i = inotify_init();
        inotify_add_watch(i, p, ~0);

        l = read(i, buf, sizeof(buf));
        printf("read %d bytes\n", l);
        ie = (struct inotify_event *) buf;
        printf("event mask: %d\n", ie->mask);
	return 0;
}

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/inotify.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/inotify.c b/fs/inotify.c
index 7bbed1b..dae3f28 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -428,11 +428,13 @@ void inotify_unmount_inodes(struct list_head *list)
 		watches = &inode->inotify_watches;
 		list_for_each_entry_safe(watch, next_w, watches, i_list) {
 			struct inotify_handle *ih= watch->ih;
+			get_inotify_watch(watch);
 			mutex_lock(&ih->mutex);
 			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
 						 NULL, NULL);
 			inotify_remove_watch_locked(ih, watch);
 			mutex_unlock(&ih->mutex);
+			put_inotify_watch(watch);
 		}
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
-- 
1.5.4.3
