Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbYBGTQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbYBGTQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbYBGTPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:15:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:54039 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762022AbYBGTPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:15:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,317,1199692800"; 
   d="scan'208";a="257030606"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: out-of-bounds array index
Date: Thu, 7 Feb 2008 11:15:20 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20080207185642.GN15220@kernel.dk>
In-Reply-To: <20080207185642.GN15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071115.20501.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2008 10:56 am Jens Axboe wrote:
> Hi,
>
> Just saw this from gcc:
>
> drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
> drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
> bounds
>   CC [M]  drivers/char/drm/i915_dma.o
> drivers/char/drm/i915_drv.c: In function ?i915_resume?:
> drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
> bounds
>
> It's this code:
>
>         dev_priv->saveGR[0x18] =
>                 i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
>
> which looks legit, since saveGR is
>
>         u8 saveGR[24];
>
> It has been introduced by commit
> ba8bbcf6ff4650712f64c0ef61139c73898e2165, which seems to be you Jesse.

Just a silly off by one, don't know why I didn't catch it earlier.  I'll push 
the fix to the drm tree.  Linus, you may want to take it in parallel.

Jesse

Make sure we have enough room for all the GR registers or we'll end up 
clobbering the AR index register (which should actually be harmless unless 
the BIOS is making an assumption about it).

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
index 37bbf67..f8308bf 100644
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -187,7 +187,7 @@ typedef struct drm_i915_private {
 	u32 saveSWF2[3];
 	u8 saveMSR;
 	u8 saveSR[8];
-	u8 saveGR[24];
+	u8 saveGR[25];
 	u8 saveAR_INDEX;
 	u8 saveAR[20];
 	u8 saveDACMASK;
