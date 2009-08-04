Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZHDUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZHDUk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbZHDUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:40:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58459 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbZHDUkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:40:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] KEYS: Allow keyctl_revoke() on keys that have SETATTR but
	not WRITE perm [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>
Date: Tue, 04 Aug 2009 21:39:28 +0100
Message-ID: <20090804203928.25094.94517.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk>
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
Acked-by: Serge Hallyn <serue@us.ibm.com>
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

