Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbYH0OLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbYH0OLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbYH0OCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:02:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304AbYH0OCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:02:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 50/59] CRED: Wrap task credential accesses in the AX25 protocol
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-hams@vger.kernel.org
Date: Wed, 27 Aug 2008 14:50:00 +0100
Message-ID: <20080827135000.19980.11411.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-hams@vger.kernel.org
---

 net/ax25/af_ax25.c    |    2 +-
 net/ax25/ax25_route.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 01c83e2..f3e5217 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1042,7 +1042,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr->fsa_ax25.sax25_family != AF_AX25)
 		return -EINVAL;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		call = user->call;
 		ax25_uid_put(user);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 8672cd8..c833ba4 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -421,7 +421,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 		goto put;
 	}
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		ax25->source_addr = user->call;
 		ax25_uid_put(user);

