Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYFAQSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYFAQSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYFAQSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:18:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37528 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbYFAQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=gwsylCZMhZsCCYYaTYQGTQGDRZAzkLKvetMvorfXgn9DA592h/J2vUw3wKihtsZNXTSE2Dt4fK5EMuQ63Wx2FfKiwlSROw71KegCj8mQuihh+N9Ck528YPT7iG0AEnxU6QGMkYn8TcmZpYy7dRniPi6TS0BaRnmwRdAQJ7erdV8=
Message-ID: <4842CB9A.1080800@gmail.com>
Date: Sun, 01 Jun 2008 21:47:30 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ftrace: prevent freeing of all failed updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent freeing of records which cause problems and correspond to function from
core kernel text. A new flag, FTRACE_FL_CONVERTED is used to mark a record
as "converted". All other records are patched lazily to NOPs. Failed records
now also remain on frace_hash table. Each invocation of ftrace_record_ip now
checks whether the traced function has ever been recorded (including past
failures) and doesn't re-record it again.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b482fe8..fc4979a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -49,6 +49,7 @@ enum {
 	FTRACE_FL_FILTER	= (1 << 2),
 	FTRACE_FL_ENABLED	= (1 << 3),
 	FTRACE_FL_NOTRACE	= (1 << 4),
+	FTRACE_FL_CONVERTED	= (1 << 5),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1843edc..33cee36 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -217,6 +217,12 @@ ftrace_add_hash(struct dyn_ftrace *node, unsigned long key)
 	hlist_add_head_rcu(&node->node, &ftrace_hash[key]);
 }
 
+/* called from kstop_machine */
+static inline void ftrace_del_hash(struct dyn_ftrace *node)
+{
+	hlist_del(&node->node);
+}
+
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	/* no locking, only called from kstop_machine */
@@ -333,12 +339,11 @@ ftrace_record_ip(unsigned long ip)
 #define FTRACE_ADDR ((long)(ftrace_caller))
 #define MCOUNT_ADDR ((long)(mcount))
 
-static void
+static int
 __ftrace_replace_code(struct dyn_ftrace *rec,
 		      unsigned char *old, unsigned char *new, int enable)
 {
 	unsigned long ip, fl;
-	int failed;
 
 	ip = rec->ip;
 
@@ -365,7 +370,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 
 		if ((fl ==  (FTRACE_FL_FILTER | FTRACE_FL_ENABLED)) ||
 		    (fl == 0) || (rec->flags & FTRACE_FL_NOTRACE))
-			return;
+			return 0;
 
 		/*
 		 * If it is enabled disable it,
@@ -389,7 +394,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 			 */
 			fl = rec->flags & (FTRACE_FL_NOTRACE | FTRACE_FL_ENABLED);
 			if (fl == FTRACE_FL_NOTRACE)
-				return;
+				return 0;
 
 			new = ftrace_call_replace(ip, FTRACE_ADDR);
 		} else
@@ -397,34 +402,24 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 
 		if (enable) {
 			if (rec->flags & FTRACE_FL_ENABLED)
-				return;
+				return 0;
 			rec->flags |= FTRACE_FL_ENABLED;
 		} else {
 			if (!(rec->flags & FTRACE_FL_ENABLED))
-				return;
+				return 0;
 			rec->flags &= ~FTRACE_FL_ENABLED;
 		}
 	}
 
-	failed = ftrace_modify_code(ip, old, new);
-	if (failed) {
-		unsigned long key;
-		/* It is possible that the function hasn't been converted yet */
-		key = hash_long(ip, FTRACE_HASHBITS);
-		if (!ftrace_ip_in_hash(ip, key)) {
-			rec->flags |= FTRACE_FL_FAILED;
-			ftrace_free_rec(rec);
-		}
-
-	}
+	return ftrace_modify_code(ip, old, new);
 }
 
 static void ftrace_replace_code(int enable)
 {
+	int i, failed;
 	unsigned char *new = NULL, *old = NULL;
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
-	int i;
 
 	if (enable)
 		old = ftrace_nop_replace();
@@ -439,7 +434,15 @@ static void ftrace_replace_code(int enable)
 			if (rec->flags & FTRACE_FL_FAILED)
 				continue;
 
-			__ftrace_replace_code(rec, old, new, enable);
+			failed = __ftrace_replace_code(rec, old, new, enable);
+			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
+				rec->flags |= FTRACE_FL_FAILED;
+				if ((system_state == SYSTEM_BOOTING) ||
+				    !kernel_text_address(rec->ip)) {
+					ftrace_del_hash(rec);
+					ftrace_free_rec(rec);
+				}
+			}
 		}
 	}
 }
@@ -468,7 +471,6 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
 		rec->flags |= FTRACE_FL_FAILED;
-		ftrace_free_rec(rec);
 		return 0;
 	}
 	return 1;
@@ -596,8 +598,7 @@ unsigned long		ftrace_update_tot_cnt;
 static int __ftrace_update_code(void *ignore)
 {
 	struct dyn_ftrace *p;
-	struct hlist_head head;
-	struct hlist_node *t;
+	struct hlist_node *t, *n;
 	int save_ftrace_enabled;
 	cycle_t start, stop;
 	int i;
@@ -611,18 +612,33 @@ static int __ftrace_update_code(void *ignore)
 
 	/* No locks needed, the machine is stopped! */
 	for (i = 0; i < FTRACE_HASHSIZE; i++) {
-		if (hlist_empty(&ftrace_hash[i]))
-			continue;
+		/* all CPUS are stopped, we are safe to modify code */
+		hlist_for_each_entry_safe(p, t, n, &ftrace_hash[i], node) {
+			/* Skip over failed records which have not been
+			 * freed. */
+			if (p->flags & FTRACE_FL_FAILED)
+				continue;
 
-		head = ftrace_hash[i];
-		INIT_HLIST_HEAD(&ftrace_hash[i]);
+			/* Unconverted records are always at the head of the
+			 * hash bucket. Once we encounter a converted record,
+			 * simply skip over to the next bucket. Saves ftraced
+			 * some processor cycles (ftrace does its bid for
+			 * global warming :-p ). */
+			if (p->flags & (FTRACE_FL_CONVERTED))
+				break;
 
-		/* all CPUS are stopped, we are safe to modify code */
-		hlist_for_each_entry(p, t, &head, node) {
-			if (ftrace_code_disable(p))
+			if (ftrace_code_disable(p)) {
+				p->flags |= FTRACE_FL_CONVERTED;
 				ftrace_update_cnt++;
-		}
+			} else {
+				if ((system_state == SYSTEM_BOOTING) ||
+				    !kernel_text_address(p->ip)) {
+					ftrace_del_hash(p);
+					ftrace_free_rec(p);
 
+				}
+			}
+		}
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
