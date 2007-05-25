Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXEYJGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXEYJGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXEYJGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:06:07 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:38312 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXEYJGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:06:04 -0400
Subject: Re: Badness at include/linux/slub_def.h
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0705202304530.14522@sheep.housecafe.de>
References: <Pine.LNX.4.64.0705202304530.14522@sheep.housecafe.de>
Content-Type: text/plain; charset=UTF-8
Organization: Tungsten Graphics
Date: Fri, 25 May 2007 11:05:34 +0200
Message-Id: <1180083934.19648.442.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 23:10 +0100, Christian Kujau wrote:
> 
> [41653.487050] Badness at include/linux/slub_def.h:77
> [41653.487060] Call Trace:
> [41653.487068] [ecafbcb0] [c0008d00] show_stack+0x3c/0x194 (unreliable)
> [41653.487097] [ecafbce0] [c01426d4] report_bug+0x84/0xf4
> [41653.487116] [ecafbcf0] [c0010280] program_check_exception+0xbc/0x530
> [41653.487137] [ecafbd20] [c0011f8c] ret_from_except_full+0x0/0x4c
> [41653.487154] --- Exception: 700 at get_slab+0x248/0x260
> [41653.487168]     LR = __kmalloc+0x1c/0x9c
> [41653.487176] [ecafbde0] [101dfbc8] 0x101dfbc8 (unreliable)
> [41653.487213] [ecafbe10] [c0080398] __kmalloc+0x1c/0x9c
> [41653.487227] [ecafbe30] [c01c2150] drm_rmdraw+0x26c/0x29c
> [41653.487243] [ecafbe80] [c01c2b74] drm_ioctl+0xe0/0x250
> [41653.487257] [ecafbeb0] [c00924a0] do_ioctl+0x9c/0xa8
> [41653.487273] [ecafbed0] [c0092530] vfs_ioctl+0x84/0x490
> [41653.487287] [ecafbf10] [c009297c] sys_ioctl+0x40/0x74
> [41653.487301] [ecafbf40] [c0011930] ret_from_syscall+0x0/0x38
> [41653.487315] --- Exception: c01 at 0xfd132a8
> [41653.487327]     LR = 0xfd13240

Does the patch below against the drm tree fix it? Only build tested.

---
>From f0e6bdc165cb484b8992b14172a7280f301bf513 Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Michel_D=C3=A4nzer?= <michel@tungstengraphics.com>
Date: Fri, 25 May 2007 11:02:05 +0200
Subject: Make sure the drawable code doesn't call malloc(0).


Signed-off-by: Michel Dänzer <michel@tungstengraphics.com>
---
 linux-core/drm_drawable.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/linux-core/drm_drawable.c b/linux-core/drm_drawable.c
index 0817e32..b540a0e 100644
--- a/linux-core/drm_drawable.c
+++ b/linux-core/drm_drawable.c
@@ -172,38 +172,49 @@ int drm_rmdraw(DRM_IOCTL_ARGS)
 
 		bitfield_length = idx + 1;
 
-		if (idx != id / (8 * sizeof(*bitfield)))
-			bitfield = drm_alloc(bitfield_length *
-					     sizeof(*bitfield), DRM_MEM_BUFS);
+		bitfield = NULL;
 
-		if (!bitfield && bitfield_length) {
-			bitfield = dev->drw_bitfield;
-			bitfield_length = dev->drw_bitfield_length;
+		if (bitfield_length) {
+			if (bitfield_length != dev->drw_bitfield_length)
+				bitfield = drm_alloc(bitfield_length *
+						     sizeof(*bitfield),
+						     DRM_MEM_BUFS);
+
+			if (!bitfield) {
+				bitfield = dev->drw_bitfield;
+				bitfield_length = dev->drw_bitfield_length;
+			}
 		}
 	}
 
 	if (bitfield != dev->drw_bitfield) {
 		info_length = 8 * sizeof(*bitfield) * bitfield_length;
 
-		info = drm_alloc(info_length * sizeof(*info), DRM_MEM_BUFS);
+		if (info_length) {
+			info = drm_alloc(info_length * sizeof(*info),
+					 DRM_MEM_BUFS);
 
-		if (!info && info_length) {
-			info = dev->drw_info;
-			info_length = dev->drw_info_length;
-		}
+			if (!info) {
+				info = dev->drw_info;
+				info_length = dev->drw_info_length;
+			}
+		} else
+			info = NULL;
 
 		spin_lock_irqsave(&dev->drw_lock, irqflags);
 
-		memcpy(bitfield, dev->drw_bitfield, bitfield_length *
-		       sizeof(*bitfield));
+		if (bitfield)
+			memcpy(bitfield, dev->drw_bitfield, bitfield_length *
+			       sizeof(*bitfield));
 		drm_free(dev->drw_bitfield, sizeof(*bitfield) *
 			 dev->drw_bitfield_length, DRM_MEM_BUFS);
 		dev->drw_bitfield = bitfield;
 		dev->drw_bitfield_length = bitfield_length;
 
 		if (info != dev->drw_info) {
-			memcpy(info, dev->drw_info, info_length *
-			       sizeof(*info));
+			if (info)
+				memcpy(info, dev->drw_info, info_length *
+				       sizeof(*info));
 			drm_free(dev->drw_info, sizeof(*info) *
 				 dev->drw_info_length, DRM_MEM_BUFS);
 			dev->drw_info = info;
-- 
1.5.2-rc3.GIT





-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

