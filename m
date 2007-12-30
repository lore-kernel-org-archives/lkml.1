Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXL3HOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXL3HOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXL3HK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:59478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 17/52] KVM: VMX: Force seg.base == (seg.sel << 4) in real  mode
Date: Sun, 30 Dec 2007 09:10:03 +0200
Message-Id: <1198998638-22713-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Ensure that segment.base == segment.selector << 4 when entering the real
mode on Intel so that the CPU will not bark at us.  This fixes some old
protected mode demo from http://www.x86.org/articles/pmbasics/tspec_a1_doc.htm.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c23f399..fbe792d 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1165,7 +1165,8 @@ static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
 	save->base = vmcs_readl(sf->base);
 	save->limit = vmcs_read32(sf->limit);
 	save->ar = vmcs_read32(sf->ar_bytes);
-	vmcs_write16(sf->selector, vmcs_readl(sf->base) >> 4);
+	vmcs_write16(sf->selector, save->base >> 4);
+	vmcs_write32(sf->base, save->base & 0xfffff);
 	vmcs_write32(sf->limit, 0xffff);
 	vmcs_write32(sf->ar_bytes, 0xf3);
 }
-- 
1.5.3.7

