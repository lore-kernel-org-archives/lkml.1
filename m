Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJ2FYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJ2FYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJ2FYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:24:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYJ2FYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:24:14 -0400
Date: Tue, 28 Oct 2008 22:23:51 -0700
From: Brandon Philips <bphilips@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@redhat.com, zhenyu.z.wang@intel.com, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-agp: Avoid oops for G33 on 1MB stolen case
Message-ID: <20081029052351.GC7834@plankton.ifup.org>
References: <20081014225817.GA29267@plankton.lan> <20081020142130.5c46bd7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020142130.5c46bd7e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:21 Mon 20 Oct 2008, Andrew Morton wrote:
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

Yes, ever since 3a4986955c0d9806e96a9d738ef7c40cb0cdaba3

Thanks,

	Brandon
