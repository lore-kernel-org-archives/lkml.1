Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXEDO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXEDO5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXEDO5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:57:49 -0400
Received: from ozlabs.org ([203.10.76.45]:48250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbXEDO5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:57:48 -0400
Subject: [PATCH 1/3] Documentation and example updates
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Tony Breeds <tony@bakeyournoodle.com>,
       WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:57:18 +1000
Message-Id: <1178290638.23670.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Example code: old libc headers don't have SIOCBRADDIF, and old zlibs
   don't have gzdirect() -- it's a sanity check anyway.
2) Some people don't build in their source directories, so .config
   isn't there (thanks to Tony Breeds <tony@bakeyournoodle.com>).
3) Point out that guest and host kernel are usually the same.
4) Set the "no checksum" option on the tun device as a minor optimization.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 Documentation/lguest/Makefile   |    9 ++++++++-
 Documentation/lguest/lguest.c   |    6 ++++--
 Documentation/lguest/lguest.txt |    8 ++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

===================================================================
--- a/Documentation/lguest/Makefile
+++ b/Documentation/lguest/Makefile
@@ -1,7 +1,14 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
 
+# For those people that have a separate object dir, look there for .config
+KBUILD_OUTPUT := ../..
+ifdef O
+  ifeq ("$(origin O)", "command line")
+    KBUILD_OUTPUT := $(O)
+  endif
+endif
 # We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
-include ../../.config
+include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -40,6 +40,9 @@ typedef uint8_t u8;
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
 #define BRIDGE_PFX "bridge:"
+#ifndef SIOCBRADDIF
+#define SIOCBRADDIF	0x89a2		/* add interface to bridge      */
+#endif
 
 static bool verbose;
 #define verbose(args...) \
@@ -166,8 +169,6 @@ static unsigned long unpack_bzimage(int 
 	void *img = (void *)0x100000;
 
 	f = gzdopen(fd, "rb");
-	if (gzdirect(f))
-		errx(1, "did not find correct gzip header");
 	while ((ret = gzread(f, img + len, 65536)) > 0)
 		len += ret;
 	if (ret < 0)
@@ -820,6 +821,7 @@ static void setup_tun_net(const char *ar
 	strcpy(ifr.ifr_name, "tap%d");
 	if (ioctl(netfd, TUNSETIFF, &ifr) != 0)
 		err(1, "configuring /dev/net/tun");
+	ioctl(netfd, TUNSETNOCSUM, 1);
 
 	/* You will be peer 1: we should create enough jitter to randomize */
 	dev = new_device(devices, LGUEST_DEVICE_T_NET, 1,
===================================================================
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -23,7 +23,10 @@ Developer features:
 
 Running Lguest:
 
-- You will need to configure your kernel with the following options:
+- Lguest runs the same kernel as guest and host.  You can configure
+  them differently, but usually it's easiest not to.
+
+  You will need to configure your kernel with the following options:
 
   CONFIG_HIGHMEM64G=n ("High Memory Support" "64GB")[1]
   CONFIG_TUN=y/m ("Universal TUN/TAP device driver support")
@@ -35,7 +38,8 @@ Running Lguest:
   CONFIG_HZ=100 ("Timer frequency")[2]
 
 - A tool called "lguest" is available in this directory: type "make"
-  to build it.
+  to build it.  If you didn't build your kernel in-tree, use "make
+  O=<builddir>".
 
 - Create or find a root disk image.  There are several useful ones
   around, such as the xm-test tiny root image at


