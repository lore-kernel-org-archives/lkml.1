Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZAIWxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZAIWxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZAIWw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:52:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53391 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZAIWw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:52:57 -0500
Date: Fri, 9 Jan 2009 16:52:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 3/4] keys: skip keys from another user namespace
Message-ID: <20090109225255.GA15599@us.ibm.com>
References: <20090109225208.GA15252@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109225208.GA15252@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When listing keys, do not return keys belonging to the
same uid in another user namespace.  Otherwise uid 500
in another user namespace will return keyrings called
uid.500 for another user namespace.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
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

