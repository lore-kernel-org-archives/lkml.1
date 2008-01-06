Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYAFD7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYAFD7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYAFD7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:59:00 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39571 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYAFD66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:58:58 -0500
Date: Sat, 5 Jan 2008 22:58:16 -0500
From: Amos Waterland <apw@us.ibm.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, akpm@osdl.org
Subject: [PATCH] Fix regression in ip command line processing
Message-ID: <20080106035816.GA16459@us.ibm.com>
References: <20071226025903.GB14422@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071226025903.GB14422@verge.net.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes for ip command line processing fixed some problems
but unfortunately broke some common usage scenarios.  In current
2.6.24-rc6 the following command line results in no IP address
assignment, which is surely a regression:

 ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:off

Please find below a patch that works for all cases I can find.

Signed-off-by: Amos Waterland <apw@us.ibm.com>

---

For convenience, here are the test cases phrased as qemu invocations:

ADDRESS ASSIGNED

qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=on"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=dhcp"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=both"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=any"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::on"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::dhcp"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:off"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:on"

ADDRESS NOT ASSIGNED

qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip="
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=off"
qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::off"

---

 Documentation/nfsroot.txt |    1 +
 net/ipv4/ipconfig.c       |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/nfsroot.txt b/Documentation/nfsroot.txt
index c86dd38..1a4d199 100644
--- a/Documentation/nfsroot.txt
+++ b/Documentation/nfsroot.txt
@@ -145,6 +145,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
 		this option.
 
                   off or none: don't use autoconfiguration
+		      	       (do static IP assignment instead)
 		  on or any:   use any protocol available in the kernel
 			       (default)
 		  dhcp:        use DHCP
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 56a6757..8563b2e 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1404,8 +1404,7 @@ static int __init ic_proto_name(char *name)
 		return 1;
 	}
 	if (!strcmp(name, "off") || !strcmp(name, "none")) {
-		ic_enable = 0;
-		return 1;
+		return 0;
 	}
 #ifdef CONFIG_IP_PNP_DHCP
 	else if (!strcmp(name, "dhcp")) {
@@ -1442,10 +1441,20 @@ static int __init ip_auto_config_setup(char *addrs)
 	ic_set_manually = 1;
 	ic_enable = 1;
 
+	/*
+	 * If any dhcp, bootp etc options are set, leave autoconfig on
+	 * and skip the below static IP processing.
+	 */
 	if (ic_proto_name(addrs))
 		return 1;
 
-	/* Parse the whole string */
+	/* If no static IP is given, turn off autoconfig and bail.  */
+	if (*addrs == 0 || strcmp(addrs, "off") == 0 || strcmp(addrs, "none") == 0) {
+		ic_enable = 0;
+		return 1;
+	}
+
+	/* Parse string for static IP assignment.  */
 	ip = addrs;
 	while (ip && *ip) {
 		if ((cp = strchr(ip, ':')))
@@ -1483,7 +1492,9 @@ static int __init ip_auto_config_setup(char *addrs)
 				strlcpy(user_dev_name, ip, sizeof(user_dev_name));
 				break;
 			case 6:
-				ic_proto_name(ip);
+				if (ic_proto_name(ip) == 0 && ic_myaddr == NONE) {
+					ic_enable = 0;
+				}
 				break;
 			}
 		}
