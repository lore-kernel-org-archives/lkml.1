Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZEGWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZEGWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbZEGW1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:19804 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756346AbZEGW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470469"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/14] x86, doc: document the runtime_start and runtime_size bzImage fields
Date: Thu,  7 May 2009 15:26:58 -0700
Message-Id: <1241735222-6640-11-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Add documentation for the runtime_start and runtime_size fields;
bzImage protocol version 2.10 (0x020a).

[ Impact: documentation only ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/x86/boot.txt |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index e020366..093f838 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -50,6 +50,10 @@ Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 		pointer to single linked list of struct	setup_data.
 
+Protocol 2.10:	(Kernel 2.6.31) Added the runtime_start and
+		runtime_size fields for the post-decompression address
+		and memory requirements of the kernel.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -182,6 +186,8 @@ Offset	Proto	Name		Meaning
 024C/4	2.08+	payload_length	Length of kernel payload
 0250/8	2.09+	setup_data	64-bit physical pointer to linked list
 				of struct setup_data
+0258/4	2.10+	runtime_start	(Minimum) post-decompression address
+025C/4	2.10+	runtime_size	Minimum linear memory required
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -582,6 +588,41 @@ Protocol:	2.09+
   sure to consider the case where the linked list already contains
   entries.
 
+Field name:	runtime_start
+Type:		modify (optional, reloc)
+Offset/size:	0x258/4
+Protocol:	2.10+
+
+  For a non-relocatable kernel, this is a readonly field indicating
+  the post-decompression address of the kernel.  This will typically
+  be larger than the load address (0x100000).
+
+  For a relocatable kernel, this is a read-write field indicating the
+  *minimum* post-decompression address of the kernel.  This allows
+  unchanged behavior when a non-relocating bootloader is used.  If
+  this value is greater than the load address, this value is used; if
+  this value is smaller than the load address, the load address is
+  rounded up to the nearest multiple of the kernel_alignment field and
+  this field is ignored.
+
+  A relocating bootloader can override this field, e.g. by setting it
+  to zero, to force the load address to control the runtime address of
+  the kernel.
+
+Field name:	runtime_size
+Type:		read
+Offset/size:	0x25C/4
+Protocol:	2.10+
+
+  This field informs the boot loader of the amount of linearly
+  contiguous memory starting at the kernel decompression address (as
+  given by the appropriate combination of the load address,
+  runtime_start, and kernel_alignment) that the kernel will require
+  before it becomes aware of the memory map.  It does *not* guarantee
+  a successful boot with only this memory, but it may be a useful
+  guideline for a relocating bootloader when it comes to selecting an
+  address to load the kernel.
+
 
 **** THE IMAGE CHECKSUM
 
-- 
1.6.0.6

