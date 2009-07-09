Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZGIJrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZGIJrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZGIJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:47:24 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53972 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598AbZGIJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:47:23 -0400
Subject: Possible memory leaks in drivers/gpu/drm/
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 09 Jul 2009 10:47:10 +0100
Message-Id: <1247132830.11409.29.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2009 09:47:10.0906 (UTC) FILETIME=[3AFBA1A0:01CA007A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get some kmemleak reports in the drm code. The first happens when Xorg
is running:

unreferenced object 0xc2659050 (size 32):
  comm "Xorg", pid 2585, jiffies 4294902558
  backtrace:
    [<c01e0c3a>] create_object+0xfa/0x250
    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
    [<c01db2d5>] __kmalloc+0x115/0x1f0
    [<fa3a53f5>] drm_setversion+0x1c5/0x260 [drm]
    [<fa3a3612>] drm_ioctl+0x192/0x3a0 [drm]
    [<c01f1d29>] vfs_ioctl+0x79/0x90
    [<c01f1e8a>] do_vfs_ioctl+0x6a/0x5e0
    [<c01f2463>] sys_ioctl+0x63/0x70
    [<c010300c>] sysenter_do_call+0x12/0x38

It looks like this is one of the kmalloc calls in the drm_set_busid()
function (I'll do more checks tonight to see exactly which of the two
kmalloc's).

When the Xorg exits, it seems to leave behind several of these (the same
happens when glxinfo exits):

unreferenced object 0xc22b7540 (size 148):
  comm "Xorg", pid 2585, jiffies 4294902559
  backtrace:
    [<c01e0c3a>] create_object+0xfa/0x250
    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
    [<c01dac1b>] kmem_cache_alloc+0x14b/0x190
    [<c0309400>] idr_pre_get+0x50/0x70
    [<fa3a4d74>] drm_gem_handle_create+0x24/0x90 [drm]
    [<fa7f79ad>] i915_gem_create_ioctl+0x5d/0xb0 [i915]
    [<fa3a3612>] drm_ioctl+0x192/0x3a0 [drm]
    [<c01f1d29>] vfs_ioctl+0x79/0x90
    [<c01f1e8a>] do_vfs_ioctl+0x6a/0x5e0
    [<c01f2463>] sys_ioctl+0x63/0x70
    [<c010300c>] sysenter_do_call+0x12/0x38

Are they real leaks?

Thanks.

-- 
Catalin

