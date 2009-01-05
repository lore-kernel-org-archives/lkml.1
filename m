Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZAEOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZAEOvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZAEOuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:37 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53976 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZAEOug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:36 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/13] x86: unifying ways to handle multiple sets of dma mapping ops
Date: Mon,  5 Jan 2009 23:47:20 +0900
Message-Id: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the second part of the unification of ways to handle
multiple sets of dma mapping API. The whole work consists of three
patchset. This is for X86 and can be applied independently (against
tip/master).

I've submitted the first part (for IA64):

http://marc.info/?l=linux-kernel&m=123116676006794&w=2

dma_mapping_ops (or dma_ops) struct is used to handle multiple sets of
dma mapping API by X86, SPARC, and POWER. IA64 also handle multiple
sets of dma mapping API but in a very different way (some define
magic).

X86 and IA64 share VT-d and SWIOTLB code. We need several workarounds
for it because of the deference of ways to handle multiple sets of dma
mapping API (e.g., X86 people can't freely change struct
dma_mapping_ops in x86's dma-mapping.h now because it could break
IA64).  Seems POWER will use SWIOTLB code soon. I think that it's time
to unify ways to handle multiple sets of dma mapping API. After
applying the whole work, we have struct dma_map_ops
include/linux/dma-mapping.h (I also dream of changing all the archs to
use SWIOTLB in order to remove the bounce code in the block and
network stacks...).

This patchset doesn't include major changes, just converting x86's
dma_mapping_ops to use map_page and unmap_page instead of map_single
and unmap_single. Currently, x86's dma_mapping_ops uses physical
address as a map_single's argument. But it's confusing since
dma_map_single uses a virtual address argument. So I chose POWER
dma_mapping_ops scheme, which uses map_page to handle dma_map_single.

=
 arch/x86/include/asm/dma-mapping.h |   23 ++++++++++++++---------
 arch/x86/kernel/amd_iommu.c        |   16 ++++++++++------
 arch/x86/kernel/pci-calgary_64.c   |   23 +++++++++++++----------
 arch/x86/kernel/pci-gart_64.c      |   20 ++++++++++++--------
 arch/x86/kernel/pci-nommu.c        |   16 ++++++++--------
 arch/x86/kernel/pci-swiotlb_64.c   |   22 ++++++++++++++++------
 drivers/pci/intel-iommu.c          |   26 ++++++++++++++++++++++----
 7 files changed, 95 insertions(+), 51 deletions(-)



