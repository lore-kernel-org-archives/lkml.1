Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbXJIBQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbXJIBQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXJIBQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:16:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46762 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbXJIBQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:16:08 -0400
Date: Mon, 8 Oct 2007 18:15:51 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: Avoid /proc/lockdep & lock_stat infinite output
Message-ID: <20071009011551.GA3592@tpepper-t42p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a read() requests an amount of data smaller than the amount of data
that the seq_file's foo_show() outputs, the output starts looping and
outputs the "stuck" element's data infinitely.  There may be multiple
sequential calls to foo_start(), foo_next()/foo_show(), and foo_stop()
for a single open with sequential read of the file.  The _start() does not
have to start with the 0th element and _show() might be called multiple
times in a row for the same element for a given open/read of the seq_file.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>

---

Assuming people are fine with this, it should probably find its way
to stable.

If you haven't seen the infinite output: it's easy to trigger with a
simple 'cat /proc/lockdep' generally for me, a cat /proc/lock_stat piped
to a file or for either of them a dd with the default bs=512 (or smaller)
should do the job also.

With this change to the lock_stat handler the data->iter member no longer
attempts to hold state across calls, so it could be taken out of the
lock_stat_seq struct and replace by a local variable in each function
but that isn't a clear win to me so I just left it.

--- linux-2.6.23-rc9.orig/kernel/lockdep_proc.c
+++ linux-2.6.23-rc9/kernel/lockdep_proc.c
@@ -34,19 +34,23 @@ static void *l_next(struct seq_file *m, 
 				  lock_entry);
 	else
 		class = NULL;
-	m->private = class;
 
 	return class;
 }
 
 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	struct lock_class *class = m->private;
+	struct lock_class *class;
+	loff_t i = 0;
 
-	if (&class->lock_entry == all_lock_classes.next)
+	if (*pos == 0)
 		seq_printf(m, "all lock classes:\n");
 
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		if (i++ == *pos)
+			return class;
+	}
+	return NULL;
-	return class;
 }
 
 static void l_stop(struct seq_file *m, void *v)
@@ -101,7 +105,7 @@ static void print_name(struct seq_file *
 static int l_show(struct seq_file *m, void *v)
 {
 	unsigned long nr_forward_deps, nr_backward_deps;
-	struct lock_class *class = m->private;
+	struct lock_class *class = v;
 	struct lock_list *entry;
 	char c1, c2, c3, c4;
 
@@ -523,12 +527,15 @@ static void *ls_start(struct seq_file *m
 {
 	struct lock_stat_seq *data = m->private;
 
-	if (data->iter == data->stats)
-		seq_header(m);
+	data->iter = data->stats;
+	data->iter += *pos;
 
-	if (data->iter == data->iter_end)
+	if (data->iter >= data->iter_end)
 		data->iter = NULL;
 
+	if (data->iter == data->stats)
+		seq_header(m);
+
 	return data->iter;
 }
 
