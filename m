Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbXJaNBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbXJaNBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbXJaNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:00:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbXJaNAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:00:48 -0400
Date: Wed, 31 Oct 2007 09:00:46 -0400
Message-Id: <200710311300.l9VD0kKI003594@dantu.rdu.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: sfrench@samba.org
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] smbfs: fix calculation of kernel_recvmsg size parameter in smb_receive
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smb_receive calls kernel_recvmsg with a size that's the minimum of the
amount of buffer space in the kvec passed in or req->rq_rlen (which
represents the length of the response). This does not take into account
any data that was read in a request earlier pass through smb_receive.

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

I think this is correct, but an ACK or NACK from someone more familiar
with this code would be appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
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

