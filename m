Return-Path: <linux-kernel-owner+w=401wt.eu-S1763273AbXKOLkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763273AbXKOLkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbXKOLkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:40:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:27171 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164AbXKOLkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hqCfUR4CDQMELayC9pPCFWXYdokv3Te3kcZsv9MpXNPz5kQ2TwdcumEeMdPlgmFm7ZErOCZG7d76ihY5z7sxE2sm9rFGpD56hxPgXHU5YHj8hyztZJKcMijUNb43XHHRgnZ3Lg66suy1cAwkkcFAOKaItOw0ar/wFNJFPQxddCQ=
Message-ID: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
Date: Thu, 15 Nov 2007 12:40:22 +0100
From: "Jonas Danielsson" <the.sator@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0 (was: Strange behavior in arp probe reply, bug or feature?)
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arp reply when received arp probe with sender ip 0.

Can't find any ground in RFC2131 to send a non-valid arp-reply in
the special case of sender ip being set to 0.

- Bug fix for arp handling when sender ip is set to 0.
Send a correct arp reply instead of one with sender ip and sender
hardware adress in target fields.

Now sends target ip and target hw as received in arp probe.

Signed-off-by: Jonas Danielsson <the.sator@gmail.com>

---
arp.c |    3 ++-
1 file changed, 2 insertions(+), 1 deletion(-)

Index: arp.c
===================================================================
RCS file: /usr/local/cvs/linux/os/linux-2.6/net/ipv4/arp.c,v
retrieving revision 1.22
diff -u -w -r1.22 arp.c
--- arp.c	13 Oct 2006 12:45:47 -0000	1.22
+++ arp.c	15 Nov 2007 10:34:44 -0000
@@ -827,7 +827,8 @@
 		if (arp->ar_op == htons(ARPOP_REQUEST) &&
 		    inet_addr_type(tip) == RTN_LOCAL &&
 		    !arp_ignore(in_dev,dev,sip,tip))
-			arp_send(ARPOP_REPLY,ETH_P_ARP,tip,dev,tip,sha,dev->dev_addr,dev->dev_addr);
+			arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
+				 dev->dev_addr, sha);
 		goto out;
 	}
