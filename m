Return-Path: <linux-kernel-owner+w=401wt.eu-S2992911AbXCIDJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992911AbXCIDJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030860AbXCIDJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:09:15 -0500
Received: from ozlabs.org ([203.10.76.45]:45350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030844AbXCIDJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:09:14 -0500
Subject: [PATCH 2/9] lguest: bridging support in example code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173409524.32234.67.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:08:16 +1100
Message-Id: <1173409696.32234.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the --tunnet option to take a bridge name as an argument, so that
the tap interface is added to the specified bridge.  This makes it
convenient to use bridging for connecting the guest to external networks.
    
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r cff3d561d1b0 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Thu Mar 08 15:52:15 2007 +1100
+++ b/Documentation/lguest/lguest.c	Thu Mar 08 16:08:36 2007 +1100
@@ -23,7 +23,8 @@
 #include <sys/time.h>
 #include <time.h>
 #include <netinet/in.h>
-#include <linux/if.h>
+#include <net/if.h>
+#include <linux/sockios.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 #include <termios.h>
@@ -36,6 +37,7 @@ typedef uint8_t u8;
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
+#define BRIDGE_PFX "bridge:"
 
 static bool verbose;
 #define verbose(args...) \
@@ -582,20 +584,16 @@ static u32 handle_block_output(int fd, c
 	((u8)(ip >> 8)),			\
 	((u8)(ip))
 
-static void configure_device(const char *devname, u32 ipaddr,
+static void configure_device(int fd, const char *devname, u32 ipaddr,
 			     unsigned char hwaddr[6])
 {
 	struct ifreq ifr;
-	int fd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&ifr.ifr_addr;
 
 	memset(&ifr, 0, sizeof(ifr));
 	strcpy(ifr.ifr_name, devname);
 	sin->sin_family = AF_INET;
 	sin->sin_addr.s_addr = htonl(ipaddr);
-	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
-	if (fd < 0)
-		err(1, "opening IP socket");
 	if (ioctl(fd, SIOCSIFADDR, &ifr) != 0)
 		err(1, "Setting %s interface address", devname);
 	ifr.ifr_flags = IFF_UP;
@@ -724,13 +722,34 @@ static u32 str2ip(const char *ipaddr)
 	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
 }
 
-static void setup_tun_net(const char *ipaddr,
+/* adapted from libbridge */
+static void add_to_bridge(int fd, const char *if_name, const char *br_name)
+{
+	int ifidx;
+	struct ifreq ifr;
+
+	if (!*br_name)
+		errx(1, "must specify bridge name");
+
+	ifidx = if_nametoindex(if_name);
+	if (!ifidx)
+		errx(1, "interface %s does not exist!", if_name);
+
+	strncpy(ifr.ifr_name, br_name, IFNAMSIZ);
+	ifr.ifr_ifindex = ifidx;
+	if (ioctl(fd, SIOCBRADDIF, &ifr) < 0)
+		err(1, "can't add %s to bridge %s", if_name, br_name);
+}
+
+static void setup_tun_net(const char *arg,
 			  struct lguest_device_desc *descs,
 			  struct devices *devices)
 {
 	struct device *dev;
 	struct ifreq ifr;
-	int netfd;
+	int netfd, ipfd;
+	u32 ipaddr;
+	const char *br_name = NULL;
 
 	netfd = open("/dev/net/tun", O_RDWR);
 	if (netfd < 0)
@@ -748,15 +767,29 @@ static void setup_tun_net(const char *ip
 	dev->priv = malloc(sizeof(bool));
 	*(bool *)dev->priv = false;
 
+	ipfd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
+	if (ipfd < 0)
+		err(1, "opening IP socket");
+
+	if (!strncmp(BRIDGE_PFX, arg, strlen(BRIDGE_PFX))) {
+		ipaddr = INADDR_ANY;
+		br_name = arg + strlen(BRIDGE_PFX);
+		add_to_bridge(ipfd, ifr.ifr_name, br_name);
+	} else
+		ipaddr = str2ip(arg);
+
 	/* We are peer 0, rest is all NO_GUEST */
 	memset(dev->mem, 0xFF, getpagesize());
-	configure_device(ifr.ifr_name, str2ip(ipaddr), dev->mem);
+	configure_device(ipfd, ifr.ifr_name, ipaddr, dev->mem);
+	close(ipfd);
 
 	/* You will be peer 1: we should create enough jitter to randomize */
 	dev->desc->features = NET_PEERNUM|LGUEST_DEVICE_F_RANDOMNESS;
 	verbose("device %p@%p: tun net %u.%u.%u.%u\n", dev->desc,
 		(void *)(dev->desc->pfn * getpagesize()),
-		HIPQUAD(str2ip(ipaddr)));
+		HIPQUAD(ipaddr));
+	if (br_name)
+		verbose("attched to bridge: %s\n", br_name);
 }
 
 static void setup_block_file(const char *filename,
@@ -887,8 +920,8 @@ int main(int argc, char *argv[])
 
 	if (argc < 4)
 		errx(1, "Usage: lguest [--verbose] <mem> vmlinux "
-			"[--sharenet=<filename>|--tunnet=<ipaddr>|--block=<filename>"
-			"|--initrd=<filename>]... [args...]");
+			"[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)"
+			"|--block=<filename>|--initrd=<filename>]... [args...]");
 
 	zero_fd = open("/dev/zero", O_RDONLY, 0);
 	if (zero_fd < 0)
diff -r cff3d561d1b0 Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt	Thu Mar 08 15:52:15 2007 +1100
+++ b/Documentation/lguest/lguest.txt	Thu Mar 08 16:02:49 2007 +1100
@@ -77,10 +77,26 @@ Running Lguest:
   /proc/sys/net/ipv4/ip_forward".  In this example, I would configure
   eth0 inside the guest at 192.168.19.2.
 
+  Another method is to bridge the tap device to an external interface
+  using --tunnet=bridge:<bridgename>, and perhaps run dhcp on the guest
+  to obtain an IP address.  The bridge needs to be configured first:
+  this option simply adds the tap interface to it.
+  
+  A simple example on my system:
+  
+    ifconfig eth0 0.0.0.0
+    brctl addbr lg0
+    ifconfig lg0 up
+    dhclient lg0
+    
+  Then use --tunnet=bridge:lg0 when launching the guest.
+
+  See http://linux-net.osdl.org/index.php/Bridge for general information
+  on how to get bridging working.
+
 - You can also create an inter-guest network using
   "--sharenet=<filename>": any two guests using the same file are on
   the same network.  This file is created if it does not exist.
-
 
 Lguest I/O model:
 


