Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYLCUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYLCUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYLCTyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:43 -0500
Received: from kroah.org ([198.145.64.141]:60423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755488AbYLCTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:41 -0500
Date: Wed, 3 Dec 2008 11:53:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, dann frazier <dannf@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 066/104] net: Fix soft lockups/OOM issues w/ unix garbage
	collector (CVE-2008-5300)
Message-ID: <20081203195321.GO8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-soft-lockups-oom-issues-w-unix-garbage-collector.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: dann frazier <dannf@hp.com>

commit 5f23b734963ec7eaa3ebcd9050da0c9b7d143dd3 upstream.

This is an implementation of David Miller's suggested fix in:
  https://bugzilla.redhat.com/show_bug.cgi?id=470201

It has been updated to use wait_event() instead of
wait_event_interruptible().

Paraphrasing the description from the above report, it makes sendmsg()
block while UNIX garbage collection is in progress. This avoids a
situation where child processes continue to queue new FDs over a
AF_UNIX socket to a parent which is in the exit path and running
garbage collection on these FDs. This contention can result in soft
lockups and oom-killing of unrelated processes.

Signed-off-by: dann frazier <dannf@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/af_unix.h |    1 +
 net/unix/af_unix.c    |    2 ++
 net/unix/garbage.c    |   13 ++++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -9,6 +9,7 @@
 extern void unix_inflight(struct file *fp);
 extern void unix_notinflight(struct file *fp);
 extern void unix_gc(void);
+extern void wait_for_unix_gc(void);
 
 #define UNIX_HASH_SIZE	256
 
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1341,6 +1341,7 @@ static int unix_dgram_sendmsg(struct kio
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
+	wait_for_unix_gc();
 	err = scm_send(sock, msg, siocb->scm);
 	if (err < 0)
 		return err;
@@ -1491,6 +1492,7 @@ static int unix_stream_sendmsg(struct ki
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
+	wait_for_unix_gc();
 	err = scm_send(sock, msg, siocb->scm);
 	if (err < 0)
 		return err;
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -80,6 +80,7 @@
 #include <linux/file.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
+#include <linux/wait.h>
 
 #include <net/sock.h>
 #include <net/af_unix.h>
@@ -91,6 +92,7 @@
 static LIST_HEAD(gc_inflight_list);
 static LIST_HEAD(gc_candidates);
 static DEFINE_SPINLOCK(unix_gc_lock);
+static DECLARE_WAIT_QUEUE_HEAD(unix_gc_wait);
 
 unsigned int unix_tot_inflight;
 
@@ -266,12 +268,16 @@ static void inc_inflight_move_tail(struc
 		list_move_tail(&u->link, &gc_candidates);
 }
 
-/* The external entry point: unix_gc() */
+static bool gc_in_progress = false;
 
-void unix_gc(void)
+void wait_for_unix_gc(void)
 {
-	static bool gc_in_progress = false;
+	wait_event(unix_gc_wait, gc_in_progress == false);
+}
 
+/* The external entry point: unix_gc() */
+void unix_gc(void)
+{
 	struct unix_sock *u;
 	struct unix_sock *next;
 	struct sk_buff_head hitlist;
@@ -376,6 +382,7 @@ void unix_gc(void)
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
 	gc_in_progress = false;
+	wake_up(&unix_gc_wait);
 
  out:
 	spin_unlock(&unix_gc_lock);

