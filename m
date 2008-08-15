Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYHOVdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYHOVdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYHOVcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:32:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYHOVcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:32:53 -0400
Message-ID: <48A5F5C6.2090204@redhat.com>
Date: Fri, 15 Aug 2008 23:31:50 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Mount ext3 with barrier=1 doesn't send real barrier bio?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I run some barrier tests over device-mapper (which currently doesn't
support barrier bio at all) and even if I set barrier=1 in ext3 mount,
there is never any bio with barrier flag... (in 2.6.27-rc)

How is the barrier=1 flag supposed to work in ext3 (JBD) now?

See:
If you specify barrier=1, JFS_BARRIER flag is set in ext3_init_journal_params
	journal->j_flags |= JFS_BARRIER;

Now, journal_write_commit_record is called and this happens:

	if (journal->j_flags & JFS_BARRIER) {
		set_buffer_ordered(bh);
		barrier_done = 1;
	}
	ret = sync_dirty_buffer(bh);

	if (barrier_done)
		clear_buffer_ordered(bh);

	if (ret == -EOPNOTSUPP && barrier_done) {
	...

>From this code I expect that EOPNOTSUPP is returned if barrier is not
supported (yes, that exactly does device-mapper now without barrier patches).

But it *never* happens because:

sync_dirty_buffer always calls 
	submit_bh(WRITE_SYNC, bh)

and in submit_bh is this test:

	if (buffer_ordered(bh) && (rw == WRITE))
		rw = WRITE_BARRIER;

but there is rw == WRITE_SYNC, not WRITE !

So the barrier flag for bio is never set and normal sync write
is performed.

Why it isn't done like in attached patch? Is it intentional or it is bug?

I think it was caused by change in this commit:

commit 18ce3751ccd488c78d3827e9f6bf54e6322676fb
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Jul 1 09:07:34 2008 +0200

    Properly notify block layer of sync writes

Milan
--

Set BIO_RW_BARRIER flag even for submit_bh sync write request.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 fs/buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2926,16 +2926,16 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
 
-	if (buffer_ordered(bh) && (rw == WRITE))
-		rw = WRITE_BARRIER;
-
 	/*
 	 * Only clear out a write error when rewriting, should this
 	 * include WRITE_SYNC as well?
 	 */
-	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
+	if (test_set_buffer_req(bh) && rw == WRITE)
 		clear_buffer_write_io_error(bh);
 
+	if (buffer_ordered(bh) && ((rw & RW_MASK) == WRITE))
+		rw |= (1 << BIO_RW_BARRIER);
+
 	/*
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around




