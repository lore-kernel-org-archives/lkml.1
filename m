Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbZCQLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbZCQLjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbZCQLjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:39:13 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43888 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367AbZCQLjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:39:11 -0400
Message-ID: <49BF8BB3.1060606@vflare.org>
Date: Tue, 17 Mar 2009 17:08:27 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3]: documentation
References: <49BF8ABC.6040805@vflare.org>
In-Reply-To: <49BF8ABC.6040805@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090316-0, 16-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Documentation/blockdev/00-INDEX      |    2 +
  Documentation/blockdev/compcache.txt |   67 ++++++++++++++++++++++++++++++++++
  Documentation/kernel-parameters.txt  |    9 +++++
  3 files changed, 78 insertions(+), 0 deletions(-)

Documentation on how to use compcache module.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index 86f054c..d53dec0 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -4,6 +4,8 @@ README.DAC960
  	- info on Mylex DAC960/DAC1100 PCI RAID Controller Driver for Linux.
  cciss.txt
  	- info, major/minor #'s for Compaq's SMART Array Controllers.
+compcache.txt
+	- short guide on how to setup compressed RAM swap device.
  cpqarray.txt
  	- info on using Compaq's SMART2 Intelligent Disk Array Controllers.
  floppy.txt
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

