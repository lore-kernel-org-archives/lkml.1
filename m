Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXJIWKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXJIWKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXJIWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:10:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48850 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbXJIWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:10:36 -0400
Date: Tue, 9 Oct 2007 15:10:32 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@ftp.linux.org.uk>, Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: Avoid /proc/lockdep & lock_stat infinite
	output
Message-ID: <20071009221031.GA28980@tpepper-t42p.dolavim.us>
References: <20071009011551.GA3592@tpepper-t42p.dolavim.us> <20071009013011.GV8181@ftp.linux.org.uk> <1191928489.6848.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191928489.6848.4.camel@twins>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09 Oct at 13:14:49 +0200 a.p.zijlstra@chello.nl said:
> FWIW I had to do Tim's bits too. Just moving all output from the start
> into the show method didn't fix it.

Yes.  The way the original lockdep_proc.c code was doing its pointers
around its seq data was definitely wrong, regardless of the output
outside of _show().

> -static void *l_start(struct seq_file *m, loff_t *pos)
> +static void *l_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct lock_class *class = m->private;
> -
> -	if (&class->lock_entry == all_lock_classes.next)
> -		seq_printf(m, "all lock classes:\n");
> -
> -	return class;
> +	(*pos)++;
> +	return l_start(m, pos);
>  }

Isn't this is going to make l_start/l_next() approach O(n^2) when they can
be more like O(n)?  It appears to be the case that _next() will always
get a valid *v, so you can just step immediately to the next element.
The _start() seems to be the only place where you'd actually need to
search based on *pos.

The below moves the headers out of the _start() functions, but by using
SEQ_START_TOKEN (as appears to be the trend in other seq_file users)
to differentiate.  This means *pos==0 then is the header and *pos==1..n
are the lock class elements 0..(n-1), which again appears to be what
others are doing.

================================================================

Both /proc/lockdep and /proc/lock_stat output may loop infinitely.

When a read() requests an amount of data smaller than the amount of data
that the seq_file's foo_show() outputs, the output starts looping and
outputs the "stuck" element's data infinitely.  There may be multiple
sequential calls to foo_start(), foo_next()/foo_show(), and foo_stop()
for a single open with sequential read of the file.  The _start() does not
have to start with the 0th element and _show() might be called multiple
times in a row for the same element for a given open/read of the seq_file.

Also header output should not be happening in _start().  All output should
be in _show(), which SEQ_START_TOKEN is meant to help.  Having output in
_start() may also negatively impact seq_file's seq_read() and traverse()
accounting.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ftp.linux.org.uk>

---

Compared to my previous version this now also has output only happening
in _show().  Compared to Peter's version with output only in _show(),
this is more efficient in its _next().


--- linux-2.6.23-rc9.orig/kernel/lockdep_proc.c
+++ linux-2.6.23-rc9/kernel/lockdep_proc.c
@@ -25,28 +25,38 @@
 
 static void *l_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_class *class = v;
+	struct lock_class *class;
 
 	(*pos)++;
 
+	if (v == SEQ_START_TOKEN)
+		class = m->private;
+	else {
+		class = v;
+
+		if (class->lock_entry.next != &all_lock_classes)
+			class = list_entry(class->lock_entry.next,
+					   struct lock_class, lock_entry);
+		else
+			class = NULL;
+	}
-	if (class->lock_entry.next != &all_lock_classes)
-		class = list_entry(class->lock_entry.next, struct lock_class,
-				  lock_entry);
-	else
-		class = NULL;
-	m->private = class;
 
 	return class;
 }
 
 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	struct lock_class *class = m->private;
+	struct lock_class *class;
+	loff_t i = 0;
 
-	if (&class->lock_entry == all_lock_classes.next)
-		seq_printf(m, "all lock classes:\n");
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
 
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		if (++i == *pos)
+		return class;
+	}
+	return NULL;
-	return class;
 }
 
 static void l_stop(struct seq_file *m, void *v)
@@ -101,10 +111,15 @@ static void print_name(struct seq_file *
 static int l_show(struct seq_file *m, void *v)
 {
 	unsigned long nr_forward_deps, nr_backward_deps;
-	struct lock_class *class = m->private;
+	struct lock_class *class = v;
 	struct lock_list *entry;
 	char c1, c2, c3, c4;
 
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(m, "all lock classes:\n");
+		return 0;
+	}
+
 	seq_printf(m, "%p", class->key);
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
@@ -523,10 +538,11 @@ static void *ls_start(struct seq_file *m
 {
 	struct lock_stat_seq *data = m->private;
 
-	if (data->iter == data->stats)
-		seq_header(m);
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
 
-	if (data->iter == data->iter_end)
+	data->iter = data->stats + *pos;
+	if (data->iter >= data->iter_end)
 		data->iter = NULL;
 
 	return data->iter;
@@ -538,8 +554,13 @@ static void *ls_next(struct seq_file *m,
 
 	(*pos)++;
 
+	if (v == SEQ_START_TOKEN)
+		data->iter = data->stats;
+	else {
+		data->iter = v;
+		data->iter++;
+	}
+
-	data->iter = v;
-	data->iter++;
 	if (data->iter == data->iter_end)
 		data->iter = NULL;
 
@@ -552,9 +573,11 @@ static void ls_stop(struct seq_file *m, 
 
 static int ls_show(struct seq_file *m, void *v)
 {
-	struct lock_stat_seq *data = m->private;
+	if (v == SEQ_START_TOKEN)
+		seq_header(m);
+	else
+		seq_stats(m, v);
 
-	seq_stats(m, data->iter);
 	return 0;
 }
 
