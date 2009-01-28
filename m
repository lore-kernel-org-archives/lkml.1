Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZA1Drf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZA1Drf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZA1DrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:47:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38784 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbZA1DrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:47:11 -0500
From: Bron Gondwana <brong@fastmail.fm>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>
Subject: [PATCH 2/3] epoll: allow 0 for "unlimited" on epoll limits
Date: Wed, 28 Jan 2009 14:47:08 +1100
Message-Id: <13dcb10200fc15315208edf2cff70c5de7fc3954.1233114169.git.brong@fastmail.fm>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
References: <20090128033824.GA1662@brong.net>
 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
In-Reply-To: <20090128033824.GA1662@brong.net>
References: <20090128033824.GA1662@brong.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you set 0 as the limit for max_user_watches or max_user_instances,
then treat them as unlimited.

Note - this doesn't disable the accounting, just the limit test.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
---
 Documentation/filesystems/proc.txt |    4 ++++
 fs/eventpoll.c                     |    8 ++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 4677abf..c4debd3 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2244,6 +2244,8 @@ If you are running a heavily loaded Postfix or Apache server, you may need
 to set this higher.  Both these servers run an epoll instance per child 
 process.
 
+Setting max_user_instances to '0' makes it unlimited.
+
 max_user_watches
 ----------------
 
@@ -2256,6 +2258,8 @@ on a 64bit one.
 The current default value for  max_user_watches  is the 1/32 of the available
 low memory, divided for the "watch" cost in bytes.
 
+Setting max_user_watches to '0' makes it unlimited.
+
 
 ------------------------------------------------------------------------------
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 16eb817..c6d5c1d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -582,8 +582,8 @@ static int ep_alloc(struct eventpoll **pep)
 
 	user = get_current_user();
 	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
+	if (unlikely(max_user_instances &&
+	            (max_user_instances < atomic_read(&user->epoll_devs))))
 		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -761,8 +761,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     max_user_watches))
+	if (unlikely(max_user_watches &&
+                    (max_user_watches < atomic_read(&ep->user->epoll_watches))))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
-- 
1.5.6.3

