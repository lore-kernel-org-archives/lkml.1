Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbZCaRoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbZCaRoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZCaRoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:44:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZCaRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:44:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090331084546.6b24d66e@tleilax.poochiereds.net>
References: <20090331084546.6b24d66e@tleilax.poochiereds.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: consistent oops from request_key in 2.6.29
Date: Tue, 31 Mar 2009 18:44:05 +0100
Message-ID: <14730.1238521445@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about the attached patch?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Handle there being no fallback destination keyring for request_key()

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
