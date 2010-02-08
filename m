Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab0BHVws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:52:48 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:37850 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750839Ab0BHVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:52:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Nq088N9rnhf8jXcYvnUrALOnj30R51QOrHeZtxSrcuuEMs6sXm+YEdT4+HmcLda6RDsF/qBF9CHyt/HiyNaBDleWWzUCypfewZqwGp8/NgZxOHTVsVwjgSbSkAiUdBcW;
Date: Mon, 8 Feb 2010 13:51:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jithin Emmanuel" <jithin1987@gmail.com>
Subject: Re: [Bug #15015] blank screen at random times in laptop when
 sitting idle
Message-ID: <20100208135135.0c7367b1@jbarnes-piketon>
In-Reply-To: <iuJeop2ribM.A.WL.qY1bLB@chimera>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
	<iuJeop2ribM.A.WL.qY1bLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Feb 2010 01:28:20 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15015
> Subject		: blank screen at random times in laptop when
> sitting idle Submitter	: Jithin Emmanuel <jithin1987@gmail.com>
> Date		: 2010-01-09 16:48 (30 days old)

Care to try this patch?  Just attached it to the bug too...

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 06761e4..88d52a3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -927,19 +927,28 @@ static void i8xx_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
 void i8xx_disable_fbc(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long timeout = jiffies + msecs_to_jiffies(1);
 	u32 fbc_ctl;
 
 	if (!I915_HAS_FBC(dev))
 		return;
 
+	if (!(I915_READ(FBC_CONTROL) & FBC_CTL_EN))
+		return;	/* Already off, just return */
+
 	/* Disable compression */
 	fbc_ctl = I915_READ(FBC_CONTROL);
 	fbc_ctl &= ~FBC_CTL_EN;
 	I915_WRITE(FBC_CONTROL, fbc_ctl);
 
 	/* Wait for compressing bit to clear */
-	while (I915_READ(FBC_STATUS) & FBC_STAT_COMPRESSING)
-		; /* nothing */
+	while (I915_READ(FBC_STATUS) & FBC_STAT_COMPRESSING) {
+		if (time_after(jiffies, timeout)) {
+			DRM_DEBUG_DRIVER("FBC idle timed out\n");
+			break;
+		}
+		; /* do nothing */
+	}
 
 	intel_wait_for_vblank(dev);
 
