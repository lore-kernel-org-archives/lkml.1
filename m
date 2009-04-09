Return-Path: <linux-kernel-owner+w=401wt.eu-S1765042AbZDIQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765042AbZDIQP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZDIQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:15:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43257 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZDIQPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:15:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Subject: [PATCH] KEYS: Handle there being no fallback
	destination keyring for request_key()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, jlayton@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 09 Apr 2009 17:14:05 +0100
Message-ID: <20090409161405.5329.86573.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When request_key() is called, without there being any standard process
keyrings on which to fall back if a destination keyring is not specified, an
oops is liable to occur when construct_alloc_key() calls down_write() on
dest_keyring's semaphore.

Due to function inlining this may be seen as an oops in down_write() as called
from request_key_and_link().

This situation crops up during boot, where request_key() is called from within
the kernel (such as in CIFS mounts) where nobody is actually logged in, and so
PAM has not had a chance to create a session keyring and user keyrings to act
as the fallback.

To fix this, make construct_alloc_key() not attempt to cache a key if there is
no fallback key if no destination keyring is given specifically.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Jeff Layton <jlayton@redhat.com>
---

 security/keys/request_key.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 22a3158..03fe63e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -311,7 +311,8 @@ static int construct_alloc_key(struct key_type *type,
 
 	set_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags);
 
-	down_write(&dest_keyring->sem);
+	if (dest_keyring)
+		down_write(&dest_keyring->sem);
 
 	/* attach the key to the destination keyring under lock, but we do need
 	 * to do another check just in case someone beat us to it whilst we
@@ -322,10 +323,12 @@ static int construct_alloc_key(struct key_type *type,
 	if (!IS_ERR(key_ref))
 		goto key_already_present;
 
-	__key_link(dest_keyring, key);
+	if (dest_keyring)
+		__key_link(dest_keyring, key);
 
 	mutex_unlock(&key_construction_mutex);
-	up_write(&dest_keyring->sem);
+	if (dest_keyring)
+		up_write(&dest_keyring->sem);
 	mutex_unlock(&user->cons_lock);
 	*_key = key;
 	kleave(" = 0 [%d]", key_serial(key));

