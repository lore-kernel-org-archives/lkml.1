Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbXI0Ovf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbXI0Ovf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbXI0Ov2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:51:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbXI0Ov2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:51:28 -0400
Date: Thu, 27 Sep 2007 07:51:02 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Oleg Verych <olecom@flower.upol.cz>, Jan Beulich <jbeulich@novell.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting? (Re: [PATCH]
 Module use count must be updated as bridges are created/destroyed)
Message-ID: <20070927075102.4335a263@freepuppy.rosehill>
In-Reply-To: <46FB99EF.4020806@aitel.hist.no>
References: <46FA2C17.76E4.0078.0@novell.com>
	<20070926083705.6bc65ea5@fujitsu-loaner>
	<E1Iae5t-0007Sk-Vu@flower>
	<20070926140608.6e6d3d0c@freepuppy.rosehill>
	<Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
	<20070926153330.77aade4d@freepuppy.rosehill>
	<46FB99EF.4020806@aitel.hist.no>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 13:54:23 +0200
Helge Hafting <helge.hafting@aitel.hist.no> wrote:

> Stephen Hemminger wrote:
> > On Thu, 27 Sep 2007 00:18:55 +0200 (CEST)
> > Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> >   
> >> On Sep 26 2007 14:06, Stephen Hemminger wrote:
> >>     
> >>>>> No, network devices don't do reference counting.
> >>>>>           
> >>>> Could you explain why, please?
> >>>>
> >>>> After `udevd` on boot loads lots of unused crap, i surrendered, and use
> >>>> $(rmmod `lsmod | just first column`). Networing bravely wipes away. OK,
> >>>> there are lots of configs: udev, hotplug, modprobe, that somebody might
> >>>> like to fix. But it came to the end with me. I just don't care. So,
> >>>> please answer :)
> >>>>         
> >>> For hotplug and other reasons, the network developers decided that being
> >>> able to remove a network module at any time was a good thing. It works.
> >>>       
> >> Except that for ipv6.ko, it's all opposite. After modprobe,
> >> it already got a refcount like 8 and you're wondering how
> >> to get rid of that.
> >>     
> >
> > ipv6 is not a network driver, it is a protocol. You might be able to remove it if you zap
> > all the routes and applications, ...
> >   
> Wouldn't it be enough to down all the interfaces and close all the sockets?
> No need to bring down every app.

You need every socket to close and all routes to go away including the routes through
loopback device, and still there probably are control sockets buried inside ipv6
that hold ref count.

IMHO the kernel should just admit that IPV6 can't be removed.

--- a/net/ipv6/af_inet6.c	2007-09-26 16:28:01.000000000 -0700
+++ b/net/ipv6/af_inet6.c	2007-09-26 17:38:23.000000000 -0700
@@ -914,6 +914,9 @@ out_unregister_tcp_proto:
 }
 module_init(inet6_init);
 
+/* Disabled at present because it is impossible to remove all references */
+#ifdef IPV6_UNLOAD
+
 static void __exit inet6_exit(void)
 {
 	/* First of all disallow new sockets creation. */
@@ -952,5 +955,6 @@ static void __exit inet6_exit(void)
 	proto_unregister(&tcpv6_prot);
 }
 module_exit(inet6_exit);
+#endif
 
 MODULE_ALIAS_NETPROTO(PF_INET6);
--- a/net/ipv6/addrconf.c	2007-09-26 15:07:35.000000000 -0700
+++ b/net/ipv6/addrconf.c	2007-09-26 17:36:52.000000000 -0700
@@ -4255,6 +4255,7 @@ errout:
 	return err;
 }
 
+#ifdef IPV6_UNLOAD
 void __exit addrconf_cleanup(void)
 {
 	struct net_device *dev;
@@ -4308,3 +4309,4 @@ void __exit addrconf_cleanup(void)
 	proc_net_remove(&init_net, "if_inet6");
 #endif
 }
+#endif
--- a/net/ipv6/ipv6_sockglue.c	2007-09-26 15:07:35.000000000 -0700
+++ b/net/ipv6/ipv6_sockglue.c	2007-09-26 17:36:17.000000000 -0700
@@ -1132,7 +1132,9 @@ void __init ipv6_packet_init(void)
 	dev_add_pack(&ipv6_packet_type);
 }
 
-void ipv6_packet_cleanup(void)
+#ifdef IPV6_UNLOAD
+void __exit ipv6_packet_cleanup(void)
 {
 	dev_remove_pack(&ipv6_packet_type);
 }
+#endif
