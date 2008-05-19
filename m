Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYESGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYESGdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYESGd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:33:28 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:46382 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbYESGd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:33:27 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: amit.shah@qumranet.com, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
Subject: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
Date: Mon, 19 May 2008 15:31:27 +0900
Message-Id: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patchset to add per-device
dma_mapping_ops support for CONFIG_X86_64 like POWER architecture
does:

http://lkml.org/lkml/2008/5/13/36

This is against 2.6.26-rc2-mm1 (the changes since the v1 are pretty
trivial like dropping the change for v850 arch).

This enables us to cleanly fix the Calgary IOMMU issue that some
devices are not behind the IOMMU [1].

I think that per-device dma_mapping_ops support would be also helpful
for KVM people to support PCI passthrough but Andi thinks that this
makes it difficult to support the PCI passthrough (see the above
thread). So I CC'ed this to KVM camp. Comments are appreciated.

A pointer to dma_mapping_ops to struct dev_archdata is added. If the
pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
it's NULL, the system-wide dma_ops pointer is used as before.

If it's useful for KVM people, I plan to implement a mechanism to
register a hook called when a new pci (or dma capable) device is
created (it works with hot plugging). It enables IOMMUs to set up an
appropriate dma_mapping_ops per device.

The major obstacle is that dma_mapping_error doesn't take a pointer to
the device unlike other DMA operations. So x86 can't have
dma_mapping_ops per device. Note all the POWER IOMMUs use the same
dma_mapping_error function so this is not a problem for POWER but x86
IOMMUs use different dma_mapping_error functions.

The first patch adds the device argument to dma_mapping_error. The
patch is trivial but large since it touches lots of drivers and
dma-mapping.h in all the architecture.

[1] http://lkml.org/lkml/2008/5/8/423



