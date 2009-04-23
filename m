Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZDWHjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZDWHjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZDWHaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:10 -0400
Received: from sous-sol.org ([216.99.217.87]:50345 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756326AbZDWHaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:07 -0400
Message-Id: <20090423072453.253967467@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 037/100] dm io: make sync_io uninterruptible
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-io-make-sync_io-uninterruptible.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: b64b6bf4fd8b678a9f8477c11773c38a0a246a6d

If someone sends signal to a process performing synchronous dm-io call,
the kernel may crash.

The function sync_io attempts to exit with -EINTR if it has pending signal,
however the structure "io" is allocated on stack, so already submitted io
requests end up touching unallocated stack space and corrupting kernel memory.

sync_io sets its state to TASK_UNINTERRUPTIBLE, so the signal can't break out
of io_schedule() --- however, if the signal was pending before sync_io entered
while (1) loop, the corruption of kernel memory will happen.

There is no way to cancel in-progress IOs, so the best solution is to ignore
signals at this point.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -370,16 +370,13 @@ static int sync_io(struct dm_io_client *
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!atomic_read(&io.count) || signal_pending(current))
+		if (!atomic_read(&io.count))
 			break;
 
 		io_schedule();
 	}
 	set_current_state(TASK_RUNNING);
 
-	if (atomic_read(&io.count))
-		return -EINTR;
-
 	if (error_bits)
 		*error_bits = io.error_bits;
 

