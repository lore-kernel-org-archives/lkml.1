Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZAIWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZAIWwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZAIWwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:52:39 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47095 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZAIWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:52:38 -0500
Date: Fri, 9 Jan 2009 16:52:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 2/4] keys: consider user namespace in key_permission
Message-ID: <20090109225236.GA15579@us.ibm.com>
References: <20090109225208.GA15252@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109225208.GA15252@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a key is owned by another user namespace, then treat the
key as though it is owned by both another uid and gid.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/keys/permission.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/security/keys/permission.c b/security/keys/permission.c
index 5d9fc7b..0ed802c 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -35,6 +35,9 @@ int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 
 	key = key_ref_to_ptr(key_ref);
 
+	if (key->user->user_ns != cred->user->user_ns)
+		goto use_other_perms;
+
 	/* use the second 8-bits of permissions for keys the caller owns */
 	if (key->uid == cred->fsuid) {
 		kperm = key->perm >> 16;
@@ -56,6 +59,8 @@ int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 		}
 	}
 
+use_other_perms:
+
 	/* otherwise use the least-significant 8-bits */
 	kperm = key->perm;
 
-- 
1.5.4.3

