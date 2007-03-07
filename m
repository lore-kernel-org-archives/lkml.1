Return-Path: <linux-kernel-owner+w=401wt.eu-S1422969AbXCGSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422969AbXCGSBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422973AbXCGSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:00:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:42690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757AbXCGRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:31 -0500
Message-Id: <20070307171140.244147573@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>
Subject: [patch 007/101] Keys: Fix key serial number collision handling
Content-Disposition: inline; filename=keys-fix-key-serial-number-collision-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[PATCH] Keys: Fix key serial number collision handling

Fix the key serial number collision avoidance code in key_alloc_serial().

This didn't use to be so much of a problem as the key serial numbers were
allocated from a simple incremental counter, and it would have to go through
two billion keys before it could possibly encounter a collision.  However, now
that random numbers are used instead, collisions are much more likely.

This is fixed by finding a hole in the rbtree where the next unused serial
number ought to be and using that by going almost back to the top of the
insertion routine and redoing the insertion with the new serial number rather
than trying to be clever and attempting to work out the insertion point
pointer directly.

This fixes kernel BZ #7727.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/key.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- linux-2.6.20.1.orig/security/keys/key.c
+++ linux-2.6.20.1/security/keys/key.c
@@ -188,6 +188,7 @@ static inline void key_alloc_serial(stru
 
 	spin_lock(&key_serial_lock);
 
+attempt_insertion:
 	parent = NULL;
 	p = &key_serial_tree.rb_node;
 
@@ -202,39 +203,33 @@ static inline void key_alloc_serial(stru
 		else
 			goto serial_exists;
 	}
-	goto insert_here;
+
+	/* we've found a suitable hole - arrange for this key to occupy it */
+	rb_link_node(&key->serial_node, parent, p);
+	rb_insert_color(&key->serial_node, &key_serial_tree);
+
+	spin_unlock(&key_serial_lock);
+	return;
 
 	/* we found a key with the proposed serial number - walk the tree from
 	 * that point looking for the next unused serial number */
 serial_exists:
 	for (;;) {
 		key->serial++;
-		if (key->serial < 2)
-			key->serial = 2;
-
-		if (!rb_parent(parent))
-			p = &key_serial_tree.rb_node;
-		else if (rb_parent(parent)->rb_left == parent)
-			p = &(rb_parent(parent)->rb_left);
-		else
-			p = &(rb_parent(parent)->rb_right);
+		if (key->serial < 3) {
+			key->serial = 3;
+			goto attempt_insertion;
+		}
 
 		parent = rb_next(parent);
 		if (!parent)
-			break;
+			goto attempt_insertion;
 
 		xkey = rb_entry(parent, struct key, serial_node);
 		if (key->serial < xkey->serial)
-			goto insert_here;
+			goto attempt_insertion;
 	}
 
-	/* we've found a suitable hole - arrange for this key to occupy it */
-insert_here:
-	rb_link_node(&key->serial_node, parent, p);
-	rb_insert_color(&key->serial_node, &key_serial_tree);
-
-	spin_unlock(&key_serial_lock);
-
 } /* end key_alloc_serial() */
 
 /*****************************************************************************/

--
