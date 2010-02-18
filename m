Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab0BRQod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:44:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:50082 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab0BRQoa (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:44:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com
Subject: [REPOST PATCH RFC SWIOTLB 0.5] Separate address translation routines from core SWIOTLB book-keeping
Date: Thu, 18 Feb 2010 11:26:56 -0500
Message-Id: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B7D6E32.01D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the repost - I sent the earlier one to the wrong LKML email]

Fujita-san et al.

Attached is a set of ten RFC patches that separate the address translation
(virt_to_phys, virt_to_bus, etc) from the SWIOTLB library. They also enhance
the SWIOTLB library a bit.

The idea behind this set of patches is to make it possible to have separate
mechanisms for translating virtual to physical or virtual to DMA addresses
on platforms which need an SWIOTLB, and where physical != PCI bus address.

One customers of this is the pv-ops project, which can switch between
different modes of operation depending on the environment it is running in:
bare-metal or virtualized (Xen for now).

On bare-metal SWIOTLB is used when there are no hardware IOMMU. In virtualized
environment it used when PCI pass-through is enabled for the guest. The problems
with PCI pass-through is that the guest's idea of PFN's is not the real thing.
To fix that, there is translation layer for PFN->machine frame number and vice-versa.
To bubble that up to the SWIOTLB layer there are two possible solutions.

One solution has been to wholesale copy the SWIOTLB, stick it in
arch/x86/xen/swiotlb.c and modify the virt_to_phys, phys_to_virt and others
to use the Xen address translation functions. Unfortunately, since the kernel can
run on bare-metal, there would be big code overlap with the real SWIOTLB.
(git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/dom0/swiotlb-new)

Another approach, which this set of patches explores, is to abstract the
address translation and address determination functions away from the
SWIOTLB book-keeping functions. This way the core SWIOTLB library functions
are present in one place, while the address related functions are in
a separate library that can be loaded when running under non-bare-metal platform.

The set of ten patches is also accessible on:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.5

An example of how this can be utilized in both bare-metal and Xen environments
is this git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git xen-swiotlb-0.5

---

 Documentation/x86/x86_64/boot-options.txt |    6 +-
 include/linux/swiotlb.h                   |   44 ++++++-
 lib/swiotlb.c                             |  187 ++++++++++++++++++-----------
 3 files changed, 156 insertions(+), 81 deletions(-)
