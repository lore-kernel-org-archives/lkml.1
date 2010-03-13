Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab0CMAg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:36:57 -0500
Received: from kroah.org ([198.145.64.141]:47246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935565Ab0CMAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:36 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:17 2010
Message-Id: <20100313002717.164816903@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [137/145] dm: free dm_io before bio_endio not after
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit a97f925a32aad2a37971d7bfb657006acf04e42d upstream.

Free the dm_io structure before calling bio_endio() instead of after it,
to ensure that the io_pool containing it is not referenced after it is
freed.

This partially fixes a problem described here
  https://www.redhat.com/archives/dm-devel/2010-February/msg00109.html

thread 1:
bio_endio(bio, io_error);
/* scheduling happens */
					thread 2:
					close the device
					remove the device
thread 1:
free_io(md, io);

Thread 2, when removing the device, sees non-empty md->io_pool (because the
io hasn't been freed by thread 1 yet) and may crash with BUG in mempool_free.
Thread 1 may also crash, when freeing into a nonexisting mempool.

To fix this we must make sure that bio_endio() is the last call and
the md structure is not accessed afterwards.

There is another bio_endio in process_barrier, but it is called from the thread
and the thread is destroyed prior to freeing the mempools, so this call is
not affected by the bug.

A similar bug exists with module unloads - the module may be unloaded
immediately after bio_endio - but that is more difficult to fix.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -614,8 +614,10 @@ static void dec_pending(struct dm_io *io
 			if (!md->barrier_error && io_error != -EOPNOTSUPP)
 				md->barrier_error = io_error;
 			end_io_acct(io);
+			free_io(md, io);
 		} else {
 			end_io_acct(io);
+			free_io(md, io);
 
 			if (io_error != DM_ENDIO_REQUEUE) {
 				trace_block_bio_complete(md->queue, bio);
@@ -623,8 +625,6 @@ static void dec_pending(struct dm_io *io
 				bio_endio(bio, io_error);
 			}
 		}
-
-		free_io(md, io);
 	}
 }
 


