Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZINLrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZINLrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZINLrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:47:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZINLrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:47:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Unlock tasklist when exiting early from
	keyctl_session_to_parent
To: torvalds@osdl.org, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marc Dionne <marc.c.dionne@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Mon, 14 Sep 2009 12:46:23 +0100
Message-ID: <20090914114623.11688.74885.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Dionne <marc.c.dionne@gmail.com>

When we exit early from keyctl_session_to_parent because of permissions or
because the session keyring is the same as the parent, we need to unlock the
tasklist.

The missing unlock causes the system to hang completely when using
keyctl(KEYCTL_SESSION_TO_PARENT) with a keyring shared with the parent.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 74c9685..60983f3 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1319,6 +1319,7 @@ long keyctl_session_to_parent(void)
 already_same:
 	ret = 0;
 not_permitted:
+	write_unlock_irq(&tasklist_lock);
 	put_cred(cred);
 	return ret;
 

