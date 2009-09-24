Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZIXWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZIXWiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZIXWiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:38:13 -0400
Received: from sajino.sajinet.com.pe ([76.74.239.193]:59905 "EHLO
	sajino.sajinet.com.pe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZIXWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:38:13 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 18:38:13 EDT
From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] EPOLL_CTL_SET operatin for epoll_ctl when using EPOLLONESHOT
Date: Thu, 24 Sep 2009 15:32:19 -0700
Message-Id: <1253831539-4506-1-git-send-email-carenas@sajinet.com.pe>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify userspace by eliminating the need to track whether a specific
filehandle was added to epoll already and only needs to be re-arm
after being internally disabled by EPOLLONESHOT.

EPOLL_CLT_SET can be used to add or modify a filehandle in epoll
using the kernel's internal tracking to apply the right equivalent
operation to EPOLL_CTL_ADD or EPOLL_CTL_MOD.

Signed-off-by: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
---
 fs/eventpoll.c            |    9 ++++++++-
 include/linux/eventpoll.h |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 085c5c0..afa6972 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -799,7 +799,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * If the event mask does not contain any poll(2) event, we consider the
 	 * descriptor to be disabled. This condition is likely the effect of the
 	 * EPOLLONESHOT bit that disables the descriptor when an event is received,
-	 * until the next EPOLL_CTL_MOD will be issued.
+	 * until the next EPOLL_CTL_MOD or EPOLL_CTL_SET will be issued.
 	 */
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
@@ -1302,6 +1302,13 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		} else
 			error = -ENOENT;
 		break;
+	case EPOLL_CTL_SET:
+		epds.events |= POLLERR | POLLHUP;
+		if (epi)
+			error = ep_modify(ep, epi, &epds);
+		else
+			error = ep_insert(ep, &epds, tfile, fd);
+		break;
 	}
 	mutex_unlock(&ep->mtx);
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f6856a5..59758c0 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -25,6 +25,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_SET 4
 
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
-- 
1.6.3.3

