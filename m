Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbZJMRCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbZJMRCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760498AbZJMRCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:02:39 -0400
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:51894 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753757AbZJMRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:02:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Fs6YiBgmlKhImVh+wWb5Fb869eVSBedDjDsgE62E9DVO/4sJqm3qNoX+A2s2JgMwJv4sEF62F5u4ABjse3sl7Eb6WDCYLpQAKjJHhgozesKicToJwqknFjKgIWHQRh/v;
Date: Tue, 13 Oct 2009 10:01:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091013100135.2b3d914f@jbarnes-g45>
In-Reply-To: <20091013023146.GA8414@mit.edu>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 22:31:46 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Oct 12, 2009 at 12:05:10PM -0700, Jesse Barnes wrote:
> > On Mon, 12 Oct 2009 20:46:51 +0200
> > "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> > 
> > > On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
> > > > > 
> > > > > Nope, unfortunately, it's not helping on my T400 laptop.  I'm
> > > > > still getting huge amounts of glitching and tearing with this
> > > > > patch applied against -rc3.
> > > > > 
> > > > > What I'm using for now to fix up my system is this patch.
> > > > > 
> > > > 
> > > > How about this one?  I have one more idea to try out if this
> > > > doesn't work (hacking on it now).
> > > 
> > > I was also experiencing something very similar to Theodore's bug 
> > > report and, at least for me, the patch below fixed the issue (the
> > > previous one also had no effect).
> > 
> > Cool, good to hear.  Hopefully Ted and Keith will confirm too.
> 
> Hmm, the amount of tearing seems to be a bit less frequent, but it's
> definitely still happening with this patch applied.  Sorry....

Arg, I'm running out of ideas...  How about this hack?  I'll chat with
the chipset guys to see if we can figure out what's going on here...

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0466ddb..d5ec112 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -352,13 +352,24 @@
 
 #define FBC_LL_SIZE		(1536)
 
-/* Framebuffer compression for GM45+ */
+/*
+ * Framebuffer compression for GM45+
+ *
+ * GM45+ support tracking of a back buffer for use with page flipping.
+ * In this case, the "persistent" bit should be set and both nuke disable
+ * bits should be set as well.  The back buffer is tracked by setting the
+ * HT fence bit in the chicken bit reg and pointing the CPU fence at the
+ * back buffer for tracking.
+ */
 #define DPFC_CB_BASE		0x3200
 #define DPFC_CONTROL		0x3208
 #define   DPFC_CTL_EN		(1<<31)
 #define   DPFC_CTL_PLANEA	(0<<30)
 #define   DPFC_CTL_PLANEB	(1<<30)
 #define   DPFC_CTL_FENCE_EN	(1<<29)
+#define   DPFC_CTL_CSNUKE_DIS	(1<<27)
+#define   DPFC_CTL_MMIONUKE_DIS	(1<<26)
+#define   DPFC_CTL_PERSISTENT	(1<<25)
 #define   DPFC_SR_EN		(1<<10)
 #define   DPFC_CTL_LIMIT_1X	(0<<6)
 #define   DPFC_CTL_LIMIT_2X	(1<<6)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7a5fb79..ea808a9 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2441,6 +2441,8 @@ static void g4x_update_wm(struct drm_device *dev, int unused, int unused2,
 	else
 		fw_blc_self &= ~FW_BLC_SELF_EN;
 	I915_WRITE(FW_BLC_SELF, fw_blc_self);
+	I915_WRITE(DSPFW1, (8 << 23) | (8 << 16) | (8 << 8) | (8 << 0));
+	I915_WRITE(DSPFW2, (1 << 31) | (8 << 28) | (8 << 8) | (8 << 0));
 }
 
 static void i965_update_wm(struct drm_device *dev, int unused, int unused2,
