Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZB0A2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZB0A2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbZB0A16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:27:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40645 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbZB0A15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:27:57 -0500
Date: Thu, 26 Feb 2009 18:27:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] keys: skip keys from another user namespace
Message-ID: <20090227002755.GC31098@us.ibm.com>
References: <20090227002709.GA31049@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227002709.GA31049@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When listing keys, do not return keys belonging to the
same uid in another user namespace.  Otherwise uid 500
in another user namespace will return keyrings called
uid.500 for another user namespace.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 security/keys/keyring.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ed85157..3dba81c 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -539,6 +539,9 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 				    &keyring_name_hash[bucket],
 				    type_data.link
 				    ) {
+			if (keyring->user->user_ns != current_user_ns())
+				continue;
+
 			if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
 				continue;
 
-- 
1.5.4.3

