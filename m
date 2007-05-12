Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbXELTbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbXELTbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbXELTa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:30:56 -0400
Received: from squawk.glines.org ([72.36.206.66]:54929 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbXELTaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:30:55 -0400
Date: Sat, 12 May 2007 12:30:52 -0700
From: Mark Glines <mark@glines.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070512123052.4a628fa1@chirp>
In-Reply-To: <464611A6.3040301@zytor.com>
References: <20070511170135.7c38615f@chirp>
	<4645227F.3030905@zytor.com>
	<20070512121009.18c8b68a@chirp>
	<464611A6.3040301@zytor.com>
Organization: Glines.org
X-Mailer: Claws Mail 2.9.0 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 12:12:38 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Mark Glines wrote:
> > 
> > Well, in that case, is there anything wrong with just using the
> > range IANA recommends, in all cases?
> > 
> 
> I think the IANA range is considered too small in most cases; I
> suspect there is also a feeling that "there be dragons" near the very
> top.

Ok, thanks for the explanation.  Sounds like we're using high port
numbers in the "spirit" of the IANA recommendation, without using
their actual numbers.

I still haven't gotten an answer to this: is there a performance
issue (or memory usage or security or something) with using the same
port range in all cases, even on memory-constrained systems?  And if
there is, can't we *still* use big numbers, even if the range isn't
as wide?

If there's no reason not to (security, resource consumption,
whatever), I think it would be an improvement to use high, out of the
way port numbering in all cases.  (Especially since the kernel already
does this on most of my machines, anyway.)

There was a comment in there about how 32768-61000 should be used on
high-use systems; is there a drawback to just using this range
*everywhere*?  (It's already the default in non-memory-constrained
cases, because of what tcp_init() was doing.)

Thanks,

Signed-off-by: Mark Glines <mark@glines.org>

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 43fb160..12d9ddc 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -29,12 +29,7 @@ const char inet_csk_timer_bug_msg[] = "inet_csk BUG: unknown timer value\n";
 EXPORT_SYMBOL(inet_csk_timer_bug_msg);
 #endif
 
-/*
- * This array holds the first and last local port number.
- * For high-usage systems, use sysctl to change this to
- * 32768-61000
- */
-int sysctl_local_port_range[2] = { 1024, 4999 };
+int sysctl_local_port_range[2] = { 32768, 61000 };
 
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
