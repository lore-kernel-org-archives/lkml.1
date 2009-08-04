Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZHDUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZHDUke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932682AbZHDUkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:40:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbZHDUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:40:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] KEYS: Flag dead keys to induce EKEYREVOKED [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>
Date: Tue, 04 Aug 2009 21:39:33 +0100
Message-ID: <20090804203933.25094.35311.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the KEY_FLAG_DEAD flag on keys for which the type has been removed.  This
causes the key_permission() function to return EKEYREVOKED in response to
various commands.  It does not, however, prevent unlinking or clearing of
keyrings from detaching the key.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 security/keys/key.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/security/keys/key.c b/security/keys/key.c
index 3762d5b..bd9d267 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -956,8 +956,10 @@ void unregister_key_type(struct key_type *ktype)
 	for (_n = rb_first(&key_serial_tree); _n; _n = rb_next(_n)) {
 		key = rb_entry(_n, struct key, serial_node);
 
-		if (key->type == ktype)
+		if (key->type == ktype) {
 			key->type = &key_type_dead;
+			set_bit(KEY_FLAG_DEAD, &key->flags);
+		}
 	}
 
 	spin_unlock(&key_serial_lock);

