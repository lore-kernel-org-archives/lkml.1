Return-Path: <linux-kernel-owner+w=401wt.eu-S1765917AbYD3UjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765917AbYD3UjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761888AbYD3Ui5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:38:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672AbYD3Uiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:38:55 -0400
Date: Wed, 30 Apr 2008 22:38:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] net: ipv6 build fix
Message-ID: <20080430203839.GA19203@elte.hu>
References: <20080430.013138.157977693.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.013138.157977693.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi David,

* David Miller <davem@davemloft.net> wrote:

>       net: Several cleanups for the setsockopt compat support.
>       net: Add compat support for getsockopt (MCAST_MSFILTER)

this broke !COMPAT builds in current -git. Fix below. NOTE: fix is just 
a quick guess.

	Ingo

----------------------->
Subject: net: ipv6 build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 22:32:09 CEST 2008

x86.git testing found the following build error on -git:

  ERROR: "compat_mc_getsockopt" [net/ipv6/ipv6.ko] undefined!

with this config:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_22_23_37_CEST_2008.bad

this hits on !COMPAT + IPV6 modular builds. It is caused by commit
42908c69f6 ("net: Add compat support for getsockopt (MCAST_MSFILTER)").

this fix here is just a quick guess - i _suspect_ that
do_ipv6_getsockopt() will just DTRT and return -EINVAL but i
havent checked. It obviously solves the build issue.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/ipv6/ipv6_sockglue.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/net/ipv6/ipv6_sockglue.c
===================================================================
--- linux.orig/net/ipv6/ipv6_sockglue.c
+++ linux/net/ipv6/ipv6_sockglue.c
@@ -1089,9 +1089,11 @@ int ipv6_getsockopt(struct sock *sk, int
 	if(level != SOL_IPV6)
 		return -ENOPROTOOPT;
 
+#ifdef CONFIG_COMPAT
 	if (optname == MCAST_MSFILTER)
 		return compat_mc_getsockopt(sk, level, optname, optval, optlen,
 			ipv6_getsockopt);
+#endif
 
 	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen);
 #ifdef CONFIG_NETFILTER
