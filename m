Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYHZTov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYHZTov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbYHZToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:44:00 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:55756 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbYHZTn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:43:59 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Subject: [resubmit] Add GEM to i915 DRM driver
Date: Tue, 26 Aug 2008 12:43:06 -0700
Message-Id: <1219779789-8368-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series brings a long-awaited kernel memory manager to the i915
driver.  This will allow us to do correct composited OpenGL, speed up
OpenGL-based compositing, and enable framebuffer objects and other "new"
OpenGL extensions.  This patchset is also being built to enable kernel
modesetting for a non-root, flicker-free X Server.

This is a re-submit of the changes for DRM-GEM.  It relies on patches submitted
by airlied which are currently queued in linux-next.  The tree still has all
the changes required, based off of 2.6.27-rc4.

git://people.freedesktop.org/~anholt/linux-2.6 on the drm-gem-merge branch
http://cgit.freedesktop.org/~anholt/linux-2.6/log/?h=drm-gem-merge

New in this edition since the original submission:

- Exporting kmap_atomic_pfn.
  (The previous submission was slow because it was checking for the
  drm_compat.c version of this function from the external tree)
- shmem_getpage usage replaced with read_mapping_page.
- fixes for software fallbacks on tiled buffers.
- speedups for software fallbacks.
- replaced pci_read_base usage with using the MCHBAR mirror aperture
- fixed some issues on X server exit

What's not new in this edition:

Still using shmem_file_setup.  We need to be able to allocate objects from
the kernel, and didn't get any clear agreement that doing a VFS dance would be
preferable to letting us behave like other kernel subsystems and use the
function.

Still using small integers to identify our objects rather than fds.
We need more than just basic syscalls on the objects -- the alternate mmap
issue is more serious than before, for X pixmap usage.  There are also the
ioctls for cache management for software fallbacks.  And the issue of
getting high fds and large numbers of them still remained.

Still have an issue with PAT on x86_64 -- initialization fails because
ioremap() apparently has different semantics there than on x86 or non-PAT
x86_64 (if somebody has mapped the space and there's a WC MTRR, the ioremap
that defaults to UC- ends up conflicting on it and failing even though it
seems like it's not supposed to).


