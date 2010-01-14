Return-Path: <linux-kernel-owner+w=401wt.eu-S932314Ab0ANWi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0ANWi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530Ab0ANWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:38:23 -0500
Received: from kroah.org ([198.145.64.141]:60531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0ANW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Jeff Layton <jlayton@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/52] sunrpc: on successful gss error pipe write, don't return error
Date: Thu, 14 Jan 2010 14:26:50 -0800
Message-Id: <1263508051-7868-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-10-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

commit 486bad2e40e938cd68fd853b7a9fa3115a9d3a4a upstream.

When handling the gssd downcall, the kernel should distinguish between a
successful downcall that contains an error code and a failed downcall
(i.e. where the parsing failed or some other sort of problem occurred).

In the former case, gss_pipe_downcall should be returning the number of
bytes written to the pipe instead of an error. In the event of other
errors, we generally want the initiating task to retry the upcall so
we set msg.errno to -EAGAIN. An unexpected error code here is a bug
however, so BUG() in that case.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/auth_gss/auth_gss.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 129d75e..9c5a19d 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -644,7 +644,22 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	p = gss_fill_context(p, end, ctx, gss_msg->auth->mech);
 	if (IS_ERR(p)) {
 		err = PTR_ERR(p);
-		gss_msg->msg.errno = (err == -EAGAIN) ? -EAGAIN : -EACCES;
+		switch (err) {
+		case -EACCES:
+			gss_msg->msg.errno = err;
+			err = mlen;
+			break;
+		case -EFAULT:
+		case -ENOMEM:
+		case -EINVAL:
+		case -ENOSYS:
+			gss_msg->msg.errno = -EAGAIN;
+			break;
+		default:
+			printk(KERN_CRIT "%s: bad return from "
+				"gss_fill_context: %ld\n", __func__, err);
+			BUG();
+		}
 		goto err_release_msg;
 	}
 	gss_msg->ctx = gss_get_ctx(ctx);
-- 
1.6.6

