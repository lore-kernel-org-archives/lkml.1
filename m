Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYC1UOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYC1UOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYC1UON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:14:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:54600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYC1UOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="224541996"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] don't suspend/resume 8xx chips
Date: Fri, 28 Mar 2008 13:13:03 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
References: <200803261628.12336.jesse.barnes@intel.com> <20080328144003.GF4404@ucw.cz>
In-Reply-To: <20080328144003.GF4404@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281313.03222.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 28, 2008 7:40 am Pavel Machek wrote:
> On Wed 2008-03-26 16:28:12, Jesse Barnes wrote:
> > Recent testing has turned up some bugs in the new Intel suspend/resume
> > code for old, 8xx chipsets.  So for 2.6.25 it probably makes sense to
> > apply this patch, which should prevent the new code from getting called
> > on those chipsets.  We should have this fixed soon, but not in time for
> > 2.6.25 unfortunately.  Note that this patch (along with the
> > suspend/resume code in general) could use more testing.
> >
> > Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> >
> > diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
> > index e9d6663..6964a28 100644
> > --- a/drivers/char/drm/i915_dma.c
> > +++ b/drivers/char/drm/i915_dma.c
> > @@ -762,6 +762,11 @@ int i915_driver_load(struct drm_device *dev,
> > unsigned long
> >         unsigned long base, size;
> >         int ret = 0, mmio_bar = IS_I9XX(dev) ? 0 : 1;
> >
> > +       if (!IS_I9XX(dev)) {
> > +               dev->driver->suspend = NULL;
> > +               dev->driver->resume = NULL;
> > +       }
> > +
>
> Are you sure your driver needs no state saving?
>
> Maybe register suspend that printks, returns error?

No, there's definitely state we'd like to save/restore, but 8xx chips are 
tricky and we won't have them working before 2.6.25-final.  This patch 
preserves old behavior for 8xx chips and allows 9xx chips to properly survive 
suspend/resume events, so I don't think a printk is necessary.

Jesse
