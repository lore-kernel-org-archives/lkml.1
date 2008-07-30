Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYGaAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYGaAEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYGaAEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:04:08 -0400
Received: from mail.suse.de ([195.135.220.2]:37674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYGaAEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:04:05 -0400
Date: Wed, 30 Jul 2008 16:57:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/62] ipv6: use timer pending
Message-ID: <20080730235745.GC12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-use-timer-pending.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit 847499ce71bdcc8fc542062df6ebed3e596608dd ]

This fixes the bridge reference count problem and cleanups ipv6 FIB
timer management.  Don't use expires field, because it is not a proper
way to test, instead use timer_pending().

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_fib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -663,7 +663,7 @@ static int fib6_add_rt2node(struct fib6_
 
 static __inline__ void fib6_start_gc(struct net *net, struct rt6_info *rt)
 {
-	if (net->ipv6.ip6_fib_timer->expires == 0 &&
+	if (!timer_pending(net->ipv6.ip6_fib_timer) &&
 	    (rt->rt6i_flags & (RTF_EXPIRES|RTF_CACHE)))
 		mod_timer(net->ipv6.ip6_fib_timer, jiffies +
 			  net->ipv6.sysctl.ip6_rt_gc_interval);
@@ -671,7 +671,7 @@ static __inline__ void fib6_start_gc(str
 
 void fib6_force_start_gc(struct net *net)
 {
-	if (net->ipv6.ip6_fib_timer->expires == 0)
+	if (!timer_pending(net->ipv6.ip6_fib_timer))
 		mod_timer(net->ipv6.ip6_fib_timer, jiffies +
 			  net->ipv6.sysctl.ip6_rt_gc_interval);
 }

-- 
