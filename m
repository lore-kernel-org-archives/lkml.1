Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341Ab0B0Rfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:35:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65224 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab0B0Rfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OT+QB5ssKIRxRtI5eq69AunKGEEtIeYDNyBv9gSMmi7Ya2jStVb3ygxNpcu90cOnHi
         YN3Kdt/oyCJ+vrkvNxrWk5nhRDmExAKDj6ar9CkcCqaZwtQby6m3/H2rumM3CskPgwgy
         RXbtIdphO7YakR9YrXcvw2QdhP/1GNNoJJHOE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] relay: move remove_buf_file inside relay_close_buf
Date: Sat, 27 Feb 2010 20:35:37 +0300
Message-Id: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently remove_buf_file callback is called from from kobject
release method. This result in follow issue:
# blktrace -d /dev/sda1 -d /dev/sda -o test
blktrace_setup()
 dir = create_dir()
 rchan = relay_open(dir,...)
 ->create_buf_file_callback
    buf_file  = debugfs_create_file(dir, )

Userspace will open buf_file.
Later we make a decision to stop tracing
blktrace_down()
  relay_close(rhcan)  /* just decrement kobj reference  */
                      /* since it is not zero then callback not called */
  debugfs_remove(dir) /* FAIL due to non empty dir   */

Later user space will close the file and file will be deleted,
but directory still exist.
user_space_close()
 ->file_release
   ->release_buf_file_callback
     ->debugfs_remove(buf_file)

In fact this is general issue, blktrace is just one of examples.
We can not reliably remove parent dir until all users close the
buf_file.

We don't have to wait this long. File may be deleted
inside relay_close_buf().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 kernel/relay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index c705a41..dcf71c8 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -237,7 +237,6 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 static void relay_remove_buf(struct kref *kref)
 {
 	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
-	buf->chan->cb->remove_buf_file(buf->dentry);
 	relay_destroy_buf(buf);
 }
 
@@ -487,6 +486,7 @@ static void relay_close_buf(struct rchan_buf *buf)
 {
 	buf->finalized = 1;
 	del_timer_sync(&buf->timer);
+	buf->chan->cb->remove_buf_file(buf->dentry);
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
-- 
1.6.6

