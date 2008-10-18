Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYJRTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYJRTIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJRTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:38238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYJRTDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:39 -0400
Date: Sat, 18 Oct 2008 11:34:31 -0700
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
       alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [patch 15/17] drm/i915: fix ioremap of a user address for non-root
	(CVE-2008-3831)
Message-ID: <20081018183431.GP14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-i915-fix-ioremap-of-a-user-address-for-non-root.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Matthias Hopf <mhopf@suse.de>

commit 4b40893918203ee1a1f6a114316c2a19c072e9bd upstream

Olaf Kirch noticed that the i915_set_status_page() function of the i915
kernel driver calls ioremap with an address offset that is supplied by
userspace via ioctl. The function zeroes the mapped memory via memset
and tells the hardware about the address. Turns out that access to that
ioctl is not restricted to root so users could probably exploit that to
do nasty things. We haven't tried to write actual exploit code though.

It only affects the Intel G33 series and newer.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -836,7 +836,7 @@ struct drm_ioctl_desc i915_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_I915_SET_VBLANK_PIPE,  i915_vblank_pipe_set, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY ),
 	DRM_IOCTL_DEF(DRM_I915_GET_VBLANK_PIPE,  i915_vblank_pipe_get, DRM_AUTH ),
 	DRM_IOCTL_DEF(DRM_I915_VBLANK_SWAP, i915_vblank_swap, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I915_HWS_ADDR, i915_set_status_page, DRM_AUTH),
+	DRM_IOCTL_DEF(DRM_I915_HWS_ADDR, i915_set_status_page, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 };
 
 int i915_max_ioctl = DRM_ARRAY_SIZE(i915_ioctls);

-- 
