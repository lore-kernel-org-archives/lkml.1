Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbZHDO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbZHDO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbZHDO5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbZHDO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] KEYS: Make /proc/keys use keyid not numread as file
	position
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 04 Aug 2009 15:55:51 +0100
Message-ID: <20090804145551.17676.95701.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Make the file position maintained by /proc/keys represent the ID of the key
just read rather than the number of keys read.  This should make it faster to
perform a lookup as we don't have to scan the key ID tree from the beginning to
find the current position.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/proc.c |   62 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 41 insertions(+), 21 deletions(-)


diff --git a/security/keys/proc.c b/security/keys/proc.c
index 769f9bd..643ecf0 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -91,8 +91,9 @@ __initcall(key_proc_init);
  */
 #ifdef CONFIG_KEYS_DEBUG_PROC_KEYS
 
-static struct rb_node *__key_serial_next(struct rb_node *n)
+static struct rb_node *key_serial_next(struct rb_node *n)
 {
+	n = rb_next(n);
 	while (n) {
 		struct key *key = rb_entry(n, struct key, serial_node);
 		if (key->user->user_ns == current_user_ns())
@@ -102,45 +103,64 @@ static struct rb_node *__key_serial_next(struct rb_node *n)
 	return n;
 }
 
-static struct rb_node *key_serial_next(struct rb_node *n)
+static int proc_keys_open(struct inode *inode, struct file *file)
 {
-	return __key_serial_next(rb_next(n));
+	return seq_open(file, &proc_keys_ops);
 }
 
-static struct rb_node *key_serial_first(struct rb_root *r)
+static struct key *find_ge_key(key_serial_t id)
 {
-	struct rb_node *n = rb_first(r);
-	return __key_serial_next(n);
-}
+	struct rb_node *n = key_serial_tree.rb_node;
+	struct key *minkey = NULL;
 
-static int proc_keys_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &proc_keys_ops);
+	while (n) {
+		struct key *key = rb_entry(n, struct key, serial_node);
+		if (id < key->serial) {
+			if (!minkey || minkey->serial > key->serial)
+				minkey = key;
+			n = n->rb_left;
+		} else if (id > key->serial) {
+			n = n->rb_right;
+		} else {
+			minkey = key;
+			break;
+		}
+		key = NULL;
+	}
 
+	return minkey;
 }
 
 static void *proc_keys_start(struct seq_file *p, loff_t *_pos)
 {
-	struct rb_node *_p;
-	loff_t pos = *_pos;
+	key_serial_t pos = *_pos;
+	struct key *key;
 
 	spin_lock(&key_serial_lock);
 
-	_p = key_serial_first(&key_serial_tree);
-	while (pos > 0 && _p) {
-		pos--;
-		_p = key_serial_next(_p);
-	}
-
-	return _p;
+	if (*_pos > INT_MAX)
+		return NULL;
+	key = find_ge_key(pos);
+	if (!key)
+		return NULL;
+	*_pos = key->serial;
+	return &key->serial_node;
+}
 
+static inline key_serial_t key_node_serial(struct rb_node *n)
+{
+	struct key *key = rb_entry(n, struct key, serial_node);
+	return key->serial;
 }
 
 static void *proc_keys_next(struct seq_file *p, void *v, loff_t *_pos)
 {
-	(*_pos)++;
-	return key_serial_next((struct rb_node *) v);
+	struct rb_node *n;
 
+	n = key_serial_next(v);
+	if (n)
+		*_pos = key_node_serial(n);
+	return n;
 }
 
 static void proc_keys_stop(struct seq_file *p, void *v)

