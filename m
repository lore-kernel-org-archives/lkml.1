Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZBEQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZBEQ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZBEQ5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:57:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZBEQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:57:38 -0500
Date: Thu, 5 Feb 2009 17:56:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] drm, i915: select framebuffer support automatically
Message-ID: <20090205165657.GA15490@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <1233809147.13118.8.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233809147.13118.8.camel@gaiman>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Anholt <eric@anholt.net> wrote:

> On Wed, 2009-02-04 at 19:56 +0100, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Wed, 4 Feb 2009, Norbert Preining wrote:
> > > > 
> > > > The problem is that if you have a configuration under 2.6.28 without 
> > > > CONFIG_FB and just call make oldconfig, or even make config and don't 
> > > > know that you loose the DRM. And I was using make oldconfig (there is a 
> > > > graphical config?? ;-))
> > > 
> > > Sure. It's inconvenient, no question about that. I asked the i915 people 
> > > to look into not requiring CONFIG_FB, and I hope they will, but my point 
> > > is that I don't think we can consider "small one-time inconvenience" to be 
> > > a "regression".
> > 
> > if you mean that as a general principle, there's four very real downsides in 
> > my opinion.
> > 
> > Firstly, we could have done better (and still can do better), via various 
> > easy and non-intrusive measures:
> > 
> >    - We could add a runtime warning:
> > 
> >       for example a WARN_ONCE("please enable CONFIG_DRM_I915 and CONFIG_FB") 
> >       that there's no DRM because CONFIG_FB is not selected and oldconfig 
> >       loses the I915 setting silently - placed in a key DRM ioctl, would 
> >       have gone a long way addressing the issue. Testers do notice kernel 
> >       warnings that pop up when their X gets slow. (This approach might also 
> >       have the added bonus of warning folks who enable the wrong driver for 
> >       the hardware.)
> > 
> >    - Or we could add a more thoughtful Kconfig migration:
> > 
> >       Rename DRM_I915 to DRM_I915_FB [which it really is now], and keep
> >       DRM_I915 as a non-interactive migration helper: if set, it 
> >       auto-selects both FB and DRM_I915_FB.
> > 
> >       While CONFIG_FB is an interactive Kconfig option so a select can be 
> >       dangerous to a correct dependency tree, it seems safe to do in this 
> >       specific case because it seems to be a rather leaf entry with no 
> >       dependencies.
> 
> I tried select FB.  It's the right thing to do.  It doesn't work.  I
> posted to the mailing list two weeks ago about the insane dependency
> chain that kbuild comes up with and fails on when we do this, and got
> silence.

I mean the patch below.

I have tested it here it works fine and has no dependency problems, nor any 
build breakages on 32-bit or 64-bit x86. When you tried this you probably 
ran into the FB_I810 and FB_INTEL complication - this patch solves that too.

What do you think?

	Ingo

--------------->
>From ca835567dcb7c513a26a4396d86f12848e62de8d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 5 Feb 2009 16:03:34 +0100
Subject: [PATCH] drm, i915: select framebuffer support automatically

Migration helper.

The i915 driver recently added a 'depends on FB' rule to its
Kconfig entry - which silently turns off DRM_I915 if someone
has a working config but no CONFIG_FB selected, and upgrades
to the latest upstream kernel.

Norbert Preining reported this problem:

   Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=12599
   Subject     : dri /dev node disappeared with 2.6.29-rc1

So change it to "select FB", which auto-selects framebuffer
support. This way the driver keeps working, regardless of
whether FB was enabled before or not.

Kconfig select's of interactive options can be problematic to
dependencies and can cause build breakages - but in this case
it's safe because it's a leaf entry with no dependencies of its
own.

( There is some minor circular dependency fallout as FB_I810
  and FB_INTEL also used 'depends on FB' constructs - update
  those to "select FB" too. )

Reported-by: Norbert Preining <preining@logic.at>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/gpu/drm/Kconfig |    2 +-
 drivers/video/Kconfig   |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 5130b72..4be3acb 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -70,7 +70,7 @@ config DRM_I915
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	depends on FB
+	select FB
 	tristate "i915 driver"
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index f026770..bf0af66 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1054,9 +1054,10 @@ config FB_RIVA_BACKLIGHT
 
 config FB_I810
 	tristate "Intel 810/815 support (EXPERIMENTAL)"
-	depends on FB && EXPERIMENTAL && PCI && X86_32
+	depends on EXPERIMENTAL && PCI && X86_32
 	select AGP
 	select AGP_INTEL
+	select FB
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1119,7 +1120,8 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on FB && EXPERIMENTAL && PCI && X86
+	depends on EXPERIMENTAL && PCI && X86
+	select FB
 	select AGP
 	select AGP_INTEL
 	select FB_MODE_HELPERS
