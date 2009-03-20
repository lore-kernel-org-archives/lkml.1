Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZCTOPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZCTOPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZCTOPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:15:24 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:50541 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbZCTOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:15:23 -0400
Message-ID: <49C3A4B0.3050503@vflare.org>
Date: Fri, 20 Mar 2009 19:44:08 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] compcache documentation
References: <49C3A31D.6070208@vflare.org>
In-Reply-To: <49C3A31D.6070208@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090319-0, 19-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Documentation/blockdev/compcache.txt |   67 ++++++++++++++++++++++++++++++++++
  Documentation/kernel-parameters.txt  |    9 +++++
  init/Kconfig                         |    6 +++
  3 files changed, 82 insertions(+), 0 deletions(-)

Documentation on how to use compcache module.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/Documentation/blockdev/compcache.txt b/Documentation/blockdev/compcache.txt
new file mode 100644
index 0000000..46c33a5
--- /dev/null
+++ b/Documentation/blockdev/compcache.txt
@@ -0,0 +1,67 @@
+compcache: Compressed RAM swap device
+-------------------------------------
+
+Project home: http://code.google.com/p/compcache/
+
+This module creates RAM based block device (named ramzswap0) which acts
+as swap disk. Pages swapped to this disk are compressed and stored in
+memory itself.
+
+It uses these components:
+ - xvMalloc: memory allocator (xvmalloc.ko)
+ - LZO1X: de/compressor: (lzo_compress.ko, lzo_decompress.ko)
+
+Usage:
+ - modprobe compcache [memlimit_kb=<val>|disksize_kb=<val>] [backing_dev=<dev>]
+
+   memlimit_kb: This param is applicable only when backing_dev is given.
+	It is limit on amount compressed data stored in memory. Any
+	additional data is forwarded to backing_dev. It cannot be greater
+	than backing device size. If missing or 0, default value is used:
+	15% of RAM or backing device size, whichever is smaller.
+
+   disksize_kb: This param is applicable only when backing_dev is not given.
+	It is limit on amount of *uncompressed* worth of data stored in
+	memory. For e.g. disksize_kb=1024 means it can hold 1024kb worth of
+	uncompressed data even if this data compresses to just, say, 100kb.
+	If missing or 0, default value is used: 25% of RAM.
+
+   backing_dev: This is block device to be used as backing store for compcache.
+	It must be a valid swap partition. We move data to this device when we
+	encounter incompressible page or memlimit is reached. TODO: we may also
+	move some pages from compcache to this device in case system is really
+	low on memory.
+	This device is not directly visible to kernel as a swap device
+	(/proc/swaps will only show /dev/ramzswap0 and not this device).
+	Managing this backing device is the job of compcache module.
+
+Examples:
+	1) modprobe compcache memlimit_kb=10240 backing_dev=/dev/sda2
+	sets compcache limit as 10MB and /dev/sda2 as backing swap device.
+	NOTE: here /dev/sda2 is a valid swap partition.
+
+	2) modprobe compcache backing_dev=/dev/sda2
+	same as (1) but memlimit is set to default: 15% of RAM or size of
+	backing swap device, whichever is smaller.
+
+	3) modprobe compcache disksize_kb=10240
+	sets compcache disk size as 10MB.
+
+	4) modprobe compcache.ko
+	same as (3) but compcache disk size will be set to default:
+	25% of RAM size.
+
+	Once module is loaded, activate this swap with highest priority:
+	swapon /dev/ramzswap0 -p 100
+	(-p param set swap priority)
+
+Notes:
+ - compcache stats are exported via /proc/compcache
+ - If you give non-swap partition as backing_dev, nothing bad will happen -
+   swapon will simply fail to recognize /dev/ramzswap0 as swap partition.
+   So, in this case, unload the module and reload with correct backing_dev.
+
+Please report any problems to:
+
+Nitin Gupta
+ngupta@vflare.org
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..a23f0ae 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -414,6 +414,15 @@ and is between 256 and 4096 characters. It is defined in the file
  			possible to determine what the correct size should be.
  			This option provides an override for these situations.

+	compcache.memlimit_kb=
+			See Documentation/blockdev/compcache.txt.
+
+	compcache.disksize_kb=
+			See Documentation/blockdev/compcache.txt.
+
+	compcache.backing_dev=
+			See Documentation/blockdev/compcache.txt.
+
  	security=	[SECURITY] Choose a security module to enable at boot.
  			If this boot parameter is not specified, only the first
  			security module asking for security registration will be
diff --git a/init/Kconfig b/init/Kconfig
index 6a5c5fe..fa41598 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -930,6 +930,12 @@ config SLOB

  endchoice

+config XVMALLOC
+	tristate "xvMalloc memory allocator"
+	help
+	   This is a simple, low fragmentation, O(1) allocator.
+	   Details: http://code.google.com/p/compcache/wiki/xvMalloc
+
  config PROFILING
  	bool "Profiling support (EXPERIMENTAL)"
  	help
