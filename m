Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbZHDO5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbZHDO5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZHDO5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbZHDO5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] KEYS: Allow keyctl_revoke() on keys that have SETATTR but
	not WRITE perm
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 04 Aug 2009 15:55:35 +0100
Message-ID: <20090804145535.17676.87650.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow keyctl_revoke() to operate on keys that have SETATTR but not WRITE
permission, rather than only on keys that have WRITE permission.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyctl.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)


diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index b85ace2..1160b64 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -343,7 +343,13 @@ long keyctl_revoke_key(key_serial_t id)
 	key_ref = lookup_user_key(id, 0, KEY_WRITE);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
-		goto error;
+		if (ret != -EACCES)
+			goto error;
+		key_ref = lookup_user_key(id, 0, KEY_SETATTR);
+		if (IS_ERR(key_ref)) {
+			ret = PTR_ERR(key_ref);
+			goto error;
+		}
 	}
 
 	key_revoke(key_ref_to_ptr(key_ref));

