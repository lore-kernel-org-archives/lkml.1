Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbZJIXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbZJIXmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbZJIXmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:12 -0400
Received: from kroah.org ([198.145.64.141]:51437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbZJIXmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:39 2009
Message-Id: <20091009233439.684030931@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Miklos Szeredi <mszeredi@suse.cz>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/37] net: unix: fix sending fds in multiple buffers
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=net-unix-fix-sending-fds-in-multiple-buffers.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

[ Upstream commit 8ba69ba6a324b13e1190fc31e41954d190fd4f1d ]

Kalle Olavi Niemitalo reported that:

  "..., when one process calls sendmsg once to send 43804 bytes of
  data and one file descriptor, and another process then calls recvmsg
  three times to receive the 16032+16032+11740 bytes, each of those
  recvmsg calls returns the file descriptor in the ancillary data.  I
  confirmed this with strace.  The behaviour differs from Linux
  2.6.26, where reportedly only one of those recvmsg calls (I think
  the first one) returned the file descriptor."

This bug was introduced by a patch from me titled "net: unix: fix inflight
counting bug in garbage collector", commit 6209344f5.

And the reason is, quoting Kalle:

  "Before your patch, unix_attach_fds() would set scm->fp = NULL, so
  that if the loop in unix_stream_sendmsg() ran multiple iterations,
  it could not call unix_attach_fds() again.  But now,
  unix_attach_fds() leaves scm->fp unchanged, and I think this causes
  it to be called multiple times and duplicate the same file
  descriptors to each struct sk_buff."

Fix this by introducing a flag that is cleared at the start and set
when the fds attached to the first buffer.  The resulting code should
work equivalently to the one on 2.6.26.

Reported-by: Kalle Olavi Niemitalo <kon@iki.fi>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/unix/af_unix.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1501,6 +1501,7 @@ static int unix_stream_sendmsg(struct ki
 	struct sk_buff *skb;
 	int sent = 0;
 	struct scm_cookie tmp_scm;
+	bool fds_sent = false;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1562,12 +1563,14 @@ static int unix_stream_sendmsg(struct ki
 		size = min_t(int, size, skb_tailroom(skb));
 
 		memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
-		if (siocb->scm->fp) {
+		/* Only send the fds in the first buffer */
+		if (siocb->scm->fp && !fds_sent) {
 			err = unix_attach_fds(siocb->scm, skb);
 			if (err) {
 				kfree_skb(skb);
 				goto out_err;
 			}
+			fds_sent = true;
 		}
 
 		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);


