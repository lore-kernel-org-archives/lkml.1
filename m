Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXKFMMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXKFMMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXKFMMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:12:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXKFMMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:12:36 -0500
Date: Tue, 6 Nov 2007 07:12:28 -0500
Message-Id: <200711061212.lA6CCS2i012760@dantu.usersys.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] smbfs: fix calculation of kernel_recvmsg size parameter in smb_receive
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smb_receive calls kernel_recvmsg with a size that's the minimum of the
amount of buffer space in the kvec passed in or req->rq_rlen (which
represents the length of the response). This does not take into account
any response data that was read in an earlier pass through smb_receive.

If the first pass through smb_receive receives some but not all of the
response, then the next pass can call kernel_recvmsg with a size field
that's too big. kernel_recvmsg can overrun into the next response,
throwing off the alignment and making it unrecognizable.

This causes messages like this to pop up in the ring buffer:

smb_get_length: Invalid NBT packet, code=69

as well as other errors indicating that the response is unrecognizable.
Typically this is seen on a smbfs mount under heavy I/O.

This patch changes the code to use (req->rq_rlen - req->rq_bytes_recvd)
instead instead of just req->rq_rlen, since that should represent the
amount of unread data in the response.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Guenter Kukkukk <linux@kukkukk.com>
---
 fs/smbfs/sock.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smbfs/sock.c b/fs/smbfs/sock.c
index e48bd82..e37fe4d 100644
--- a/fs/smbfs/sock.c
+++ b/fs/smbfs/sock.c
@@ -329,9 +329,8 @@ smb_receive(struct smb_sb_info *server, struct smb_request *req)
 	msg.msg_control = NULL;
 
 	/* Dont repeat bytes and count available bufferspace */
-	rlen = smb_move_iov(&p, &num, iov, req->rq_bytes_recvd);
-	if (req->rq_rlen < rlen)
-		rlen = req->rq_rlen;
+	rlen = min_t(int, smb_move_iov(&p, &num, iov, req->rq_bytes_recvd),
+			(req->rq_rlen - req->rq_bytes_recvd));
 
 	result = kernel_recvmsg(sock, &msg, p, num, rlen, flags);
 
-- 
1.5.2.1

