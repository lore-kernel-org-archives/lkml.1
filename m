Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYL2Amo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYL2Amo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYL2Amf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:42:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYL2Ame (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:42:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0812281232350.3057@localhost.localdomain>
References: <alpine.LFD.2.00.0812281232350.3057@localhost.localdomain> <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security changes for 2.6.29
Date: Mon, 29 Dec 2008 00:41:51 +0000
Message-ID: <7921.1230511311@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Yes, it's possible that this is just a bogus warning, with gcc-4.3.2 for
> x86-64, but please fix it.

Does this fix the warning?  My compiler doesn't show it; of course, I'm not
using gcc-4.3.2, but something older.

David
---
KEYS: Fix variable uninitialisation warnings

From: David Howells <dhowells@redhat.com>

Fix variable uninitialisation warnings introduced in:

	commit 8bbf4976b59fc9fc2861e79cab7beb3f6d647640
	Author: David Howells <dhowells@redhat.com>
	Date:   Fri Nov 14 10:39:14 2008 +1100

	KEYS: Alter use of key instantiation link-to-keyring argument

As:

  security/keys/keyctl.c: In function 'keyctl_negate_key':
  security/keys/keyctl.c:976: warning: 'dest_keyring' may be used uninitialized in this function
  security/keys/keyctl.c: In function 'keyctl_instantiate_key':
  security/keys/keyctl.c:898: warning: 'dest_keyring' may be used uninitialized in this function

Some versions of gcc notice that get_instantiation_key() doesn't always set
*_dest_keyring, but fail to observe that if this happens then *_dest_keyring
will not be read by the caller.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 7c72baa..6688765 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -838,11 +838,11 @@ static long get_instantiation_keyring(key_serial_t ringid,
 {
 	key_ref_t dkref;
 
+	*_dest_keyring = NULL;
+
 	/* just return a NULL pointer if we weren't asked to make a link */
-	if (ringid == 0) {
-		*_dest_keyring = NULL;
+	if (ringid == 0)
 		return 0;
-	}
 
 	/* if a specific keyring is nominated by ID, then use that */
 	if (ringid > 0) {
