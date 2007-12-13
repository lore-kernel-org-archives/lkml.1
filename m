Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbXLMGrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbXLMGrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759156AbXLMGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56596 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXLMGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:10 -0500
Date: Wed, 12 Dec 2007 22:35:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 27/36] IPV6: Restore IPv6 when MTU is big enough
Message-ID: <20071213063514.GB25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-restore-ipv6-when-mtu-is-big-enough.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

[IPV6]: Restore IPv6 when MTU is big enough

[ Upstream commit: d31c7b8fa303eb81311f27b80595b8d2cbeef950 ]

Avaid provided test application, so bug got fixed.

IPv6 addrconf removes ipv6 inner device from netdev each time cmu
changes and new value is less than IPV6_MIN_MTU (1280 bytes).
When mtu is changed and new value is greater than IPV6_MIN_MTU,
it does not add ipv6 addresses and inner device bac.

This patch fixes that.

Tested with Avaid's application, which works ok now.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2285,6 +2285,9 @@ static int addrconf_notify(struct notifi
 				break;
 			}
 
+			if (!idev && dev->mtu >= IPV6_MIN_MTU)
+				idev = ipv6_add_dev(dev);
+
 			if (idev)
 				idev->if_flags |= IF_READY;
 		} else {
@@ -2349,12 +2352,18 @@ static int addrconf_notify(struct notifi
 		break;
 
 	case NETDEV_CHANGEMTU:
-		if ( idev && dev->mtu >= IPV6_MIN_MTU) {
+		if (idev && dev->mtu >= IPV6_MIN_MTU) {
 			rt6_mtu_change(dev, dev->mtu);
 			idev->cnf.mtu6 = dev->mtu;
 			break;
 		}
 
+		if (!idev && dev->mtu >= IPV6_MIN_MTU) {
+			idev = ipv6_add_dev(dev);
+			if (idev)
+				break;
+		}
+
 		/* MTU falled under IPV6_MIN_MTU. Stop IPv6 on this interface. */
 
 	case NETDEV_DOWN:

-- 
