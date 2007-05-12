Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbXELTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbXELTK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXELTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:10:18 -0400
Received: from squawk.glines.org ([72.36.206.66]:40065 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbXELTKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:10:16 -0400
Date: Sat, 12 May 2007 12:10:09 -0700
From: Mark Glines <mark@glines.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070512121009.18c8b68a@chirp>
In-Reply-To: <4645227F.3030905@zytor.com>
References: <20070511170135.7c38615f@chirp>
	<4645227F.3030905@zytor.com>
Organization: Glines.org
X-Mailer: Claws Mail 2.9.0 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 19:12:15 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:
> > Following the principle of least astonishment, I think it seems
> > better to use high, out-of-the-way port numbers regardless of how
> > much RAM the system has.  So, the following patch changes this
> > behavior slightly. The system still picks a dynamic range depending
> > on the bind hash size, but now, all ranges start with 32768.  I
> > suppose another reasonable way to do this would be to end all
> > ranges with 61000, or something like that.
> > 
> 
> Yes, that would be better.  The IANA recommended port range for
> dynamic ports are 49152-65535; Linux extends this to 32768 and chops
> off some of the really high ports, but keeping them in the high range
> is thus the right thing to do.

Well, in that case, is there anything wrong with just using the
range IANA recommends, in all cases?

Please consider this patch instead of my previous one.

Signed-off-by: Mark Glines <mark@glines.org>

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 43fb160..b04b167 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(inet_csk_timer_bug_msg);
  * For high-usage systems, use sysctl to change this to
  * 32768-61000
  */
-int sysctl_local_port_range[2] = { 1024, 4999 };
+int sysctl_local_port_range[2] = { 49152, 65535 };
 
 int inet_csk_bind_conflict(const struct sock *sk,
 			   const struct inet_bind_bucket *tb)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd4c295..33ef0e7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2465,13 +2465,10 @@ void __init tcp_init(void)
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
