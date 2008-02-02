Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYBBA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYBBA0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763099AbYBBAYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:25 -0500
Received: from ns1.suse.de ([195.135.220.2]:54557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763058AbYBBAYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:23 -0500
Date: Fri, 1 Feb 2008 16:20:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/27] IPV4 ROUTE: ip_rt_dump() is unecessary slow
Message-ID: <20080202002015.GI8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-route-ip_rt_dump-is-unecessary-slow.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric Dumazet <dada1@cosmosbay.com>

[IPV4] ROUTE: ip_rt_dump() is unecessary slow

[ Upstream commit: d8c9283089287341c85a0a69de32c2287a990e71 ]

I noticed "ip route list cache x.y.z.t" can be *very* slow.

While strace-ing -T it I also noticed that first part of route cache
is fetched quite fast :

recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202
GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3772 <0.000047>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\234\0\0\0\30\0\2\0\254i\
202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3736 <0.000042>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\204\0\0\0\30\0\2\0\254i\
202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3740 <0.000055>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\234\0\0\0\30\0\2\0\254i\
202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3712 <0.000043>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\204\0\0\0\30\0\2\0\254i\
202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3732 <0.000053>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202
GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3708 <0.000052>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202
GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3680 <0.000041>

while the part at the end of the table is more expensive:

recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\204\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3656 <0.003857>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\204\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3772 <0.003891>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3712 <0.003765>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3700 <0.003879>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3676 <0.003797>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"p\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\2\0\2\0"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3724 <0.003856>
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\234\0\0\0\30\0\2\0\254i\202GXm\0\0\2  \0\376\0\0\1\0\2"..., 16384}], msg_controllen=0, msg_flags=0}, 0) = 3736 <0.003848>

The following patch corrects this performance/latency problem,
removing quadratic behavior.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2885,11 +2885,10 @@ int ip_rt_dump(struct sk_buff *skb,  str
 	int idx, s_idx;
 
 	s_h = cb->args[0];
+	if (s_h < 0)
+		s_h = 0;
 	s_idx = idx = cb->args[1];
-	for (h = 0; h <= rt_hash_mask; h++) {
-		if (h < s_h) continue;
-		if (h > s_h)
-			s_idx = 0;
+	for (h = s_h; h <= rt_hash_mask; h++) {
 		rcu_read_lock_bh();
 		for (rt = rcu_dereference(rt_hash_table[h].chain), idx = 0; rt;
 		     rt = rcu_dereference(rt->u.dst.rt_next), idx++) {
@@ -2906,6 +2905,7 @@ int ip_rt_dump(struct sk_buff *skb,  str
 			dst_release(xchg(&skb->dst, NULL));
 		}
 		rcu_read_unlock_bh();
+		s_idx = 0;
 	}
 
 done:

-- 
