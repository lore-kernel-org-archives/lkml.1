Return-Path: <linux-kernel-owner+w=401wt.eu-S966191AbXDCOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966191AbXDCOCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966193AbXDCOCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:02:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36655 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966187AbXDCOCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:02:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/8] AF_RXRPC: Key facility changes for AF_RXRPC [try #2]
To: torvalds@osdl.org, akpm@osdl.org
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 03 Apr 2007 15:01:24 +0100
Message-ID: <20070403140124.20369.14820.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070403140108.20369.59745.stgit@warthog.cambridge.redhat.com>
References: <20070403140108.20369.59745.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export the keyring key type definition and document its availability.

Add alternative types into the key's type_data union to make it more useful.
Not all users necessarily want to use it as a list_head (AF_RXRPC doesn't, for
example), so make it clear that it can be used in other ways.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt  |   12 ++++++++++++
 include/linux/key.h     |    2 ++
 security/keys/keyring.c |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index 60c665d..81d9aa0 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -859,6 +859,18 @@ payload contents" for more information.
 	void unregister_key_type(struct key_type *type);
 
 
+Under some circumstances, it may be desirable to desirable to deal with a
+bundle of keys.  The facility provides access to the keyring type for managing
+such a bundle:
+
+	struct key_type key_type_keyring;
+
+This can be used with a function such as request_key() to find a specific
+keyring in a process's keyrings.  A keyring thus found can then be searched
+with keyring_search().  Note that it is not possible to use request_key() to
+search a specific keyring, so using keyrings in this way is of limited utility.
+
+
 ===================================
 NOTES ON ACCESSING PAYLOAD CONTENTS
 ===================================
diff --git a/include/linux/key.h b/include/linux/key.h
index 169f05e..a9220e7 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -160,6 +160,8 @@ struct key {
 	 */
 	union {
 		struct list_head	link;
+		unsigned long		x[2];
+		void			*p[2];
 	} type_data;
 
 	/* key data
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ad45ce7..88292e3 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -66,6 +66,8 @@ struct key_type key_type_keyring = {
 	.read		= keyring_read,
 };
 
+EXPORT_SYMBOL(key_type_keyring);
+
 /*
  * semaphore to serialise link/link calls to prevent two link calls in parallel
  * introducing a cycle

