Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZGPPv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZGPPv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbZGPPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:51:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17137 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbZGPPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:51:21 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH 0/3] VGA arbiter implementation (v2)
Date: Thu, 16 Jul 2009 18:48:28 +0300
Message-Id: <1247759311-6254-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 16 Jul 2009 15:49:49.0718 (UTC) FILETIME=[0D231B60:01CA062D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following is v2 of the set. It contains some minor clean ups and the additions
from Dave, mostly related with DRM.

I just reorganized a little the ideas which everyone sent and summarized them
here. The basically TODO is:

- DRM hook to disable IRQ when arbiter is on action is done. What else we need
  on DRM department (besides the hook usage that Dave is cooking)? That's a
  preliminary here:
    http://people.freedesktop.org/~airlied/vgaarb/0002-drm-add-support-to-drm-for-VGA-arbitration.patch
- make a PCI_COMMAND lock to deal with hotplug cards on drivers/pci. Also is
  it need some spinlock to deal with bridges? (Waiting Jesse's opinion).
- know exactly if VGA on/off is enough and remove the just I/O or just memory
  granularity. Alan states that it would reduce some deadlock.
- Change this hunk bellow:

 +             init_waitqueue_entry(&wait, current);
 +             add_wait_queue(&vga_wait_queue, &wait);
 +             set_current_state(interruptible ?
 +                               TASK_INTERRUPTIBLE :
 +                               TASK_UNINTERRUPTIBLE);
 +             if (signal_pending(current)) {
 +                     rc = -EINTR;
 +                     break;
 +             }
 +             schedule();
 +             remove_wait_queue(&vga_wait_queue, &wait);
 +             set_current_state(TASK_RUNNING);

 by something like:

 +             wait_event_interruptible(...)

  it's Alan's comment. Does it seems doable to everyone?


For testing purposes, I'm using posttool:
    http://cgit.freedesktop.org/~airlied/posttool/

which has the following dependencies:
    http://cgit.freedesktop.org/~vignatti/libx86/
    http://cgit.freedesktop.org/~vignatti/libpciaccess/ (vgaarb branch)


Please, comment on and send the feedbacks. Thanks,

                Tiago


Dave Airlie (1):
  drm: add support to drm for VGA arbitration.

Tiago Vignatti (2):
  vga: implements VGA arbitration on Linux
  vga: drops a documentation regarding the VGA arbiter

 Documentation/vgaarbiter.txt           |  197 ++++++
 drivers/gpu/Makefile                   |    2 +-
 drivers/gpu/drm/drm_irq.c              |   24 +
 drivers/gpu/drm/i915/i915_dma.c        |    6 +
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 drivers/gpu/drm/i915/intel_display.c   |   17 +
 drivers/gpu/drm/i915/intel_drv.h       |    1 +
 drivers/gpu/drm/radeon/r100.c          |    9 +
 drivers/gpu/drm/radeon/radeon.h        |    2 +
 drivers/gpu/drm/radeon/radeon_asic.h   |    9 +
 drivers/gpu/drm/radeon/radeon_device.c |    5 +-
 drivers/gpu/vga/Kconfig                |   10 +
 drivers/gpu/vga/Makefile               |    1 +
 drivers/gpu/vga/vgaarb.c               | 1116 ++++++++++++++++++++++++++++++++
 drivers/video/Kconfig                  |    2 +
 include/drm/drmP.h                     |    3 +
 include/linux/vgaarb.h                 |  170 +++++
 17 files changed, 1573 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/vgaarbiter.txt
 create mode 100644 drivers/gpu/vga/Kconfig
 create mode 100644 drivers/gpu/vga/Makefile
 create mode 100644 drivers/gpu/vga/vgaarb.c
 create mode 100644 include/linux/vgaarb.h

