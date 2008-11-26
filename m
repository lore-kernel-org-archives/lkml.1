Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYKZEit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYKZEit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYKZEik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:38:40 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:37953 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751255AbYKZEik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:38:40 -0500
X-YMail-OSG: e5MusUIVM1n8mr.nKLxNgCseRZBza6e0fTsUPmuHuAKQtuwAum.BbL5sVW7eMQ3Jvg2eH.xLmRc_wi3e5NtIerTrPwT1VrLlSmR2e3AxpBJVpX2aty41GdvO4emlCywJgGT5opLA2rnuj3O_CAJ_407V1VAqMNXz43KfGp.r53N.i0JdFdXUZziZ.MA-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target]: Make kernel level struct
	socket->ops->accept() use sock_create_lite()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Net <linux-net@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ming Zhang <blackmagic02881@gmail.com>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>, David Miller <davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 20:38:37 -0800
Message-Id: <1227674317.5023.63.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0450272b62a9944c2efe9d038447e168abba41a0 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 25 Nov 2008 19:51:13 -0800
Subject: [PATCH] [LIO-Target]: Make kernel level struct socket->ops->accept() use sock_create_lite()

With the addition sock_create_lite() in Linux v2.6.6, and at somepoint thereafter, the
'struct socket->sock' pointer of struct sock allocated internally with kmem_cache_alloc()
via net/core/sock.c:sk_prot_alloc() in net/socket.c:sock_create() was
being leaked (silently below the API) with with struct newsock usage with
struct socket->ops->accept().  This meant that normally calling net/socket.c:sock_release()
to the struct socket->ops->accept()'ed struct sock (located at struct socket->sock) was not
releasing struct sock back into struct proto->slab in net/core/sock.c:sk_free().

This patch to LIO-Target follows what net/socket.c:kernel_accept() does and uses
sock_create_lite().  kernel_accept() was added in v2.6.19, so one can assume the silient
leak with sock_create() and struct socket->ops->accept() was introduced sometime between
v2.6.6 and v2.6.19..

In LIO-Target code, iscsi_target_login.c:iscsi_target_login_thread() now uses
sock_create_lite() for struct socket->ops->accept() usage.

Forward port from v2.9-STABLE r406

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_login.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index 0b0a54a..302f527 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -763,9 +763,9 @@ static struct socket *iscsi_target_setup_login_socket (iscsi_np_t *np)
 		goto fail;
 	}
 	
-	if (sock_create((np->np_flags & NPF_NET_IPV6) ? AF_INET6 : AF_INET,
+	if (sock_create_lite((np->np_flags & NPF_NET_IPV6) ? AF_INET6 : AF_INET,
 			sock_type, ip_proto, &sock) < 0) {
-		TRACE_ERROR("sock_create() failed.\n");
+		TRACE_ERROR("sock_create_lite() failed.\n");
 		goto fail;
 	}
 	np->np_socket = sock;
-- 
1.5.4.1



