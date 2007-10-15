Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXJOQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXJOQLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764025AbXJOQLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:11:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764062AbXJOQLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:11:23 -0400
Date: Mon, 15 Oct 2007 18:11:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] net/DCCP: fix link error with !CONFIG_SYSCTL
Message-ID: <20071015161113.GA569@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: net/DCCP: fix link error with !CONFIG_SYSCTL
From: Ingo Molnar <mingo@elte.hu>

do not define the sysctl_dccp_sync_ratelimit sysctl variable in
the CONFIG_SYSCTL dependent sysctl.c module - move it to input.c instead.

this fixes the following build bug:

 net/built-in.o: In function `dccp_check_seqno':
 input.c:(.text+0xbd859): undefined reference to `sysctl_dccp_sync_ratelimit'
 distcc[29953] ERROR: compile (null) on localhost failed
 make: *** [vmlinux] Error 1

found via 'make randconfig' build testing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/dccp/input.c  |    3 +++
 net/dccp/sysctl.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/net/dccp/input.c
===================================================================
--- linux.orig/net/dccp/input.c
+++ linux/net/dccp/input.c
@@ -19,6 +19,9 @@
 #include "ccid.h"
 #include "dccp.h"
 
+/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
+int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
+
 static void dccp_fin(struct sock *sk, struct sk_buff *skb)
 {
 	sk->sk_shutdown |= RCV_SHUTDOWN;
Index: linux/net/dccp/sysctl.c
===================================================================
--- linux.orig/net/dccp/sysctl.c
+++ linux/net/dccp/sysctl.c
@@ -18,9 +18,6 @@
 #error This file should not be compiled without CONFIG_SYSCTL defined
 #endif
 
-/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
-int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
-
 static struct ctl_table dccp_default_table[] = {
 	{
 		.procname	= "seq_window",
