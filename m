Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbXHVPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbXHVPoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761819AbXHVPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:44:18 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:21736 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759208AbXHVPoR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:44:17 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 11:44:16 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Patch for Apani Nortel VPN Client to build against kernel 2.6.22  help/review
Date: Wed, 22 Aug 2007 11:38:14 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128B34@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Patch for Apani Nortel VPN Client to build against kernel 2.6.22  help/review
Thread-Index: AcfkI91Mib5iMlt8QGC9HK0Uc0OIOwAAA8ggACLD+YA=
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <linux-kernel@vger.kernel.org>
Cc: =?iso-8859-1?Q?G=E9lineau=2CSamuel_=5BMontreal=5D?= 
	<samuel.gelineau@EC.GC.CA>
X-OriginalArrivalTime: 22 Aug 2007 15:38:14.0547 (UTC) FILETIME=[7419EE30:01C7E4D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sadly I have to use the Apani/Nortel VPN linux client to connect to my office.  The latest version (3.5) stopped being compatible with the latest stable 2.6.22 kernel (how suprising :().

Since
1) I'm stuck using that closed source/proprietary software
2) there will most probably not be a new release from apani until year 2013
3) support from apani is near zero
we got used with previous version (aka 3.3) to hack the linux_wrapper.c file to try to keep the module compatible (http://www.fedoraforum.org/forum/showpost.php?p=742619&postcount=26)

Based on the horrors that showed up while compiling against a 2.6.22 kernel (see below), I was wondering if somebody would be kind enough to review our not-yet-working patch that converts dev_base/skb calls to the new API.  A collegue of mine made all the required changes but when the netlock service gets fired-up the machine hang.

Are there any ways to debug this black box?

Help very much appreciated.

----------------------

Here is the not-yet-working patch against the linux_wrapper.c file:

--- cvc_linux-rh-gcc3-3.5.orig/src/linux_wrapper.c	2007-02-07 19:10:41.000000000 +0000
+++ cvc_linux-rh-gcc3-3.5/src/linux_wrapper.c	2007-08-21 17:42:30.000000000 +0000
@@ -136,6 +136,8 @@ int nl_open(struct inode *inode, struct 
 /* some necessary globals... */
 #if ((LINUX_VERSION_CODE >= 0x020200) && (LINUX_VERSION_CODE < 0x020300))
 typedef struct device net_device_t;
+#elif (LINUX_VERSION_CODE >= 0x020616)
+typedef struct list_head net_device_t;
 #else
 typedef struct net_device net_device_t;
 #endif
@@ -306,8 +308,11 @@ nl_copy_to_user(void *to, const void *fr
 
 void init_misc(void)
 {
-
+#if (LINUX_VERSION_CODE >= 0x020616)
+        nl_dev_base = &dev_base_head;
+#else
         nl_dev_base = dev_base;
+#endif
 }
 
 #if ((LINUX_VERSION_CODE >= 0x020200) && (LINUX_VERSION_CODE < 0x020300))
@@ -430,8 +435,13 @@ void nl_skb_put(struct sk_buff *skb, int
 int nl_ip_rcv(struct sk_buff *skb, struct packet_type *pt)
 {
 #if (LINUX_VERSION_CODE > 0x02060c)
+#if (LINUX_VERSION_CODE >= 0x020616)
+    struct net_device *dev = skb->dev;
+    struct iphdr *iph = (struct iphdr*) skb->network_header;
+#else
     struct net_device *dev = skb->dev;
     struct iphdr *iph = skb->nh.iph;
+#endif
 
     if (skb->dst == NULL)
         {
@@ -469,28 +479,52 @@ int nl_unregister_netdevice_notifier(str
 
 char *dev_name (net_device_t *dev)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (net_device_entry(dev)->name);
+#else
   return (dev->name);
+#endif
 }
 
 int dev_name_len (net_device_t *dev)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (strlen(net_device_entry(dev)->name));
+#else
   return (strlen(dev->name));
+#endif
 }
 unsigned *dev_mtu_ptr (net_device_t *dev)
 {
-  return (&dev->mtu);
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return &(net_device_entry(dev)->mtu);
+#else
+  return &(dev->mtu);
+#endif
 }
 unsigned dev_mtu (net_device_t *dev)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (net_device_entry(dev)->mtu);
+#else
   return (dev->mtu);
+#endif
 }
 int dev_ifindex (net_device_t *dev)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (net_device_entry(dev)->ifindex);
+#else
   return (dev->ifindex);
+#endif
 }
 void *dev_ip_ptr (net_device_t *dev)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (net_device_entry(dev)->ip_ptr);
+#else
   return (dev->ip_ptr);
+#endif
 }
 net_device_t *dev_next (net_device_t *dev)
 {
@@ -546,9 +580,15 @@ void nl_skb_dup (struct sk_buff *new_skb
     head_offset = new_skb->head - skb->head;
     new_skb->dev = skb->dev;
     new_skb->dst = dst_clone(skb->dst);
+#if (LINUX_VERSION_CODE >= 0x020616)
+    new_skb->transport_header = skb->transport_header+head_offset;
+    new_skb->network_header = skb->network_header+head_offset;
+    new_skb->mac_header = skb->mac_header+head_offset;
+#else
     new_skb->h.raw = skb->h.raw+head_offset;
     new_skb->nh.raw = skb->nh.raw+head_offset;
     new_skb->mac.raw = skb->mac.raw+head_offset;
+#endif
     memcpy(new_skb->cb, skb->cb, sizeof(skb->cb));
     new_skb->priority = skb->priority;
     new_skb->protocol = skb->protocol;
@@ -573,9 +613,15 @@ void nl_skb_hdr_copy (struct sk_buff *sk
 {
   skb_to->dev = skb_from->dev;
   skb_to->dst = skb_from->dst;
+#if (LINUX_VERSION_CODE >= 0x020616)
+  skb_to->transport_header = skb_from->transport_header;
+  skb_to->network_header = skb_from->network_header;
+  skb_to->mac_header = skb_from->mac_header;
+#else
   skb_to->h.raw = skb_from->h.raw;
   skb_to->nh.raw = skb_from->nh.raw;
   skb_to->mac.raw = skb_from->mac.raw;
+#endif
   memcpy(skb_to->cb, skb_from->cb, sizeof(skb_from->cb));
   skb_to->priority = skb_from->priority;
   skb_to->protocol = skb_from->protocol;
@@ -592,7 +638,11 @@ void nl_skb_hdr_copy (struct sk_buff *sk
 
 struct iphdr * nl_skb_iph (struct sk_buff *skb)
 {
+#if (LINUX_VERSION_CODE >= 0x020616)
+  return (struct iphdr*) skb->network_header;
+#else
   return skb->nh.iph;
+#endif
 }
 
 net_device_t * nl_skb_dev (struct sk_buff *skb)
@@ -613,10 +663,14 @@ void nl_send_skb (struct sk_buff *skb, n
 
   if (skb)
     {
-    skb->nh.iph = (struct iphdr *) skb->data;
     skb->dev = dev;
-                                                                                
-    iph = skb->nh.iph;
+#if (LINUX_VERSION_CODE >= 0x020616)
+    skb->network_header = skb->data;
+    iph = (struct iphdr*) skb->network_header;
+#else
+    skb->nh.iph = (struct iphdr *) skb->data;
+    iph = skb->network_header.iph;
+#endif
                                               
     rval = ip_route_output (&rt, iph->daddr, 0, RT_TOS(iph->tos), 0);
                                                                                 
@@ -749,7 +803,11 @@ void do_checksum_offload( struct sk_buff
     {
     goto done_exit;
     }
+#if (LINUX_VERSION_CODE >= 0x020616)
+  iph = (struct iphdr*) skb->network_header;
+#else
   iph = skb->nh.iph;
+#endif
   header_length = iph->ihl << 2;                /* get the ip header length */
   h_ptr = (char*)iph + header_length;           /* get pointer to proto header */
   frag_ptr = skb_shinfo( skb )->frag_list;      /* at most, one frag */
@@ -765,11 +823,11 @@ void do_checksum_offload( struct sk_buff
     csum = csum_partial( h_ptr, ntohs(iph->tot_len) - header_length, 0 );
     check = csum_fold( csum_partial( frag_ptr->data, nl_data_len( frag_ptr ), csum ) );
     }
-  if ( skb->nh.iph->protocol == 17 )            /* if UDP, */
+  if ( iph->protocol == 17 )            /* if UDP, */
     {
     ((struct udphdr*)h_ptr)->check = check;
     }
-  if ( skb->nh.iph->protocol == 6 )             /* if TCP, */
+  if ( iph->protocol == 6 )             /* if TCP, */
     {
     ((struct tcphdr*)h_ptr)->check = check;
     }

----------------------

Here are the "horrors" out of a make on the original linux_wrapper.c file against 2.6.22 kernel:

/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'init_misc':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:310: error: 'dev_base' undeclared (first use in this function) /usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrap
per.c:310: error: (Each undeclared identifier is reported only once /usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrap
per.c:310: error: for each function it appears in.) /usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrap
per.c: In function 'nl_ip_rcv':/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrap
per.c:434: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'dev_next':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:497: error: 'net_device_t' has no member named 'next'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'nl_skb_dup':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:549: error: 'struct sk_buff' has no member named 'h'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:549: error: 'struct sk_buff' has no member named 'h'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:550: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:550: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:551: error: 'struct sk_buff' has no member named 'mac'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:551: error: 'struct sk_buff' has no member named 'mac'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'nl_skb_hdr_copy':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:576: error: 'struct sk_buff' has no member named 'h'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:576: error: 'struct sk_buff' has no member named 'h'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:577: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:577: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:578: error: 'struct sk_buff' has no member named 'mac'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:578: error: 'struct sk_buff' has no member named 'mac'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'nl_skb_iph':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:595: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'nl_send_skb':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:616: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:619: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c: In function 'nl_data_len':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:658: error: invalid operands to binary - /usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrap
per.c: In function 'do_checksum_offload':
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:752: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:768: error: 'struct sk_buff' has no member named 'nh'
/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.c:772: error: 'struct sk_buff' has no member named 'nh'
make[3]: ***
[/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6/linux_wrapper.o] Error 1
make[2]: ***
[_module_/usr/src/Nortel/Apani_VPN_v3.5/cvc_linux-rh-gcc3-3.5/src/k2.6]
Error 2

- vin
