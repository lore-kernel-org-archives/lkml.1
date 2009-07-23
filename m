Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZGWVol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZGWVol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZGWVok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:44:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:45710 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZGWVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:44:40 -0400
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 14:39:28 -0700
Message-ID: <6c039e090907231439t1def08a4n10978733bee55bec@mail.gmail.com>
Subject: [PATCH] net: Keep interface binding when sending packets with 
	ipi_ifindex = 0
From: =?UTF-8?B?Q2hpYS1jaGkgWWVoICjokYnlrrbpvYop?= <chiachi@android.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In IPv4, sending a packet with ipi_ifindex = 0 via an interface-bound
socket will unbind the packet to that interface. This behavior is
different from IPv6 which treats ipi6_ifindex = 0 as unspecified.
Furthermore, IPv6 does not allow sending packets to other interface
than the bound one, but I am not sure if it is necessary in IPv4. The
following patch keeps the interface binding when ipi_ifindex = 0.

Thanks,
Chia-chi

--- a/net/ipv4/ip_sockglue.c	2009-07-24 04:50:45.000000000 +0800
+++ b/net/ipv4/ip_sockglue.c	2009-07-24 04:51:09.000000000 +0800
@@ -213,7 +213,8 @@
 			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct in_pktinfo)))
 				return -EINVAL;
 			info = (struct in_pktinfo *)CMSG_DATA(cmsg);
-			ipc->oif = info->ipi_ifindex;
+			if (info->ipi_ifindex)
+				ipc->oif = info->ipi_ifindex;
 			ipc->addr = info->ipi_spec_dst.s_addr;
 			break;
 		}
