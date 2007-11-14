Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXKNIos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXKNIos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXKNIoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:44:37 -0500
Received: from francois.mpi-sb.mpg.de ([139.19.1.2]:59586 "EHLO
	francois.mpi-sb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbXKNIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:44:36 -0500
X-Notes-Item: NOT CHECKED;
 name=$DNSBLSite
Date: Wed, 14 Nov 2007 09:44:20 +0100
From: Rainer Jochem <rainer.jochem@mpi-sb.mpg.de>
To: Patrick McHardy <kaber@trash.net>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pcernko@mpi-sws.mpg.de
Subject: Re: [PATCH] ipconfig.c : implement DHCP Class-identifier
Message-ID: <20071114084420.GA29241@mpi-sb.mpg.de>
References: <20071108143205.GA22490@mpi-sb.mpg.de> <47332F1F.5040401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47332F1F.5040401@trash.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Corrected version below.

> >+			printk(KERN_INFO "Sending class identifier \"%s\"\n",
> >+			       vendor_class_identifier);
> 
> Seems like useless noise.

This information is only sent in the case that the option is actually used.
And in this case it might be useful for the user to see to which string the 
option was set.


--- net/ipv4/ipconfig.c.orig	2007-11-14 09:16:15.800566536 +0100
+++ net/ipv4/ipconfig.c	2007-11-14 09:16:20.200403710 +0100
@@ -139,6 +139,8 @@ __be32 ic_servaddr = NONE;	/* Boot serve
 __be32 root_server_addr = NONE;	/* Address of NFS server */
 u8 root_server_path[256] = { 0, };	/* Path to mount as root */
 
+static char vendor_class_identifier[253]; /* vendor class identifier */
+
 /* Persistent data: */
 
 static int ic_proto_used;			/* Protocol used, if any */
@@ -580,6 +582,7 @@ ic_dhcp_init_options(u8 *options)
 	u8 mt = ((ic_servaddr == NONE)
 		 ? DHCPDISCOVER : DHCPREQUEST);
 	u8 *e = options;
+	int len = 0;
 
 #ifdef IPCONFIG_DEBUG
 	printk("DHCP: Sending message type %d\n", mt);
@@ -620,6 +623,16 @@ ic_dhcp_init_options(u8 *options)
 		*e++ = sizeof(ic_req_params);
 		memcpy(e, ic_req_params, sizeof(ic_req_params));
 		e += sizeof(ic_req_params);
+
+		if (*vendor_class_identifier) {
+			printk(KERN_INFO "Sending class identifier \"%s\"\n",
+			       vendor_class_identifier);
+			*e++ = 60;	/* Class-identifier */
+			len = strlen(vendor_class_identifier);
+			*e++ = len;
+			memcpy(e, vendor_class_identifier, len);
+			e += len;
+		}
 	}
 
 	*e++ = 255;	/* End of the list */
@@ -1507,5 +1520,16 @@ static int __init nfsaddrs_config_setup(
 	return ip_auto_config_setup(addrs);
 }
 
+static int __init vendor_class_identifier_setup(char *addrs)
+{
+	if (strlcpy(vendor_class_identifier, addrs,
+		    sizeof(vendor_class_identifier))
+	    > sizeof(vendor_class_identifier))
+		printk(KERN_WARNING "vendorclass too long, truncated to \"%s\"",
+		       vendor_class_identifier);
+	return 1;
+}
+
 __setup("ip=", ip_auto_config_setup);
 __setup("nfsaddrs=", nfsaddrs_config_setup);
+__setup("dhcpclass=", vendor_class_identifier_setup);




----



--- ../linux-2.6.23.1/Documentation/kernel-parameters.txt	2007-10-12 18:43:44.000000000 +0200
+++ Documentation/kernel-parameters.txt	2007-10-24 17:02:22.441454955 +0200
@@ -533,6 +533,10 @@ and is between 256 and 4096 characters. 
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
+	dhcpclass=	[IP_PNP]
+			Set DHCP Vendor Class Identifier to be sent
+			by the client.
+
 	digi=		[HW,SERIAL]
 			IO parameters + enable/disable command.

Signed-off-by: Rainer Jochem <rainer.jochem@mpi-sb.mpg.de>
