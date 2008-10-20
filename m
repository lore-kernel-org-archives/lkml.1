Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbYJTVpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbYJTVpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYJTVpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:45:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47201 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbYJTVo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:44:59 -0400
Subject: Re: [PATCH] intel-agp: Avoid oops for G33 on 1MB stolen case
From: Dave Airlie <airlied@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brandon Philips <bphilips@suse.de>, zhenyu.z.wang@intel.com,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081020142130.5c46bd7e.akpm@linux-foundation.org>
References: <20081014225817.GA29267@plankton.lan>
	 <20081020142130.5c46bd7e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 07:44:46 +1000
Message-Id: <1224539086.3656.6.camel@optimus>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 14:21 -0700, Andrew Morton wrote:
> On Tue, 14 Oct 2008 15:58:17 -0700
> Brandon Philips <bphilips@suse.de> wrote:
> 
> > This is similar to f443675affe3f16dd428e46f0f7fd3f4d703eeab which was
> > reverted because it broke older X.org driver. This patch only fixes
> > the 1MB stolen case since it causes an oops.
> > 
> > Xorg will not work without the accompanying patch[1] but avoiding an
> > oops and making it possible to work with patched xorg driver is
> > reasonable.
> > 
> > [1] http://ifup.org/~philips/review/xf86-video-intel-G33-1mb.patch
> > 
> > Explanation of the oops:
> > 
> > > static void intel_i830_init_gtt_entries(void)
> > ...
> > >         } else if (IS_G33) {
> > >         /* G33's GTT size defined in gmch_ctrl */
> > >                 switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
> > >                 case G33_PGETBL_SIZE_1M:
> > >                         size = 1024;
> > >                         break;
> > ...
> > >                 size += 4;
> > 
> > size = 1028
> > 
> > Then since we have the BIOS setting 1MB for the device in the GMCH
> > control we get to here:
> > 
> > >         } else {
> > >                 switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> > >                 case I855_GMCH_GMS_STOLEN_1M:
> > >                         gtt_entries = MB(1) - KB(size);
> > >                         break;
> > 
> > MB(1) = 1 * 1024 * 1024
> > KB(1028) = 1028 * 1024
> > 
> > MB(1) - KB(1028) = -4096
> > 
> > >         gtt_entries /= KB(4);
> > >         intel_private.gtt_entries = gtt_entries;
> > 
> > We end up with -1 in gtt_entries.
> > 
> > This leads to intel_i915_configure reading/writing to areas outside of
> > mapped memory and the oops.
> > 
> > Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=391261
> > 
> > Signed-off-by: Brandon Philips <bphilips@suse.de>
> > 
> > ---
> >  drivers/char/agp/intel-agp.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > Index: linux-2.6/drivers/char/agp/intel-agp.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/char/agp/intel-agp.c
> > +++ linux-2.6/drivers/char/agp/intel-agp.c
> > @@ -559,6 +559,14 @@ static void intel_i830_init_gtt_entries(
> >  	} else {
> >  		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> >  		case I855_GMCH_GMS_STOLEN_1M:
> > +			if (IS_G33) {
> > +				size = 0;
> > +				printk(KERN_WARNING PFX
> > +				       "Warning: G33 chipset with 1MB"
> > +					" allocated. Older X.org Intel drivers"
> > +					" will not work.\n");
> > +				WARN_ON(1);
> > +			}
> >  			gtt_entries = MB(1) - KB(size);
> >  			break;
> >  		case I855_GMCH_GMS_STOLEN_4M:
> 
> Is the bug which this patch addresses present in the 2.6.27 kernel?
> 

I've been a bit wary about this patch, but on re-review I suppose it
should be fine. We'll just get WARN_ONs in places we don't really want
them, and I'm sure Arjan will come complaining about them from
kerneloops.

However as I said at KS there is no nice answer to this, we are
hopelessly screwed.

Dave.


