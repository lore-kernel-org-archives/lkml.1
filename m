Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbYKCQgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbYKCQgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYKCQgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:36:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:39785 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbYKCQgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=cLJu+YZnWydhyfC6INMiazOVFo8FYn0cSLQGYrTKKpgvYWQOQdEF9xPgtOM1a0pt/T
         eZ4fzvfvpSyEK0cQ3fWbxtpiOAQJH7XOS8IK8oiL1JESoW4her97xv7n0Qe/FTEtn/eb
         csZwK5aL3DON2GMLZOzkmLSbCdXbBQAaTpxtk=
Message-ID: <490F281C.60800@gmail.com>
Date: Mon, 03 Nov 2008 18:34:36 +0200
From: Constantine Gavrilov <constantine.gavrilov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080417 Fedora/1.1.9-2.fc7 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: general@lists.openfabrics.org
Subject: Re: patch: support long (above 14 bytes) HW addresses in arp_ioctl
References: <490EDBDD.1030104@gmail.com>
In-Reply-To: <490EDBDD.1030104@gmail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050104020201030204020600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050104020201030204020600
Content-Type: multipart/mixed;
 boundary="------------040409000602020404090802"

This is a multi-part message in MIME format.
--------------040409000602020404090802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updated version of the patch uses MAX_ADDR_LEN from netdevice.h as the 
maximal length of MAC address.

Constantine Gavrilov wrote:
> While working with OFED infiniband stack that uses 20 byte long HW 
> addresses for IP over IB, I have paid attention to the following  
> arp_ioctl problem.
>
> The ioctl uses a data structure that limits a length of HW address to 
> 14 bytes. The IP stack and the arp cache code do not have that 
> limitation. This leads to the following problems:
>
> * arp_ioctl cannot be used to set, get, or delete arp entries for 
> those adapters that have HW addresses longer than 14 bytes
> * arp_ioctl will corrupt the kernel and user memory when this ioctl is 
> used on the adapters that have HW addresses longer that 14 bytes.  
> This is because when copying the HW address, the arp_ioctl code copies 
> dev->addr_len bytes without checking that addr_len is not above 14 
> bytes. This is done both for copy_to_user() and memcpy() calls on 
> kernel data structures allocated on stack. The memcpy() call in 
> particular, will corrupt kernel stack.
>
> Attached please find the patch that fixes both problems. In addition, 
> the patch changes the maximal number of bytes for HW address that will 
> be seen in /proc/net/arp from ~10 to ~30. Without the last change, 
> output of /proc/net/arp truncates the the large MAC entries, which 
> makes the arp utility useless.
>
> The patch does not change the existing ABI but extends it.  The kernel 
> structure used in arp_ioctl calls is changed to support larger 
> addresses, while the user-space structure is extended by appending 
> extra-space to the end of the structure if ATF_NEWARPCTL -- a new 
> flag  -- is set in arp_flags of existing user-space structure. This 
> allows avoiding big changes to the existing code while preserving the 
> ABI compatibility.
>

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



--------------040409000602020404090802
Content-Type: text/x-patch;
 name="arp_ioctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arp_ioctl.patch"

--- include/linux/if_arp.h.orig	2008-10-10 00:13:53.000000000 +0200
+++ include/linux/if_arp.h	2008-11-03 18:29:14.000000000 +0200
@@ -99,14 +99,27 @@
 #define	ARPOP_InREPLY	9		/* InARP reply			*/
 #define	ARPOP_NAK	10		/* (ATM)ARP NAK			*/
 
+struct hwaddr {
+  sa_family_t	sa_family;		/* address family, AF_xxx       */
+  char		sa_data[MAX_ADDR_LEN];	/* 32 bytes of HW address	*/
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
+  char			arp_ha_ext[MAX_ADDR_LEN-14]; /* extended part of HW address */
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

--------------040409000602020404090802--

--------------ms050104020201030204020600
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIP9jCC
BSwwggSVoAMCAQICEDqcN60eyFMWG0XIVQBLNZgwDQYJKoZIhvcNAQEFBQAwgcExCzAJBgNV
BAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjE8MDoGA1UECxMzQ2xhc3MgMiBQdWJs
aWMgUHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEcyMTowOAYDVQQLEzEoYykg
MTk5OCBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMB4XDTAzMDUwNjAwMDAwMFoXDTEzMDUwNTIzNTk1
OVowgfkxCzAJBgNVBAYTAlVTMTQwMgYDVQQKEytJbnRlcm5hdGlvbmFsIEJ1c2luZXNzIE1h
Y2hpbmVzIENvcnBvcmF0aW9uMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTsw
OQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAo
YykwMzEwMC4GA1UECxMnQ2xhc3MgMiBPblNpdGUgSW5kaXZpZHVhbCBTdWJzY3JpYmVyIENB
MSQwIgYDVQQDExtJQk0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwgZ8wDQYJKoZIhvcNAQEB
BQADgY0AMIGJAoGBANVnrTXdoH79V2HWnacXy7mjjSNcnOi3Z+cXSBh9uSDhCLAUUeuvoHub
uA5ImrJI5k/dA+Q0L+WNzR7OZr4TRpw3DOksYS/0o+RZ5+luJ7ltXcdVgsHU6qqHDpvF1hAe
gqpNz670JVVfUs4ThC1AafMIBHwmJbqFG4Iy39OH37oBAgMBAAGjggHpMIIB5TASBgNVHRMB
Af8ECDAGAQH/AgEAMEQGA1UdIAQ9MDswOQYLYIZIAYb4RQEHFwIwKjAoBggrBgEFBQcCARYc
aHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYTA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8v
Y3JsLnZlcmlzaWduLmNvbS9wY2EyLWcyLmNybDALBgNVHQ8EBAMCAQYwEQYJYIZIAYb4QgEB
BAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEyNzAdBgNV
HQ4EFgQUkcFzsHPV2ZJ0Z80b8VEUNDG2LFowgegGA1UdIwSB4DCB3aGBx6SBxDCBwTELMAkG
A1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMTwwOgYDVQQLEzNDbGFzcyAyIFB1
YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzIxOjA4BgNVBAsTMShj
KSAxOTk4IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxHzAdBgNV
BAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmuCEQC5L2DMiJ+hekYJuFtwbIqvMA0GCSqGSIb3
DQEBBQUAA4GBAJcMUE/GM7DSGWSfEaUELX8FdU5Ug5WUfJVLTc4s5xDj+d9P/sxo39ofCYcy
BrVFpessapDKDJKKCu6zbSNwKStMN7smU6TYiyT2FP216Adb5wsu94gxblObFoms2qG/BuGH
bFxtbIBAiCNlFcRk69rPUGu/EOvQeUAR+Ub1NkjPMIIFXzCCBMigAwIBAgIQaFAIhYYgYEsq
nrw31X9CgjANBgkqhkiG9w0BAQUFADCB+TELMAkGA1UEBhMCVVMxNDAyBgNVBAoTK0ludGVy
bmF0aW9uYWwgQnVzaW5lc3MgTWFjaGluZXMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlZlcmlT
aWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3
dy52ZXJpc2lnbi5jb20vcnBhIChjKTAzMTAwLgYDVQQLEydDbGFzcyAyIE9uU2l0ZSBJbmRp
dmlkdWFsIFN1YnNjcmliZXIgQ0ExJDAiBgNVBAMTG0lCTSBDZXJ0aWZpY2F0aW9uIEF1dGhv
cml0eTAeFw0wODA5MTgwMDAwMDBaFw0wOTA5MTgyMzU5NTlaMIGMMS4wLAYDVQQKFCVJbnRl
cm5hdGlvbmFsIEJ1c2luZXNzIE1hY2hpbmVzIENvcnAuMR0wGwYDVQQDDBRDb25zdGFudGlu
ZSBHYXZyaWxvdjEZMBcGCgmSJomT8ixkAQEUCTYxNjk3MDc1NjEgMB4GCSqGSIb3DQEJARYR
Y29uc3RnQGlsLmlibS5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKfCdo9sxxSB
edOHFTpVJytkqhVg2C7ETS2A9LL95g+g9JgLV9TtGy5p03OYyDiCvmT/YHdvCjDrrhTup5u6
/OM95skSaj0mEMsJe/an/6j4+hzrRMgvy6S6ufhG4rlM5h9YiweW4/ES2EsF9ObThTcXOFIU
Nepj2anc7ZP0vUB/AgMBAAGjggJRMIICTTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIFoDBmBgNV
HR8EXzBdMFugWaBXhlVodHRwOi8vb25zaXRlY3JsLnZlcmlzaWduLmNvbS9JbnRlcm5hdGlv
bmFsQnVzaW5lc3NNYWNoaW5lc0NvcnBDb3Jwb3JhdGVDSU8vTGF0ZXN0Q1JMMIIBKQYDVR0g
BIIBIDCCARwwggEYBgtghkgBhvhFAQcXAjCCAQcwKwYIKwYBBQUHAgEWH2h0dHBzOi8vd3d3
LnZlcmlzaWduLmNvbS9ycGEta3IwgdcGCCsGAQUFBwICMIHKGoHHTm90aWNlIFRleHQ9Tk9U
SUNFOiBQcml2YXRlIGtleSBtYXkgYmUgcmVjb3ZlcmVkIGJ5IFZlcmlTaWduJ3MgY3VzdG9t
ZXIgd2hvIG1heSBiZSBhYmxlIHRvIGRlY3J5cHQgbWVzc2FnZXMgeW91IHNlbmQgdG8gY2Vy
dGlmaWNhdGUgaG9sZGVyLiAgVXNlIGlzIHN1YmplY3QgdG8gdGVybXMgYXQgaHR0cHM6Ly93
d3cudmVyaXNpZ24uY29tL3JwYS1rcjAfBgNVHSMEGDAWgBSRwXOwc9XZknRnzRvxURQ0MbYs
WjAdBgNVHQ4EFgQUx3MFxOO70PPRWrLUwhPw39hEQxwwLAYDVR0RBCUwI6AhBgorBgEEAYI3
FAIDoBMMEWNvbnN0Z0BpbC5pYm0uY29tMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDARBglghkgBhvhCAQEEBAMCBaAwDQYJKoZIhvcNAQEFBQADgYEA0l10lAaXo1dIph7JGciR
FfF4vuh/8OfQu1qucCMT0NHM2gcx2edRZAM5Q7LhtzQzTj9veMEodczS6AoabmxU8Sn34lE6
nxtGOJ1+V30JGVAfxsxyKRYPimYoui5YjRUjpnFbxZ+qG56E4Xo21A92eo2Yx0qEQmOal780
2C05qSQwggVfMIIEyKADAgECAhBoUAiFhiBgSyqevDfVf0KCMA0GCSqGSIb3DQEBBQUAMIH5
MQswCQYDVQQGEwJVUzE0MDIGA1UEChMrSW50ZXJuYXRpb25hbCBCdXNpbmVzcyBNYWNoaW5l
cyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazE7MDkGA1UE
CxMyVGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEgKGMpMDMx
MDAuBgNVBAsTJ0NsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTEkMCIG
A1UEAxMbSUJNIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA4MDkxODAwMDAwMFoXDTA5
MDkxODIzNTk1OVowgYwxLjAsBgNVBAoUJUludGVybmF0aW9uYWwgQnVzaW5lc3MgTWFjaGlu
ZXMgQ29ycC4xHTAbBgNVBAMMFENvbnN0YW50aW5lIEdhdnJpbG92MRkwFwYKCZImiZPyLGQB
ARQJNjE2OTcwNzU2MSAwHgYJKoZIhvcNAQkBFhFjb25zdGdAaWwuaWJtLmNvbTCBnzANBgkq
hkiG9w0BAQEFAAOBjQAwgYkCgYEAp8J2j2zHFIF504cVOlUnK2SqFWDYLsRNLYD0sv3mD6D0
mAtX1O0bLmnTc5jIOIK+ZP9gd28KMOuuFO6nm7r84z3myRJqPSYQywl79qf/qPj6HOtEyC/L
pLq5+EbiuUzmH1iLB5bj8RLYSwX05tOFNxc4UhQ16mPZqdztk/S9QH8CAwEAAaOCAlEwggJN
MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgWgMGYGA1UdHwRfMF0wW6BZoFeGVWh0dHA6Ly9vbnNp
dGVjcmwudmVyaXNpZ24uY29tL0ludGVybmF0aW9uYWxCdXNpbmVzc01hY2hpbmVzQ29ycENv
cnBvcmF0ZUNJTy9MYXRlc3RDUkwwggEpBgNVHSAEggEgMIIBHDCCARgGC2CGSAGG+EUBBxcC
MIIBBzArBggrBgEFBQcCARYfaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYS1rcjCB1wYI
KwYBBQUHAgIwgcoagcdOb3RpY2UgVGV4dD1OT1RJQ0U6IFByaXZhdGUga2V5IG1heSBiZSBy
ZWNvdmVyZWQgYnkgVmVyaVNpZ24ncyBjdXN0b21lciB3aG8gbWF5IGJlIGFibGUgdG8gZGVj
cnlwdCBtZXNzYWdlcyB5b3Ugc2VuZCB0byBjZXJ0aWZpY2F0ZSBob2xkZXIuICBVc2UgaXMg
c3ViamVjdCB0byB0ZXJtcyBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhLWtyMB8G
A1UdIwQYMBaAFJHBc7Bz1dmSdGfNG/FRFDQxtixaMB0GA1UdDgQWBBTHcwXE47vQ89FastTC
E/Df2ERDHDAsBgNVHREEJTAjoCEGCisGAQQBgjcUAgOgEwwRY29uc3RnQGlsLmlibS5jb20w
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBEGCWCGSAGG+EIBAQQEAwIFoDANBgkq
hkiG9w0BAQUFAAOBgQDSXXSUBpejV0imHskZyJEV8Xi+6H/w59C7Wq5wIxPQ0czaBzHZ51Fk
AzlDsuG3NDNOP294wSh1zNLoChpubFTxKffiUTqfG0Y4nX5XfQkZUB/GzHIpFg+KZii6LliN
FSOmcVvFn6obnoThejbUD3Z6jZjHSoRCY5qXvzTYLTmpJDGCBLcwggSzAgEBMIIBDjCB+TEL
MAkGA1UEBhMCVVMxNDAyBgNVBAoTK0ludGVybmF0aW9uYWwgQnVzaW5lc3MgTWFjaGluZXMg
Q29ycG9yYXRpb24xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsT
MlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhIChjKTAzMTAw
LgYDVQQLEydDbGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExJDAiBgNV
BAMTG0lCTSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIQaFAIhYYgYEsqnrw31X9CgjAJBgUr
DgMCGgUAoIIC/TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0w
ODExMDMxNjM0MzZaMCMGCSqGSIb3DQEJBDEWBBTdRSfROOoB6ru2amHUCjdnPlCuQjBSBgkq
hkiG9w0BCQ8xRTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIB
QDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCCASEGCSsGAQQBgjcQBDGCARIwggEOMIH5MQsw
CQYDVQQGEwJVUzE0MDIGA1UEChMrSW50ZXJuYXRpb25hbCBCdXNpbmVzcyBNYWNoaW5lcyBD
b3Jwb3JhdGlvbjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazE7MDkGA1UECxMy
VGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEgKGMpMDMxMDAu
BgNVBAsTJ0NsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTEkMCIGA1UE
AxMbSUJNIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AhBoUAiFhiBgSyqevDfVf0KCMIIBIwYL
KoZIhvcNAQkQAgsxggESoIIBDjCB+TELMAkGA1UEBhMCVVMxNDAyBgNVBAoTK0ludGVybmF0
aW9uYWwgQnVzaW5lc3MgTWFjaGluZXMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlZlcmlTaWdu
IFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52
ZXJpc2lnbi5jb20vcnBhIChjKTAzMTAwLgYDVQQLEydDbGFzcyAyIE9uU2l0ZSBJbmRpdmlk
dWFsIFN1YnNjcmliZXIgQ0ExJDAiBgNVBAMTG0lCTSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eQIQaFAIhYYgYEsqnrw31X9CgjANBgkqhkiG9w0BAQEFAASBgBORXGdTzJELchq9hr+Es42A
YedV8fHmIcTAUv/+w+ossxEkkV5r2xkhSyuhprtTgmw65NN247uQ3QASvkKSNoyNrQDLOJUN
Z6QqXBpmmXo3xOBE+i23M9aTH/Y9k+4iBKSTvNfjKpKPbpcMikkImukeze2RN2WrY0PQA8EG
rt51AAAAAAAA
--------------ms050104020201030204020600--
