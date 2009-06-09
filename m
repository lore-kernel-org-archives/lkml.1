Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbZFIKbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbZFIKbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbZFIKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:56 -0400
Received: from kroah.org ([198.145.64.141]:55259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbZFIKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:55 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:06 2009
Message-Id: <20090609094106.155875950@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 60/87] keys: Handle there being no fallback destination keyring for request_key()
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=keys-handle-there-being-no-fallback-destination-keyring-for-request_key.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 34574dd10b6d0697b86703388d6d6af9cbf4bb48 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/request_key.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -311,7 +311,8 @@ static int construct_alloc_key(struct ke
 
 	set_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags);
 
-	down_write(&dest_keyring->sem);
+	if (dest_keyring)
+		down_write(&dest_keyring->sem);
 
 	/* attach the key to the destination keyring under lock, but we do need
 	 * to do another check just in case someone beat us to it whilst we
@@ -322,10 +323,12 @@ static int construct_alloc_key(struct ke
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


