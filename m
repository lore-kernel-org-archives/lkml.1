Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbZAMBgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbZAMBgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbZAMB3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:15 -0500
Received: from kroah.org ([198.145.64.141]:36097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758208AbZAMB3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:10 -0500
Date: Mon, 12 Jan 2009 17:27:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 18/21] AMD IOMMU: reset command buffer pointers manually
Message-ID: <20090113012729.GS4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="amd-iommu-reset-command-buffer-pointers-manually.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Upstream commit cf558d25e5c9f70fa0279c9b7b8b4aed7cae9bd4

Under special circumstances the IOMMU does not reset the head and tail
pointer of its command ringbuffer to zero when the command base is
written. This causes the IOMMU to fetch random memory and executes it as
an command. Since these commands are likely illegal IOMMU stops fetching
further commands including IOTLB flushes. This leads to completion wait
errors at boot and in some cases to data corruption and kernel crashes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -407,6 +407,10 @@ static u8 * __init alloc_command_buffer(
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
 			&entry, sizeof(entry));
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
 
 	return cmd_buf;

