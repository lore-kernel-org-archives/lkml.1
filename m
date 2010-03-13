Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935741Ab0CMAev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:34:51 -0500
Received: from kroah.org ([198.145.64.141]:47078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935371Ab0CMAcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:04 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:13 2010
Message-Id: <20100313002713.699240697@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [097/145] scm: Only support SCM_RIGHTS on unix domain sockets.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Eric W. Biederman <ebiederm@xmission.com>

commit 76dadd76c265a0cdb5a76aa4eef03fcc9639b388 upstream.

We use scm_send and scm_recv on both unix domain and
netlink sockets, but only unix domain sockets support
everything required for file descriptor passing,
so error if someone attempts to pass file descriptors
over netlink sockets.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/scm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -156,6 +156,8 @@ int __scm_send(struct socket *sock, stru
 		switch (cmsg->cmsg_type)
 		{
 		case SCM_RIGHTS:
+			if (!sock->ops || sock->ops->family != PF_UNIX)
+				goto error;
 			err=scm_fp_copy(cmsg, &p->fp);
 			if (err<0)
 				goto error;


