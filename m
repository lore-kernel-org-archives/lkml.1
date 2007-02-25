Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXBYAaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXBYAaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBYAaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:30:09 -0500
Received: from main.gmane.org ([80.91.229.2]:37788 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbXBYAaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:30:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michal Wrobel <xmxwx@asn.pl>
Subject: [PATCH] IPv6 anycast refcnt fix
Date: Sun, 25 Feb 2007 01:13:59 +0100
Message-ID: <erqkc9$9sb$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: vw54.internetdsl.tpnet.pl
User-Agent: IceDove 1.5.0.8 (X11/20061128)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in Linux IPv6 stack which caused anycast address 
to be added to a device prior DAD has been completed. This led to 
incorrect reference count which resulted in infinite wait for 
unregister_netdevice completion on interface removal.

Signed-off-by: Michal Wrobel <xmxwx@asn.pl>

--- linux/net/ipv6/addrconf.c	2007-02-22 19:46:27.000000000 +0100
+++ linux/net/ipv6/addrconf.c	2007-02-25 00:22:37.000000000 +0100
@@ -456,6 +456,8 @@
  			ipv6_dev_mc_dec(dev, &addr);
  	}
  	for (ifa=idev->addr_list; ifa; ifa=ifa->if_next) {
+		if (ifa->flags&IFA_F_TENTATIVE)
+			continue;
  		if (idev->cnf.forwarding)
  			addrconf_join_anycast(ifa);
  		else

