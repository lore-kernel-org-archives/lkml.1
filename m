Return-Path: <linux-kernel-owner+w=401wt.eu-S941000AbXGSSHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941000AbXGSSHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762299AbXGSSHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:07:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbXGSSHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:07:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Use patched rxrpc_kernel_send_data() correctly
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 19 Jul 2007 19:06:31 +0100
Message-ID: <20070719180631.8684.65977.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix afs_send_simple_reply() to accept a greater-than-zero return value from
rxrpc_kernel_send_data() as being a successful return rather than thinking it
an error and aborting the call.

rxrpc_kernel_send_data() previously returned zero incorrectly when it worked
successfully, but has been patched to return the number of bytes it
transmitted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/rxrpc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 1b36f45..3acd08d 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -792,6 +792,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 {
 	struct msghdr msg;
 	struct iovec iov[1];
+	int n;
 
 	_enter("");
 
@@ -806,8 +807,9 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	msg.msg_flags		= 0;
 
 	call->state = AFS_CALL_AWAIT_ACK;
-	switch (rxrpc_kernel_send_data(call->rxcall, &msg, len)) {
-	case 0:
+	n = rxrpc_kernel_send_data(call->rxcall, &msg, len);
+	switch (n) {
+	case 0 ... INT_MAX:
 		_leave(" [replied]");
 		return;
 

