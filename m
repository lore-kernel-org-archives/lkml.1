Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZCXTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZCXTWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZCXTUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:20:42 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:54723 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZCXTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R5BWFBa4uYKobuKqE8VRdizTC5D+sy2LDSt6wYcd+tuL9KPP4h4JM4c2u2ro3kpj4v
         R4pabVtl3QxNm3CcCQO5i6q/W6ZLzfUYQT93XX9A1O53YSHbx1ED6j8dz97rXe/VOa7T
         sEmvWmFqEBESE/fuq/WQ9dapAuh2Uona6KjDI=
Message-ID: <49C93205.2040209@vflare.org>
Date: Wed, 25 Mar 2009 00:48:29 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ramzswap documentation
References: <49C92E14.5060802@vflare.org>
In-Reply-To: <49C92E14.5060802@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Documentation/blockdev/00-INDEX     |    2 +
  Documentation/blockdev/ramzswap.txt |   67 +++++++++++++++++++++++++++++++++++
  Documentation/kernel-parameters.txt |    9 +++++
  3 files changed, 78 insertions(+), 0 deletions(-)

Documentation on how to use ramzswap module.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index 86f054c..8751488 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -4,6 +4,8 @@ README.DAC960
  	- info on Mylex DAC960/DAC1100 PCI RAID Controller Driver for Linux.
  cciss.txt
  	- info, major/minor #'s for Compaq's SMART Array Controllers.
+ramzswap.txt
+	- short guide on how to setup compressed RAM swap device.
  cpqarray.txt
  	- info on using Compaq's SMART2 Intelligent Disk Array Controllers.
  floppy.txt
diff --git a/Documentation/blockdev/ramzswap.txt b/Documentation/blockdev/ramzswap.txt
new file mode 100644
index 0000000..11d48fb
--- /dev/null
+++ b/Documentation/blockdev/ramzswap.txt
@@ -0,0 +1,67 @@
+ramzswap: Compressed RAM swap device
+------------------------------------
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
+ - modprobe ramzswap [memlimit_kb=<val>|disksize_kb=<val>] [backing_swap=<dev>]
+
+   memlimit_kb: This param is applicable only when backing_swap is given.
+	It is limit on amount compressed data stored in memory. Any
+	additional data is forwarded to backing_swap. It cannot be greater
+	than backing device size. If missing or 0, default value is used:
+	15% of RAM or backing device size, whichever is smaller.
+
+   disksize_kb: This param is applicable only when backing_swap is not given.
+	It is limit on amount of *uncompressed* worth of data stored in
+	memory. For e.g. disksize_kb=1024 means it can hold 1024kb worth of
+	uncompressed data even if this data compresses to just, say, 100kb.
+	If missing or 0, default value is used: 25% of RAM.
+
+   backing_swap: This is block device to be used as backing store for ramzswap.
+	It must be a valid swap partition. We move data to this device when we
+	encounter incompressible page or memlimit is reached. TODO: we may also
+	move some pages from ramzswap to this device in case system is really
+	low on memory.
+	This device is not directly visible to kernel as a swap device
+	(/proc/swaps will only show /dev/ramzswap0 and not this device).
+	Managing this backing device is the job of ramzswap module.
+
+Examples:
+	1) modprobe ramzswap memlimit_kb=10240 backing_swap=/dev/sda2
+	sets ramzswap limit as 10MB and /dev/sda2 as backing swap device.
+	NOTE: here /dev/sda2 is a valid swap partition.
+
+	2) modprobe ramzswap backing_swap=/dev/sda2
+	same as (1) but memlimit is set to default: 15% of RAM or size of
+	backing swap device, whichever is smaller.
+
+	3) modprobe ramzswap disksize_kb=10240
+	sets ramzswap disk size as 10MB.
+
+	4) modprobe ramzswap.ko
+	same as (3) but ramzswap disk size will be set to default:
+	25% of RAM size.
+
+	Once module is loaded, activate this swap with highest priority:
+	swapon /dev/ramzswap0 -p 100
+	(-p param set swap priority)
+
+Notes:
+ - ramzswap stats are exported via /proc/ramzswap
+ - If you give non-swap partition as backing_swap, nothing bad will happen -
+   swapon will simply fail to recognize /dev/ramzswap0 as swap partition.
+   So, in this case, unload the module and reload with correct backing_swap.
+
+Please report any problems to:
+
+Nitin Gupta
+ngupta@vflare.org
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..90c0d87 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -414,6 +414,15 @@ and is between 256 and 4096 characters. It is defined in the file
  			possible to determine what the correct size should be.
  			This option provides an override for these situations.

+	ramzswap.memlimit_kb=
+			See Documentation/blockdev/ramzswap.txt.
+
+	ramzswap.disksize_kb=
+			See Documentation/blockdev/ramzswap.txt.
+
+	ramzswap.backing_swap=
+			See Documentation/blockdev/ramzswap.txt.
+
  	security=	[SECURITY] Choose a security module to enable at boot.
  			If this boot parameter is not specified, only the first
  			security module asking for security registration will be

