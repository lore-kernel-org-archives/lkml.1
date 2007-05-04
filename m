Return-Path: <linux-kernel-owner+w=401wt.eu-S1767840AbXEDKqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767840AbXEDKqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767834AbXEDKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:45:18 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:46698 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993235AbXEDKfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:35:51 -0400
Message-Id: <20070504103204.149997643@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:27:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Mike Christie <mchristi@redhat.com>
Subject: [PATCH 37/40] iscsi: ensure the iscsi kernel fd is not usable in userspace
Content-Disposition: inline; filename=iscsi_ep_connect_SOCK_KERNEL.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We expose the iSCSI connection fd to userspace for reference tracking, but we
do not want userspace to actually have access to the data; mark it with
SOCK_KERNEL.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-git/drivers/scsi/iscsi_tcp.c
===================================================================
--- linux-2.6-git.orig/drivers/scsi/iscsi_tcp.c	2007-03-22 11:29:08.000000000 +0100
+++ linux-2.6-git/drivers/scsi/iscsi_tcp.c	2007-03-22 12:00:14.000000000 +0100
@@ -1759,6 +1759,13 @@ iscsi_tcp_ep_connect(struct sockaddr *ds
 		goto release_sock;
 	}
 
+	/*
+	 * Even though we're going to expose this socket to user-space
+	 * (as an identifier for the connection and for tracking life times)
+	 * we don't want it used by user-space at all.
+	 */
+	sock_set_flag(sock->sk, SOCK_KERNEL);
+
 	rc = sock->ops->connect(sock, (struct sockaddr *)dst_addr, size,
 				O_NONBLOCK);
 	if (rc == -EINPROGRESS)

--

