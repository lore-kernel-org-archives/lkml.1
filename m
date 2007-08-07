Return-Path: <linux-kernel-owner+w=401wt.eu-S964787AbXHGUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787AbXHGUue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935152AbXHGUrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:47:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51421 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935319AbXHGUrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:47:36 -0400
Date: Tue, 7 Aug 2007 13:43:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 12/84] Fix error queue socket lookup in ipv6
Message-ID: <20070807204352.GM23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-error-queue-socket-lookup-in-ipv6.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Butskoy <dmitry@butskoy.name>

[IPV6]: MSG_ERRQUEUE messages do not pass to connected raw sockets

From: Dmitry Butskoy <dmitry@butskoy.name>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8747

Problem Description:

It is related to the possibility to obtain MSG_ERRQUEUE messages from the udp
and raw sockets, both connected and unconnected.

There is a little typo in net/ipv6/icmp.c code, which prevents such messages
to be delivered to the errqueue of the correspond raw socket, when the socket
is CONNECTED.  The typo is due to swap of local/remote addresses.

Consider __raw_v6_lookup() function from net/ipv6/raw.c. When a raw socket is
looked up usual way, it is something like:

sk = __raw_v6_lookup(sk, nexthdr, daddr, saddr, IP6CB(skb)->iif);

where "daddr" is a destination address of the incoming packet (IOW our local
address), "saddr" is a source address of the incoming packet (the remote end).

But when the raw socket is looked up for some icmp error report, in
net/ipv6/icmp.c:icmpv6_notify() , daddr/saddr are obtained from the echoed
fragment of the "bad" packet, i.e.  "daddr" is the original destination
address of that packet, "saddr" is our local address.  Hence, for
icmpv6_notify() must use "saddr, daddr" in its arguments, not "daddr, saddr"
...

Steps to reproduce:

Create some raw socket, connect it to an address, and cause some error
situation: f.e. set ttl=1 where the remote address is more than 1 hop to reach.
Set IPV6_RECVERR .
Then send something and wait for the error (f.e. poll() with POLLERR|POLLIN).
You should receive "time exceeded" icmp message (because of "ttl=1"), but the
socket do not receive it.

If you do not connect your raw socket, you will receive MSG_ERRQUEUE
successfully.  (The reason is that for unconnected socket there are no actual
checks for local/remote addresses).

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/icmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -604,7 +604,7 @@ static void icmpv6_notify(struct sk_buff
 
 	read_lock(&raw_v6_lock);
 	if ((sk = sk_head(&raw_v6_htable[hash])) != NULL) {
-		while((sk = __raw_v6_lookup(sk, nexthdr, daddr, saddr,
+		while ((sk = __raw_v6_lookup(sk, nexthdr, saddr, daddr,
 					    IP6CB(skb)->iif))) {
 			rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 			sk = sk_next(sk);

-- 
