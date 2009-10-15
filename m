Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbZJOJPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbZJOJPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbZJOJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZJOJPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:15:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: get_instantiation_keyring() should inc the keyring
	refcount in all cases
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Thu, 15 Oct 2009 10:14:35 +0100
Message-ID: <20091015091435.6123.91246.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The destination keyring specified to request_key() and co. is made available to
the process that instantiates the key (the slave process started by
/sbin/request-key typically).  This is passed in the request_key_auth struct as
the dest_keyring member.

keyctl_instantiate_key and keyctl_negate_key() call get_instantiation_keyring()
to get the keyring to attach the newly constructed key to at the end of
instantiation.  This may be given a specific keyring into which a link will be
made later, or it may be asked to find the keyring passed to request_key().  In
the former case, it returns a keyring with the refcount incremented by
lookup_user_key(); in the latter case, it returns the keyring from the
request_key_auth struct - and does _not_ increment the refcount.

The latter case will eventually result in an oops when the keyring prematurely
runs out of references and gets destroyed.  The effect may take some time to
show up as the key is destroyed lazily.

To fix this, the keyring returned by get_instantiation_keyring() must always
have its refcount incremented, no matter where it comes from.

This can be tested by setting /etc/request-key.conf to:

#OP	TYPE	DESCRIPTION	CALLOUT INFO	PROGRAM ARG1 ARG2 ARG3 ...
#======	=======	===============	===============	===============================
create  *	test:*		*		|/bin/false %u %g %d %{user:_display}
negate	*	*		*		/bin/keyctl negate %k 10 @u

and then doing:

	keyctl add user _display aaaaaaaa @u
        while keyctl request2 user test:x test:x @u &&
        keyctl list @u;
        do
                keyctl request2 user test:x test:x @u;
                sleep 31;
                keyctl list @u;
        done

which will oops eventually.  Changing the negate line to have @u rather than
%S at the end is important as that forces the latter case by passing a special
keyring ID rather than an actual keyring ID.

Reported-by: Alexander Zangerl <az@bond.edu.au>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Alexander Zangerl <az@bond.edu.au>
---

 security/keys/keyctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 2fb28ef..06ec722 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -873,7 +873,7 @@ static long get_instantiation_keyring(key_serial_t ringid,
 	/* otherwise specify the destination keyring recorded in the
 	 * authorisation key (any KEY_SPEC_*_KEYRING) */
 	if (ringid >= KEY_SPEC_REQUESTOR_KEYRING) {
-		*_dest_keyring = rka->dest_keyring;
+		*_dest_keyring = key_get(rka->dest_keyring);
 		return 0;
 	}
 

