Return-Path: <linux-kernel-owner+w=401wt.eu-S1946614AbXBIQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946614AbXBIQ3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946615AbXBIQ3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:29:45 -0500
Received: from favoritemo.com ([65.99.212.195]:47550 "EHLO favoritemo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946614AbXBIQ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:29:44 -0500
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 11:29:44 EST
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <228AC27E-839B-4FB6-922E-3844BCFDF9D9@favoritemo.com>
Content-Transfer-Encoding: 7bit
From: Matt Mitchell <matt@favoritemo.com>
Subject: [PATCH] security/keys: correct handling of key->serial collisions
Date: Fri, 9 Feb 2007 09:55:38 -0600
To: Matt Mitchell <mmitchell@virtualproperties.com>
X-Mailer: Apple Mail (2.749.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The randomized key->serial choice algorithm introduced in 2.6.18  
exposed some bugs in the handling of collisions in the rbtree of  
allocated key->serials.  Collisions then resulted in eventual kernel  
oopses (due to rbtree corruption) once cleanup was attempted.  This  
patch corrects the collision handling to behave correctly.   
Additionally, the (admittedly unlikely) scenario in which there are  
no more key->serials available results in a return of -ENOMEM rather  
than an oops.

Signed-off-by: Matt Mitchell <matt@favoritemo.com>
---
The collision resolution procedure works like the old one was  
intended to -- if you get a collision on your random serial  
selection, try the next serial (wrapping at 2^31) until you either  
(a) find a hole or (b) wrap completely around the keyspace.  Since  
the keyspace is 2^31, collisions are fairly rare -- however, with  
certain workloads, they happen with some frequency.  Samba in  
particular is a common culprit among those of us that ran across this  
bug due to its need to masquerade as many users (and therefore create  
lots of session keyrings and the like).

This patch could/should be applied to 2.6.18 and 2.6.19 as well.

diff --git a/security/keys/key.c b/security/keys/key.c
index 700400d..bdc7837 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -178,17 +178,21 @@ static inline void key_alloc_serial(struct key  
*key)
	struct rb_node *parent, **p;
	struct key *xkey;
+	key_serial_t orig;
+	int keyspace_loop;
+
	/* propose a random serial number and look for a hole for it in the
	 * serial number tree */
	do {
		get_random_bytes(&key->serial, sizeof(key->serial));
		key->serial >>= 1; /* negative numbers are not permitted */
+		orig = key->serial;
+		keyspace_loop = 0;
	} while (key->serial < 3);
	spin_lock(&key_serial_lock);
-attempt_insertion:
	parent = NULL;
	p = &key_serial_tree.rb_node;
@@ -200,8 +204,26 @@ attempt_insertion:
			p = &(*p)->rb_left;
		else if (key->serial > xkey->serial)
			p = &(*p)->rb_right;
-		else
-			goto serial_exists;
+		else {	
+			/* if we have already looped, check for exhausted
+			 * keyspace */
+			if ((keyspace_loop == 1) && (key->serial >= orig)) {
+				/* this is just a dummy */
+				key->serial = -1;
+				spin_unlock(&key_serial_lock);
+				printk(KERN_WARNING "key_alloc_serial: "
+						"keyspace exhausted\n");
+				return;
+			}
+
+			key->serial++;
+			if (key->serial < 2) {
+				keyspace_loop = 1;
+				key->serial = 2;
+			}
+			parent = NULL;
+			p = &key_serial_tree.rb_node;
+		}
	}
	/* we've found a suitable hole - arrange for this key to occupy it */
@@ -209,26 +231,6 @@ attempt_insertion:
	rb_insert_color(&key->serial_node, &key_serial_tree);
	spin_unlock(&key_serial_lock);
-	return;
-
-	/* we found a key with the proposed serial number - walk the tree from
-	 * that point looking for the next unused serial number */
-serial_exists:
-	for (;;) {
-		key->serial++;
-		if (key->serial < 3) {
-			key->serial = 3;
-			goto attempt_insertion;
-		}
-
-		parent = rb_next(parent);
-		if (!parent)
-			goto attempt_insertion;
-
-		xkey = rb_entry(parent, struct key, serial_node);
-		if (key->serial < xkey->serial)
-			goto attempt_insertion;
-	}
} /* end key_alloc_serial() */
@@ -319,9 +321,14 @@ struct key *key_alloc(struct key_type *type,  
const char *desc,
		goto security_error;
	/* publish the key by giving it a serial number */
-	atomic_inc(&user->nkeys);
	key_alloc_serial(key);
+	/* check for success */
+	if (key->serial == -1)
+		goto no_memory_3;
+	else
+		atomic_inc(&user->nkeys);
+
error:
	return key;


