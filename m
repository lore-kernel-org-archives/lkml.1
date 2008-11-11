Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYKKIaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYKKIaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYKKIap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:30:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYKKIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:30:45 -0500
Date: Tue, 11 Nov 2008 00:29:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes for 2.6.27-rc5
Message-Id: <20081111002958.7620fb56.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.82.0811110811350.2182@skynet.skynet.ie>
References: <alpine.DEB.0.82.0811110811350.2182@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 08:15:26 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:

> commit 78538bf14995a136c2d9a22159ada49937359119
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Tue Nov 11 17:56:16 2008 +1000
> 
>     drm/radeon: map registers at load time
>     
>     Now that the radeon driver has suspend/resume functions, it needs to map its
>     registers at load time or it will likely crash if a suspend operation occurs
>     before the driver has been initialized.
>     
>     This patch moves the register mapping code from firstopen to load and makes
>     the mapping into a _DRM_DRIVER one so that the core won't remove it at
>     lastclose time.

Does this make the below patch obsolete?

>     Fixes (at least partially) kernel bz #11891.

A little thing: there are (or used to be) people who troll commits for
bugzilla reports to close off.  I've adopted the convention of
indicating bugzilla reports via their full URL to make those efforts
easier and to increase their accuracy.



From: Jiri Slaby <jirislaby@gmail.com>

When the driver is bound to a device and nobody opens the device node, it
will oops on suspend and resume, since it's not mapped and dev_priv->mmio
is NULL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/gpu/drm/radeon/radeon_drv.c~drm-fix-radeon-suspend-resume-oops drivers/gpu/drm/radeon/radeon_drv.c
--- a/drivers/gpu/drm/radeon/radeon_drv.c~drm-fix-radeon-suspend-resume-oops
+++ a/drivers/gpu/drm/radeon/radeon_drv.c
@@ -56,6 +56,9 @@ static int radeon_suspend(struct drm_dev
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Disable *all* interrupts */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, 0);
@@ -67,6 +70,9 @@ static int radeon_resume(struct drm_devi
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Restore interrupt registers */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, dev_priv->r500_disp_irq_reg);
_

