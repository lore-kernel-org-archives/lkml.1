Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbZHDO5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbZHDO5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZHDO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZHDO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] KEYS: Flag dead keys to induce EKEYREVOKED
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 04 Aug 2009 15:55:41 +0100
Message-ID: <20090804145541.17676.99745.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
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

