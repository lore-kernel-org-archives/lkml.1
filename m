Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbXLRI5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbXLRI5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 03:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXLRI5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 03:57:36 -0500
Received: from koto.vergenet.net ([210.128.90.7]:43664 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXLRI5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 03:57:35 -0500
Date: Tue, 18 Dec 2007 17:57:32 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Amos Waterland <apw@us.ibm.com>, David Miller <davem@davemloft.net>
Subject: Update ip command line processing
Message-ID: <20071218085730.GA10765@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently the documentation in Documentation/nfsroot.txt was
update to note that in fact ip=off and ip=::::::off as the
latter is ignored and the default (on) is used.

This was certainly a step in the direction of reducing confusion.
But it seems to me that the code ought to be fixed up so that
ip=::::::off actually turns off ip autoconfiguration.

This patch also notes more specifically that ip=on (aka ip=::::::on)
is the default.

Cc: Amos Waterland <apw@us.ibm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

Index: net-2.6.25/net/ipv4/ipconfig.c
===================================================================
--- net-2.6.25.orig/net/ipv4/ipconfig.c	2007-12-18 17:45:07.000000000 +0900
+++ net-2.6.25/net/ipv4/ipconfig.c	2007-12-18 17:45:52.000000000 +0900
@@ -1414,9 +1414,16 @@ late_initcall(ip_auto_config);
  */
 static int __init ic_proto_name(char *name)
 {
+	if (!name) {
+		return 1;
+	}
 	if (!strcmp(name, "on") || !strcmp(name, "any")) {
 		return 1;
 	}
+	if (!strcmp(name, "off") || !strcmp(name, "none")) {
+		ic_enable = 0;
+		return 1;
+	}
 #ifdef CONFIG_IP_PNP_DHCP
 	else if (!strcmp(name, "dhcp")) {
 		ic_proto_enabled &= ~IC_RARP;
@@ -1451,12 +1458,6 @@ static int __init ip_auto_config_setup(c
 
 	ic_set_manually = 1;
 
-	ic_enable = (*addrs &&
-		(strcmp(addrs, "off") != 0) &&
-		(strcmp(addrs, "none") != 0));
-	if (!ic_enable)
-		return 1;
-
 	if (ic_proto_name(addrs))
 		return 1;
 
Index: net-2.6.25/Documentation/nfsroot.txt
===================================================================
--- net-2.6.25.orig/Documentation/nfsroot.txt	2007-12-18 17:46:47.000000000 +0900
+++ net-2.6.25/Documentation/nfsroot.txt	2007-12-18 17:48:51.000000000 +0900
@@ -97,10 +97,6 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
   autoconfiguration will take place.  The most common way to use this
   is "ip=dhcp".
 
-  Note that "ip=off" is not the same thing as "ip=::::::off", because in
-  the latter autoconfiguration will take place if any of DHCP, BOOTP or RARP
-  are compiled in the kernel.
-
   <client-ip>	IP address of the client.
 
   		Default:  Determined using autoconfiguration.
@@ -150,6 +146,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
 
                   off or none: don't use autoconfiguration
 		  on or any:   use any protocol available in the kernel
+			       (default)
 		  dhcp:        use DHCP
 		  bootp:       use BOOTP
 		  rarp:        use RARP
