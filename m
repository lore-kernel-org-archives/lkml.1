Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYH0Nqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYH0Nqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYH0Nqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:46:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745AbYH0Nqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:46:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/59] CRED: Wrap task credential accesses in the block
	loopback driver
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Jens Axboe <axboe@kernel.dk>
Date: Wed, 27 Aug 2008 14:46:18 +0100
Message-ID: <20080827134618.19980.84590.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
---

 drivers/block/loop.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d3a25b0..e96bc38 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -936,8 +936,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
 	int err;
 	struct loop_func_table *xfer;
+	uid_t uid = current_uid();
 
-	if (lo->lo_encrypt_key_size && lo->lo_key_owner != current->uid &&
+	if (lo->lo_encrypt_key_size &&
+	    lo->lo_key_owner != uid &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
@@ -992,7 +994,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_key_size) {
 		memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
 		       info->lo_encrypt_key_size);
-		lo->lo_key_owner = current->uid;
+		lo->lo_key_owner = uid;
 	}	
 
 	return 0;

