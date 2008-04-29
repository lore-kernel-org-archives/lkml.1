Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbYD2Rbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbYD2Rbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759318AbYD2RVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:43528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293AbYD2RVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:51 -0400
Date: Tue, 29 Apr 2008 10:19:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Christopher Smith <x@xman.org>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [28/37] aio: io_getevents() should return if io_destroy() is
	invoked
Message-ID: <20080429171904.GC14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="aio-io_getevents-should-return-if-io_destroy-is-invoked.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeff Moyer <jmoyer@redhat.com>

commit e92adcba261fd391591bb63c1703185a04a41554 upstream

This patch wakes up a thread waiting in io_getevents if another thread
destroys the context.  This was tested using a small program that spawns a
thread to wait in io_getevents while the parent thread destroys the io context
and then waits for the getevents thread to exit.  Without this patch, the
program hangs indefinitely.  With the patch, the program exits as expected.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Christopher Smith <x@xman.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1166,7 +1166,10 @@ retry:
 				break;
 			if (min_nr <= i)
 				break;
-			ret = 0;
+			if (unlikely(ctx->dead)) {
+				ret = -EINVAL;
+				break;
+			}
 			if (to.timed_out)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
@@ -1231,6 +1234,13 @@ static void io_destroy(struct kioctx *io
 
 	aio_cancel_all(ioctx);
 	wait_for_all_aios(ioctx);
+
+	/*
+	 * Wake up any waiters.  The setting of ctx->dead must be seen
+	 * by other CPUs at this point.  Right now, we rely on the
+	 * locking done by the above calls to ensure this consistency.
+	 */
+	wake_up(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 

-- 
