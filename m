Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYB0MYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYB0MYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYB0MXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:23:54 -0500
Received: from mx.bridgeco.net ([213.173.191.47]:1994 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbYB0MXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:23:53 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: [PATCH] [resend]The kernel gets no IP from some DHCP servers, 2.6.24
Date: Wed, 27 Feb 2008 13:23:48 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301C5CDEF@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [resend]The kernel gets no IP from some DHCP servers, 2.6.24
Thread-Index: Ach0m4cSiApNdLdFScC3DSTHVH8H7w==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>, <davem@davemloft.net>, <ebiederman@lnxi.com>
X-OriginalArrivalTime: 27 Feb 2008 12:23:52.0932 (UTC) FILETIME=[9D4F7240:01C8793B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why there is no feedback to the sugested DHCP patch to
linux/net/ipv4/ipconfig.c Am I wrong with the interpretation of
RFC2131 section about the contents of a clients DHCPDISCOVER
packet? If not I would assume that the behaviour of the kernels
DHCP should be changed.

Thanks,
Marcel

the original mail:
http://lkml.org/lkml/2008/2/21/171

====== original patch =========
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
