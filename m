Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbZD3MLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbZD3MLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZD3MLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:11:23 -0400
Received: from bender.cm4all.net ([87.106.27.49]:55449 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZD3MLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:11:21 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 08:11:21 EDT
From: Max Kellermann <mk@cm4all.com>
Subject: [splice PATCH 2/3] tee: don't return 0 when another task drains/fills
	a pipe
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, w@1wt.eu
Date: Thu, 30 Apr 2009 14:03:47 +0200
Message-ID: <20090430120347.5689.58150.stgit@rabbit.intern.cm-ag>
In-Reply-To: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
References: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cite from the tee() manual page:

 "A return value of 0 means that there was no data to transfer, and it
 would not make sense to block, because there are no writers connected
 to the write end of the pipe"

There is however a race condition in the tee() implementation, which
violates this definition:

- do_tee() ensures that ipipe is readable and opipe is writable by
  calling link_ipipe_prep() and link_opipe_prep()
- these two functions unlock the pipe after they have waited
- during this unlocked phase, there is a short window where other
  tasks may drain the input pipe or fill the output pipe
- do_tee() now calls link_pipe(), which re-locks both pipes
- link_pipe() sees that it is unable to read ("i >= ipipe->nrbufs ||
  opipe->nrbufs >= PIPE_BUFFERS") and breaks from the loop
- link_pipe() returns 0

Although there may be writers connected to the input pipe, tee() now
returns 0, and the caller (spuriously) assumes this is the end of the
stream.

This patch wraps the link_[io]pipe_prep() invocation in a loop within
link_pipe(), and loops until the result is reliable.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---

 fs/splice.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index f07e304..96135eb 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1594,15 +1594,41 @@ static long link_pipe(struct pipe_inode_info *ipipe,
 		      size_t len, unsigned int flags)
 {
 	struct pipe_buffer *ibuf, *obuf;
-	long ret = 0;
+	long ret;
 	int i = 0, nbuf;
 
-	/*
-	 * Potential ABBA deadlock, work around it by ordering lock
-	 * grabbing by pipe info address. Otherwise two different processes
-	 * could deadlock (one doing tee from A -> B, the other from B -> A).
-	 */
-	pipe_double_lock(ipipe, opipe);
+	while (1) {
+		/* wait for ipipe to become ready to read */
+		ret = link_ipipe_prep(ipipe, flags);
+		if (ret)
+			return ret;
+
+		/* wait for opipe to become ready to write */
+		ret = link_opipe_prep(opipe, flags);
+		if (ret)
+			return ret;
+
+		/*
+		 * Potential ABBA deadlock, work around it by ordering
+		 * lock grabbing by inode address. Otherwise two
+		 * different processes could deadlock (one doing tee
+		 * from A -> B, the other from B -> A).
+		 */
+		pipe_double_lock(ipipe, opipe);
+
+		/* see if the tee() is still possible */
+		if ((ipipe->nrbufs > 0 || ipipe->writers == 0) &&
+		    opipe->nrbufs < PIPE_BUFFERS)
+			/* yes, it is - keep the locks and end this
+			   loop */
+			break;
+
+		/* no - someone has drained ipipe or has filled opipe
+		   between link_[io]pipe_pre()'s lock and our lock.
+		   Drop both locks and wait again. */
+		pipe_unlock(ipipe);
+		pipe_unlock(opipe);
+	}
 
 	do {
 		if (!opipe->readers) {
@@ -1691,12 +1717,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 		 * Keep going, unless we encounter an error. The ipipe/opipe
 		 * ordering doesn't really matter.
 		 */
-		ret = link_ipipe_prep(ipipe, flags);
-		if (!ret) {
-			ret = link_opipe_prep(opipe, flags);
-			if (!ret)
-				ret = link_pipe(ipipe, opipe, len, flags);
-		}
+		ret = link_pipe(ipipe, opipe, len, flags);
 	}
 
 	return ret;

