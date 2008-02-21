Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbYBUPbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbYBUPbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYBUPbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:31:25 -0500
Received: from nsmx.bridgeco.net ([213.173.191.36]:55784 "EHLO
	nsmx.bridgeco.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYBUPbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:31:24 -0500
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 10:31:24 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] The kernel gets no IP from some DHCP servers, 2.6.24
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 21 Feb 2008 16:07:51 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301C5C723@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] The kernel gets no IP from some DHCP servers, 2.6.24
Thread-Index: Ach0m4cSiApNdLdFScC3DSTHVH8H7w==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a DHCP issue of the kernel: some DHCP servers
(i.e. in the Linksys WRT54Gv5) are very strict about the contents 
of the DHCPDISCOVER packet they receive from clients. Table 5 in RFC2131
page 36 requests the fields 'ciaddr' and 'siaddr' MUST be set to '0'.
These DHCP servers ignore Linux kernel's DHCP discovery packets with these two
fields set to '255.255.255.255' (in contrast to popular DHCP clients, such as
'dhclient' or 'udhcpc'). This leads to a not booting system.
I tested this on a ARM embedded device mounting rootfs over NFS obtaining
its IP from a Linksys WRT54Gv5 Router running VxWorks and a PC based Server
running a Linux. Changing the two fields to '0.0.0.0' worked.

Please CC me personaly when answering this message.

Thanks,
Marcel

--- linux-2.6.24.2/net/ipv4/ipconfig.c	2008-02-21 15:27:47.250890963 +0100
+++ linux/net/ipv4/ipconfig.c	2008-02-21 15:36:12.686735925 +0100
@@ -29,6 +29,10 @@
  *
  *  Multiple Nameservers in /proc/net/pnp
  *              --  Josef Siemes <jsiemes@web.de>, Aug 2002
+ *
+ *  Bugfix: Not getting an IP from some DHCP servers: RFC2131 page 36
+ *  Table 5 requests DHCPDISCOVER fields ciaddr and siaddr MUST be '0'.
+ *              -- marcel.wappler@bridgeco.net
  */
 
 #include <linux/types.h>
@@ -103,6 +107,7 @@
 					   - '3' from resolv.h */
 
 #define NONE __constant_htonl(INADDR_NONE)
+#define ZERO __constant_htonl(((unsigned long int) 0x00000000))
 
 /*
  * Public IP configuration
@@ -740,8 +745,8 @@
 		b->htype = dev->type; /* can cause undefined behavior */
 	}
 	b->hlen = dev->addr_len;
-	b->your_ip = NONE;
-	b->server_ip = NONE;
+	b->your_ip = ZERO;
+	b->server_ip = ZERO;
 	memcpy(b->hw_addr, dev->dev_addr, dev->addr_len);
 	b->secs = htons(jiffies_diff / HZ);
 	b->xid = d->xid;

--
Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
