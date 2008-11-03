Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYKCLLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYKCLLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYKCLK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:10:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:57922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbYKCLK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=Xt+4fuDj0tFL5eET3lF+Rq4NqFptF4v/qAleyVvvC/CAtqsX3EH0Wa2HlVVg7LdVhH
         E4i4wISjQsAx2WFhk0H9zgCArR46nGBZzztI2B7gWiBXdDcnnOmPfoFLg2C3Mk4Ah5LB
         9pGSoFNe/o5m7R+v0twhdn2aQ0UAMdXxMA7LI=
Message-ID: <490EDBDD.1030104@gmail.com>
Date: Mon, 03 Nov 2008 13:09:17 +0200
From: Constantine Gavrilov <constantine.gavrilov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080417 Fedora/1.1.9-2.fc7 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: general@lists.openfabrics.org
Subject: patch: support long (above 14 bytes) HW addresses in arp_ioctl
Content-Type: multipart/mixed;
 boundary="------------050407020403060601020400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050407020403060601020400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While working with OFED infiniband stack that uses 20 byte long HW 
addresses for IP over IB, I have paid attention to the following  
arp_ioctl problem.

The ioctl uses a data structure that limits a length of HW address to 14 
bytes. The IP stack and the arp cache code do not have that limitation. 
This leads to the following problems:

* arp_ioctl cannot be used to set, get, or delete arp entries for those 
adapters that have HW addresses longer than 14 bytes
* arp_ioctl will corrupt the kernel and user memory when this ioctl is 
used on the adapters that have HW addresses longer that 14 bytes.  This 
is because when copying the HW address, the arp_ioctl code copies 
dev->addr_len bytes without checking that addr_len is not above 14 
bytes. This is done both for copy_to_user() and memcpy() calls on kernel 
data structures allocated on stack. The memcpy() call in particular, 
will corrupt kernel stack.

Attached please find the patch that fixes both problems. In addition, 
the patch changes the maximal number of bytes for HW address that will 
be seen in /proc/net/arp from ~10 to ~30. Without the last change, 
output of /proc/net/arp truncates the the large MAC entries, which makes 
the arp utility useless.

The patch does not change the existing ABI but extends it.  The kernel 
structure used in arp_ioctl calls is changed to support larger 
addresses, while the user-space structure is extended by appending 
extra-space to the end of the structure if ATF_NEWARPCTL -- a new flag  
-- is set in arp_flags of existing user-space structure. This allows 
avoiding big changes to the existing code while preserving the ABI 
compatibility.

-- 
----------------------------------------
Constantine Gavrilov
Kernel Developer
Platform Group
XIV, an IBM global brand 
1 Azrieli Center, Tel-Aviv
Phone: +972-3-6074672
Fax:   +972-3-6959749
----------------------------------------



--------------050407020403060601020400
Content-Type: text/x-patch;
 name="arp_ioctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arp_ioctl.patch"

--- include/linux/if_arp.h.orig	2008-10-10 00:13:53.000000000 +0200
+++ include/linux/if_arp.h	2008-11-02 16:41:59.000000000 +0200
@@ -99,14 +99,27 @@
 #define	ARPOP_InREPLY	9		/* InARP reply			*/
 #define	ARPOP_NAK	10		/* (ATM)ARP NAK			*/
 
+struct hwaddr {
+  sa_family_t     sa_family;      /* address family, AF_xxx       */
+  char            sa_data[30];    /* 30 bytes of HW address */
+};
 
 /* ARP ioctl request. */
 struct arpreq {
   struct sockaddr	arp_pa;		/* protocol address		*/
+  struct hwaddr		arp_ha;		/* hardware address		*/
+  int			arp_flags;	/* flags			*/
+  struct sockaddr       arp_netmask;    /* netmask (only for proxy arps) */
+  char			arp_dev[16];
+};
+
+struct arpreq_user {
+  struct sockaddr	arp_pa;		/* protocol address		*/
   struct sockaddr	arp_ha;		/* hardware address		*/
   int			arp_flags;	/* flags			*/
   struct sockaddr       arp_netmask;    /* netmask (only for proxy arps) */
   char			arp_dev[16];
+  char			arp_ha_ext[16]; /* extended part of HW address */
 };
 
 struct arpreq_old {
@@ -124,6 +137,10 @@
 #define ATF_NETMASK     0x20            /* want to use a netmask (only
 					   for proxy entries) */
 #define ATF_DONTPUB	0x40		/* don't answer this addresses	*/
+#define ATF_NEWARPCTL	0x80		/* use larger buff for hw address */
+
+#define NOT_VALID_ARP_CTL(__dev, __r) ((__dev->addr_len > sizeof(((struct arpreq_user *)__r)->arp_ha.sa_data)) && \
+	((__dev->addr_len > sizeof(__r->arp_ha.sa_data)) || !(__r->arp_flags & ATF_NEWARPCTL)))
 
 /*
  *	This structure defines an ethernet arp header.
--- net/ipv4/arp.c.orig	2008-10-10 00:13:53.000000000 +0200
+++ net/ipv4/arp.c	2008-11-02 16:59:34.000000000 +0200
@@ -968,7 +968,12 @@
 	if (!dev && (r->arp_flags & ATF_COM)) {
 		dev = dev_getbyhwaddr(net, r->arp_ha.sa_family,
 				r->arp_ha.sa_data);
-		if (!dev)
+		if (!dev || NOT_VALID_ARP_CTL(dev, r)) /* 
+							 if we managed to find an interface that should have 
+							 larger buffer for HW MAC than one that was supposedly supplied, 
+							 it is not our interface -- the NIC was matched by "junk"
+							 extended data in r and not by  user supplied address
+							*/
 			return -ENODEV;
 	}
 	if (mask) {
@@ -1004,6 +1009,9 @@
 		if (!dev)
 			return -EINVAL;
 	}
+	if(NOT_VALID_ARP_CTL(dev, r)) 
+		return -EINVAL; /* the user gave too short HW address */
+
 	switch (dev->type) {
 #ifdef CONFIG_FDDI
 	case ARPHRD_FDDI:
@@ -1127,11 +1135,23 @@
  *	Handle an ARP layer I/O control request.
  */
 
+#define swap_arp_ioctl_structs(__in, __out) \
+do {\
+	__out.arp_pa = __in.arp_pa; \
+	__out.arp_ha.sa_family = __in.arp_ha.sa_family; \
+	memcpy(&__out.arp_ha.sa_data[0], &__in.arp_ha.sa_data[0], sizeof(__in.arp_ha.sa_data)); \
+	__out.arp_flags = __in.arp_flags; \
+	__out.arp_netmask = __in.arp_netmask; \
+	memcpy(&__out.arp_dev[0], &__in.arp_dev[0], sizeof(__in.arp_dev)); \
+} while(0)
+ 
 int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 {
 	int err;
 	struct arpreq r;
+	struct arpreq_user user_r;
 	struct net_device *dev = NULL;
+	int is_newarpctl = 0;
 
 	switch (cmd) {
 		case SIOCDARP:
@@ -1139,9 +1159,16 @@
 			if (!capable(CAP_NET_ADMIN))
 				return -EPERM;
 		case SIOCGARP:
-			err = copy_from_user(&r, arg, sizeof(struct arpreq));
+			err = copy_from_user(&user_r, arg, offsetof(struct arpreq_user,  arp_ha_ext));
 			if (err)
 				return -EFAULT;
+			swap_arp_ioctl_structs(user_r, r);
+			if(user_r.arp_flags & ATF_NEWARPCTL) {
+				is_newarpctl = 1;
+				err =  copy_from_user(&r.arp_ha.sa_data[0] + sizeof(user_r.arp_ha.sa_data), (char *)arg + offsetof(struct arpreq_user,  arp_ha_ext), sizeof(user_r.arp_ha_ext));
+				if (err)
+					return -EFAULT;
+			}
 			break;
 		default:
 			return -EINVAL;
@@ -1175,15 +1202,35 @@
 
 	switch (cmd) {
 	case SIOCDARP:
+		/* Delete arp does not use the value of HW address, we do not have to check whether the supplied buffer is large enough */
 		err = arp_req_delete(net, &r, dev);
 		break;
 	case SIOCSARP:
+ 		/* Our HW addr buffer may be not large enough */
+ 		/* Check the case when the interface was found by a given name and let arp_req_set to check for other cases */
+ 		if(dev && NOT_VALID_ARP_CTL(dev, (&r))) {
+ 			err = -EINVAL; /* the user gave truncated HW address */
+ 			goto out;
+ 		}
 		err = arp_req_set(net, &r, dev);
 		break;
 	case SIOCGARP:
-		err = arp_req_get(&r, dev);
-		if (!err && copy_to_user(arg, &r, sizeof(r)))
-			err = -EFAULT;
+		if(NOT_VALID_ARP_CTL(dev, (&r))) {
+			err = -EINVAL; /* the user has not given enough place to store HW address */
+			goto out;
+		}
+		memset(&r.arp_ha.sa_data[0], 0, sizeof(r.arp_ha.sa_data));
+  		err = arp_req_get(&r, dev);
+		if (!err) {
+			swap_arp_ioctl_structs(r, user_r);
+			if(is_newarpctl) {
+				memcpy(&user_r.arp_ha_ext[0], &r.arp_ha.sa_data[0]+sizeof(user_r.arp_ha.sa_data),  sizeof(user_r.arp_ha_ext));
+				err = copy_to_user(arg, &user_r, sizeof(user_r));
+			} else
+				err = copy_to_user(arg, &user_r, offsetof(struct arpreq_user,  arp_ha_ext));
+			if (err)
+				err = -EFAULT;
+		}
 		break;
 	}
 out:
@@ -1281,7 +1328,7 @@
 }
 #endif /* CONFIG_AX25 */
 
-#define HBUFFERLEN 30
+#define HBUFFERLEN 96
 
 static void arp_format_neigh_entry(struct seq_file *seq,
 				   struct neighbour *n)

--------------050407020403060601020400--
