Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbZB0A2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbZB0A2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760455AbZB0A2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:28:07 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34821 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434AbZB0A2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:28:05 -0500
Date: Thu, 26 Feb 2009 18:28:04 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] keys: make procfiles per-user-namespace
Message-ID: <20090227002804.GD31098@us.ibm.com>
References: <20090227002709.GA31049@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227002709.GA31049@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restrict the /proc/keys and /proc/key-users output to keys
belonging to the same user namespace as the reading task.

We may want to make this more complicated - so that any
keys in a user-namespace which is belongs to the reading
task are also shown.  But let's see if anyone wants that
first.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 security/keys/proc.c |   55 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/security/keys/proc.c b/security/keys/proc.c
index 7f508de..769f9bd 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -91,6 +91,28 @@ __initcall(key_proc_init);
  */
 #ifdef CONFIG_KEYS_DEBUG_PROC_KEYS
 
+static struct rb_node *__key_serial_next(struct rb_node *n)
+{
+	while (n) {
+		struct key *key = rb_entry(n, struct key, serial_node);
+		if (key->user->user_ns == current_user_ns())
+			break;
+		n = rb_next(n);
+	}
+	return n;
+}
+
+static struct rb_node *key_serial_next(struct rb_node *n)
+{
+	return __key_serial_next(rb_next(n));
+}
+
+static struct rb_node *key_serial_first(struct rb_root *r)
+{
+	struct rb_node *n = rb_first(r);
+	return __key_serial_next(n);
+}
+
 static int proc_keys_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &proc_keys_ops);
@@ -104,10 +126,10 @@ static void *proc_keys_start(struct seq_file *p, loff_t *_pos)
 
 	spin_lock(&key_serial_lock);
 
-	_p = rb_first(&key_serial_tree);
+	_p = key_serial_first(&key_serial_tree);
 	while (pos > 0 && _p) {
 		pos--;
-		_p = rb_next(_p);
+		_p = key_serial_next(_p);
 	}
 
 	return _p;
@@ -117,7 +139,7 @@ static void *proc_keys_start(struct seq_file *p, loff_t *_pos)
 static void *proc_keys_next(struct seq_file *p, void *v, loff_t *_pos)
 {
 	(*_pos)++;
-	return rb_next((struct rb_node *) v);
+	return key_serial_next((struct rb_node *) v);
 
 }
 
@@ -203,6 +225,27 @@ static int proc_keys_show(struct seq_file *m, void *v)
 
 #endif /* CONFIG_KEYS_DEBUG_PROC_KEYS */
 
+static struct rb_node *__key_user_next(struct rb_node *n)
+{
+	while (n) {
+		struct key_user *user = rb_entry(n, struct key_user, node);
+		if (user->user_ns == current_user_ns())
+			break;
+		n = rb_next(n);
+	}
+	return n;
+}
+
+static struct rb_node *key_user_next(struct rb_node *n)
+{
+	return __key_user_next(rb_next(n));
+}
+
+static struct rb_node *key_user_first(struct rb_root *r)
+{
+	struct rb_node *n = rb_first(r);
+	return __key_user_next(n);
+}
 /*****************************************************************************/
 /*
  * implement "/proc/key-users" to provides a list of the key users
@@ -220,10 +263,10 @@ static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
 
 	spin_lock(&key_user_lock);
 
-	_p = rb_first(&key_user_tree);
+	_p = key_user_first(&key_user_tree);
 	while (pos > 0 && _p) {
 		pos--;
-		_p = rb_next(_p);
+		_p = key_user_next(_p);
 	}
 
 	return _p;
@@ -233,7 +276,7 @@ static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
 static void *proc_key_users_next(struct seq_file *p, void *v, loff_t *_pos)
 {
 	(*_pos)++;
-	return rb_next((struct rb_node *) v);
+	return key_user_next((struct rb_node *) v);
 
 }
 
-- 
1.5.4.3

