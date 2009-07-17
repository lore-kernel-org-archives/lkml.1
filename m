Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZGQUVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZGQUVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZGQUTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:54 -0400
Received: from kroah.org ([198.145.64.141]:43126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZGQUTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:35 2009
Message-Id: <20090717201235.532748898@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/24] Revert "ipv4: arp announce, arp_proxy and windows ip conflict verification"
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=revert-ipv4-arp-announce-arp_proxy-and-windows-ip-conflict-verification.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit f8a68e752bc4e39644843403168137663c984524 upstream.

This reverts commit 73ce7b01b4496a5fbf9caf63033c874be692333f.

After discovering that we don't listen to gratuitious arps in 2.6.30
I tracked the failure down to this commit.

The patch makes absolutely no sense.  RFC2131 RFC3927 and RFC5227.
are all in agreement that an arp request with sip == 0 should be used
for the probe (to prevent learning) and an arp request with sip == tip
should be used for the gratitous announcement that people can learn
from.

It appears the author of the broken patch got those two cases confused
and modified the code to drop all gratuitous arp traffic.  Ouch!

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/arp.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -801,11 +801,8 @@ static int arp_process(struct sk_buff *s
  *  cache.
  */
 
-	/*
-	 *  Special case: IPv4 duplicate address detection packet (RFC2131)
-	 *  and Gratuitous ARP/ARP Announce. (RFC3927, Section 2.4)
-	 */
-	if (sip == 0 || tip == sip) {
+	/* Special case: IPv4 duplicate address detection packet (RFC2131) */
+	if (sip == 0) {
 		if (arp->ar_op == htons(ARPOP_REQUEST) &&
 		    inet_addr_type(net, tip) == RTN_LOCAL &&
 		    !arp_ignore(in_dev, sip, tip))


