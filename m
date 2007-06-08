Return-Path: <linux-kernel-owner+w=401wt.eu-S967815AbXFHH1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967815AbXFHH1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938067AbXFHHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:28 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33310 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938019AbXFHHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:27 -0400
Message-Id: <20070608071556.109090000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Mark Glines <mark@glines.org>
Subject: [patch 28/32] TCP: Use default 32768-61000 outgoing port range in all cases.
Content-Disposition: inline; filename=tcp-use-default-32768-61000-outgoing-port-range-in-all-cases.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mark Glines <mark@glines.org>

This diff changes the default port range used for outgoing connections,
from "use 32768-61000 in most cases, but use N-4999 on small boxes
(where N is a multiple of 1024, depending on just *how* small the box
is)" to just "use 32768-61000 in all cases".

I don't believe there are any drawbacks to this change, and it keeps
outgoing connection ports farther away from the mess of
IANA-registered ports.

Signed-off-by: Mark Glines <mark@glines.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/inet_connection_sock.c |    4 +---
 net/ipv4/tcp.c                  |    3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.20.13.orig/net/ipv4/inet_connection_sock.c
+++ linux-2.6.20.13/net/ipv4/inet_connection_sock.c
@@ -31,10 +31,8 @@ EXPORT_SYMBOL(inet_csk_timer_bug_msg);
 
 /*
  * This array holds the first and last local port number.
- * For high-usage systems, use sysctl to change this to
- * 32768-61000
  */
-int sysctl_local_port_range[2] = { 1024, 4999 };
+int sysctl_local_port_range[2] = { 32768, 61000 };
 
 int inet_csk_bind_conflict(const struct sock *sk,
 			   const struct inet_bind_bucket *tb)
--- linux-2.6.20.13.orig/net/ipv4/tcp.c
+++ linux-2.6.20.13/net/ipv4/tcp.c
@@ -2445,13 +2445,10 @@ void __init tcp_init(void)
 			order++)
 		;
 	if (order >= 4) {
-		sysctl_local_port_range[0] = 32768;
-		sysctl_local_port_range[1] = 61000;
 		tcp_death_row.sysctl_max_tw_buckets = 180000;
 		sysctl_tcp_max_orphans = 4096 << (order - 4);
 		sysctl_max_syn_backlog = 1024;
 	} else if (order < 3) {
-		sysctl_local_port_range[0] = 1024 * (3 - order);
 		tcp_death_row.sysctl_max_tw_buckets >>= (3 - order);
 		sysctl_tcp_max_orphans >>= (3 - order);
 		sysctl_max_syn_backlog = 128;

-- 
