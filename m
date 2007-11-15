Return-Path: <linux-kernel-owner+w=401wt.eu-S1765913AbXKOG2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765913AbXKOG2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764314AbXKOGWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764737AbXKOGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:09 -0500
Date: Wed, 14 Nov 2007 22:20:38 -0800
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/23] Fix endianness bug in U32 classifier.
Message-ID: <20071115062038.GL8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-endianness-bug-in-u32-classifier.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Radu Rendec <radu.rendec@ines.ro>

changeset 543821c6f5dea5221426eaf1eac98b100249c7ac in mainline.

[PKT_SCHED] CLS_U32: Fix endianness problem with u32 classifier hash masks.

While trying to implement u32 hashes in my shaping machine I ran into
a possible bug in the u32 hash/bucket computing algorithm
(net/sched/cls_u32.c).

The problem occurs only with hash masks that extend over the octet
boundary, on little endian machines (where htonl() actually does
something).

Let's say that I would like to use 0x3fc0 as the hash mask. This means
8 contiguous "1" bits starting at b6. With such a mask, the expected
(and logical) behavior is to hash any address in, for instance,
192.168.0.0/26 in bucket 0, then any address in 192.168.0.64/26 in
bucket 1, then 192.168.0.128/26 in bucket 2 and so on.

This is exactly what would happen on a big endian machine, but on
little endian machines, what would actually happen with current
implementation is 0x3fc0 being reversed (into 0xc03f0000) by htonl()
in the userspace tool and then applied to 192.168.x.x in the u32
classifier. When shifting right by 16 bits (rank of first "1" bit in
the reversed mask) and applying the divisor mask (0xff for divisor
256), what would actually remain is 0x3f applied on the "168" octet of
the address.

One could say is this can be easily worked around by taking endianness
into account in userspace and supplying an appropriate mask (0xfc03)
that would be turned into contiguous "1" bits when reversed
(0x03fc0000). But the actual problem is the network address (inside
the packet) not being converted to host order, but used as a
host-order value when computing the bucket.

Let's say the network address is written as n31 n30 ... n0, with n0
being the least significant bit. When used directly (without any
conversion) on a little endian machine, it becomes n7 ... n0 n8 ..n15
etc in the machine's registers. Thus bits n7 and n8 would no longer be
adjacent and 192.168.64.0/26 and 192.168.128.0/26 would no longer be
consecutive.

The fix is to apply ntohl() on the hmask before computing fshift,
and in u32_hash_fold() convert the packet data to host order before
shifting down by fshift.

With helpful feedback from Jamal Hadi Salim and Jarek Poplawski.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_u32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -91,7 +91,7 @@ static struct tc_u_common *u32_list;
 
 static __inline__ unsigned u32_hash_fold(u32 key, struct tc_u32_sel *sel, u8 fshift)
 {
-	unsigned h = (key & sel->hmask)>>fshift;
+	unsigned h = ntohl(key & sel->hmask)>>fshift;
 
 	return h;
 }
@@ -615,7 +615,7 @@ static int u32_change(struct tcf_proto *
 	n->handle = handle;
 {
 	u8 i = 0;
-	u32 mask = s->hmask;
+	u32 mask = ntohl(s->hmask);
 	if (mask) {
 		while (!(mask & 1)) {
 			i++;

-- 
