Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXELABw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXELABw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXELABq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:01:46 -0400
Received: from squawk.glines.org ([72.36.206.66]:43177 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXELABp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:01:45 -0400
Date: Fri, 11 May 2007 17:01:35 -0700
From: Mark Glines <mark@glines.org>
To: linux-kernel@vger.kernel.org
Subject: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070511170135.7c38615f@chirp>
Organization: Glines.org
X-Mailer: Claws Mail 2.9.0 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a powerpc machine (kurobox) I have here with 128M of RAM, the default
value of /proc/sys/net/ipv4/ip_local_port_range is:
2048    4999

This setting affects the port assigned to an application by default
when the application doesn't specify a port to use, like, for instance,
an outgoing connection.  It affects both TCP and UDP.  The default
values for this sysctl vary depending on the size of the tcp bind hash,
which in turn, varies depending on the size of the system RAM (I think).

By a one-in-a-million coincidence, this machine has a default port
range starting with 2048, and this breaks things for me.  I'm trying to
run both klive and nfs on this box, but klive starts first (probably
because of the filename sort order), and claims UDP port 2049 for its
own purposes, causing the nfs server to fail to start.

If the bind hash size is over a certain threshold, the range
32768-61000 is used.  If it is under a certain threshold, a range
like (1024|2048|3072)-4999 is used, depending on exactly how small it
is.  Thix box happened to get the 2048-4999 range, which broke nfs.

A comment just above the code that does this says, "Try to be a bit
smarter and adjust defaults depending on available memory."  "smarter"?
Maybe, maybe not.  Either way, it's unexpected.

Following the principle of least astonishment, I think it seems better
to use high, out-of-the-way port numbers regardless of how much RAM the
system has.  So, the following patch changes this behavior slightly.
The system still picks a dynamic range depending on the bind hash size,
but now, all ranges start with 32768.  I suppose another reasonable way
to do this would be to end all ranges with 61000, or something like
that.

It also seems funny to me that this would be in tcp_init(), when it
affects both TCP and UDP.  But hey, it is where it is.

Signed-off-by: Mark Glines <mark@glines.org>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd4c295..4431b87 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2464,14 +2464,14 @@ void __init tcp_init(void)
 			(tcp_hashinfo.bhash_size * sizeof(struct inet_bind_hashbucket));
 			order++)
 		;
+	sysctl_local_port_range[0] = 32768;
 	if (order >= 4) {
-		sysctl_local_port_range[0] = 32768;
 		sysctl_local_port_range[1] = 61000;
 		tcp_death_row.sysctl_max_tw_buckets = 180000;
 		sysctl_tcp_max_orphans = 4096 << (order - 4);
 		sysctl_max_syn_backlog = 1024;
 	} else if (order < 3) {
-		sysctl_local_port_range[0] = 1024 * (3 - order);
+		sysctl_local_port_range[1] = 32768 + (1024 * order);
 		tcp_death_row.sysctl_max_tw_buckets >>= (3 - order);
 		sysctl_tcp_max_orphans >>= (3 - order);
 		sysctl_max_syn_backlog = 128;
