Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXJaPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXJaPZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbXJaPYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33421 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759728AbXJaPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:15 -0400
Date: Wed, 31 Oct 2007 08:11:17 -0700
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
       Brian Haley <brian.haley@hp.com>,
       David L Stevens <dlstevens@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/26] Fix ipv6 redirect processing, leads to TAHI failures.
Message-ID: <20071031151117.GG2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-redirect-processing-leads-to-tahi-failures.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Brian Haley <brian.haley@hp.com>

changeset bf0b48dfc368c07c42b5a3a5658c8ee81b4283ac from mainline.

When the ICMPv6 Target address is multicast, Linux processes the
redirect instead of dropping it.  The problem is in this code in
ndisc_redirect_rcv():

         if (ipv6_addr_equal(dest, target)) {
                 on_link = 1;
         } else if (!(ipv6_addr_type(target) & IPV6_ADDR_LINKLOCAL)) {
                 ND_PRINTK2(KERN_WARNING
                            "ICMPv6 Redirect: target address is not
link-local.\n");
                 return;
         }

This second check will succeed if the Target address is, for example,
FF02::1 because it has link-local scope.  Instead, it should be checking
if it's a unicast link-local address, as stated in RFC 2461/4861 Section
8.1:

       - The ICMP Target Address is either a link-local address (when
         redirected to a router) or the same as the ICMP Destination
         Address (when redirected to the on-link destination).

I know this doesn't explicitly say unicast link-local address, but it's
implied.

This bug is preventing Linux kernels from achieving IPv6 Logo Phase II
certification because of a recent error that was found in the TAHI test
suite - Neighbor Disovery suite test 206 (v6LC.2.3.6_G) had the
multicast address in the Destination field instead of Target field, so
we were passing the test.  This won't be the case anymore.

The patch below fixes this problem, and also fixes ndisc_send_redirect()
to not send an invalid redirect with a multicast address in the Target
field.  I re-ran the TAHI Neighbor Discovery section to make sure Linux
passes all 245 tests now.

Signed-off-by: Brian Haley <brian.haley@hp.com>
Acked-by: David L Stevens <dlstevens@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ndisc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1268,9 +1268,10 @@ static void ndisc_redirect_rcv(struct sk
 
 	if (ipv6_addr_equal(dest, target)) {
 		on_link = 1;
-	} else if (!(ipv6_addr_type(target) & IPV6_ADDR_LINKLOCAL)) {
+	} else if (ipv6_addr_type(target) !=
+		   (IPV6_ADDR_UNICAST|IPV6_ADDR_LINKLOCAL)) {
 		ND_PRINTK2(KERN_WARNING
-			   "ICMPv6 Redirect: target address is not link-local.\n");
+			   "ICMPv6 Redirect: target address is not link-local unicast.\n");
 		return;
 	}
 
@@ -1344,9 +1345,9 @@ void ndisc_send_redirect(struct sk_buff 
 	}
 
 	if (!ipv6_addr_equal(&ipv6_hdr(skb)->daddr, target) &&
-	    !(ipv6_addr_type(target) & IPV6_ADDR_LINKLOCAL)) {
+	    ipv6_addr_type(target) != (IPV6_ADDR_UNICAST|IPV6_ADDR_LINKLOCAL)) {
 		ND_PRINTK2(KERN_WARNING
-			"ICMPv6 Redirect: target address is not link-local.\n");
+			"ICMPv6 Redirect: target address is not link-local unicast.\n");
 		return;
 	}
 

-- 
