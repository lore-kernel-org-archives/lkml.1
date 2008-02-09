Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYBIPV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYBIPV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYBIPVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:21:18 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:34250 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYBIPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ck4SvtZg2ceV14W77mkXPEW10xD5ayvctK3ERQjGzmuyPJ0OsyYcNuU/9Fz2tNNZFugd979chNWUuvRtsM9zfuOUqMOnPvA/WYrbKT0/xqMD2rcpnvFdYh3QZFhE2GJ/FdkSF/lHOBIH5ZbPs4mjjr7v6W93wCIsYDGzZEMoLSc=
Message-ID: <2f11576a0802090721u301f5e66v144651cec3e2a643@mail.gmail.com>
Date: Sun, 10 Feb 2008 00:21:15 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8][for -mm] mem_notify v6: introduce poll_wait_exclusive()
Cc: kosaki.motohiro@jp.fujitsu.com, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Jon Masters" <jonathan@jonmasters.org>, "Zan Lynx" <zlynx@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8d4d00decf1d6978
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 way of adding item to wait_queue,
  1. add_wait_queue()
  2. add_wait_queue_exclusive()
and add_wait_queue_exclusive() is very useful API.

unforunately, poll_wait_exclusive() against poll_wait() doesn't exist.
it means there is no way that wake up only 1 process where polled.
wake_up() is wake up all sleeping process by poll_wait(), not 1 process.

this patch introduce poll_wait_exclusive() new API for allow wake up
only 1 process.

<usage example>
unsigned int kosaki_poll(struct file *file,
		         struct poll_table_struct *wait)
{
	poll_wait_exclusive(file, &kosaki_wait_queue, wait);
	if (data_exist)
		return POLLIN | POLLRDNORM;
	return 0;
}
</usage example>

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 fs/eventpoll.c       |    7 +++++--
 fs/select.c          |    9 ++++++---
 include/linux/poll.h |   13 +++++++++++--
 3 files changed, 22 insertions(+), 7 deletions(-)



Index: b/fs/eventpoll.c
===================================================================
--- a/fs/eventpoll.c	2008-01-23 19:22:19.000000000 +0900
+++ b/fs/eventpoll.c	2008-01-23 21:11:56.000000000 +0900
@@ -675,7 +675,7 @@ out_unlock:
  * target file wakeup lists.
  */
 static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt)
+				 poll_table *pt, int exclusive)
 {
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
@@ -684,7 +684,10 @@ static void ep_ptable_queue_proc(struct
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (exclusive)
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
Index: b/fs/select.c
===================================================================
--- a/fs/select.c	2008-01-23 19:22:22.000000000 +0900
+++ b/fs/select.c	2008-01-23 21:11:56.000000000 +0900
@@ -48,7 +48,7 @@ struct poll_table_page {
  * poll table.
  */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-		       poll_table *p);
+		       poll_table *p, int exclusive);

 void poll_initwait(struct poll_wqueues *pwq)
 {
@@ -117,7 +117,7 @@ static struct poll_table_entry *poll_get

 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+		       poll_table *p, int exclusive)
 {
 	struct poll_table_entry *entry = poll_get_entry(p);
 	if (!entry)
@@ -126,7 +126,10 @@ static void __pollwait(struct file *filp
 	entry->filp = filp;
 	entry->wait_address = wait_address;
 	init_waitqueue_entry(&entry->wait, current);
-	add_wait_queue(wait_address, &entry->wait);
+	if (exclusive)
+		add_wait_queue_exclusive(wait_address, &entry->wait);
+	else
+		add_wait_queue(wait_address, &entry->wait);
 }

 #define FDS_IN(fds, n)		(fds->in + n)
Index: b/include/linux/poll.h
===================================================================
--- a/include/linux/poll.h	2008-01-23 19:22:55.000000000 +0900
+++ b/include/linux/poll.h	2008-02-03 20:28:27.000000000 +0900
@@ -28,7 +28,8 @@ struct poll_table_struct;
 /*
  * structures and helpers for f_op->poll implementations
  */
-typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *,
struct poll_table_struct *);
+typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *,
+				struct poll_table_struct *, int);

 typedef struct poll_table_struct {
 	poll_queue_proc qproc;
@@ -37,7 +38,15 @@ typedef struct poll_table_struct {
 static inline void poll_wait(struct file * filp, wait_queue_head_t *
wait_address, poll_table *p)
 {
 	if (p && wait_address)
-		p->qproc(filp, wait_address, p);
+		p->qproc(filp, wait_address, p, 0);
+}
+
+static inline void poll_wait_exclusive(struct file *filp,
+				       wait_queue_head_t *wait_address,
+				       poll_table *p)
+{
+	if (p && wait_address)
+		p->qproc(filp, wait_address, p, 1);
 }

 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
