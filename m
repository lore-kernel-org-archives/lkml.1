Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbXFRSGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbXFRSGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763194AbXFRSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:06:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764745AbXFRSGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:06:18 -0400
Date: Mon, 18 Jun 2007 14:06:11 -0400
From: Dave Jones <davej@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Carlo Wood <carlo@alinoe.com>, Dave Airlie <airlied@gmail.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618180611.GA31116@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chuck Ebbert <cebbert@redhat.com>, Carlo Wood <carlo@alinoe.com>,
	Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net
References: <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com> <20070618015636.GA8561@alinoe.com> <20070618023726.GA7594@zhen-devel.sh.intel.com> <4676C3F5.5070501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676C3F5.5070501@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:42:13PM -0400, Chuck Ebbert wrote:
 > On 06/17/2007 10:37 PM, Wang Zhenyu wrote:
 > > On 2007.06.18 03:56:36 +0000, Carlo Wood wrote:
 > >> On Mon, Jun 18, 2007 at 10:57:38AM +1000, Dave Airlie wrote:
 > >>>> Right now, I'm at a loss to explain the corruption, so it's
 > >>>> difficult to suggest what to try.
 > >>> The thing is here, this is PCIE, so if there is a GPU plugged into the
 > >>> PCIE 16x slot in theory the main onboard graphics should disable, AGP
 > >>> code is used to control the GART for the onboard chip, in this case a
 > >>> plugged in card will  not use AGP, I wonder have Intel tested with a
 > >>> pcie card in place...
 > > 
 > > Agree. We seem to always enable AGP even IGD is disabled or not exists,
 > > other card should not depend on this module ever.
 > > 
 > >> That is Chinese for me :/.
 > >> Do you want me to try something?
 > > 
 > > Carlo, I've just built latest kernel git tree on a Dell 965G box and
 > > have a NV card plugged-in. It boots fine.
 > > 
 > > Linux agpgart interface v0.102 (c) Dave Jones
 > > agpgart: Detected an Intel 965G Chipset.
 > > agpgart: AGP aperture is 256M @ 0x0
 > > 
 > > I don't know why it hangs your machine when loading this module, it should
 > > just not bother anything. But from your last "modprobe: ..." line, it seems
 > > there's really badness somewhere, do you have serial console to see more
 > > in the message?
 > 
 > There are also these bug reports:
 > 
 > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229913
 > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242101

good find.

Looking through intel-agp brings up a wart that I've been 
complaining about for a while.

Start looking for functions with '965' in them.
the first one you hit is the wonderfully named
'intel_i830_init_gtt_entries'.
Two thirds of that function no longer have anything to
do with an i830.  Instead of adding a intel_i965_init_gtt_entries,
this thing has grown into a monster dealing with three different
generations of hardware.

This results in tables like this..

static const struct agp_bridge_driver intel_i965_driver = {
       .owner                  = THIS_MODULE,
       .aperture_sizes         = intel_i830_sizes,
       .size_type              = FIXED_APER_SIZE,
       .num_aperture_sizes     = 4,
       .needs_scratch_page     = TRUE,
       .configure              = intel_i915_configure,
       .fetch_size             = intel_i9xx_fetch_size,
       .cleanup                = intel_i915_cleanup,
       .tlb_flush              = intel_i810_tlbflush,
       .mask_memory            = intel_i965_mask_memory,
       .masks                  = intel_i810_masks,
       .agp_enable             = intel_i810_agp_enable,
       .cache_flush            = global_cache_flush,
       .create_gatt_table      = intel_i965_create_gatt_table,
       .free_gatt_table        = intel_i830_free_gatt_table,
       .insert_memory          = intel_i915_insert_entries,
       .remove_memory          = intel_i915_remove_entries,
       .alloc_by_type          = intel_i830_alloc_by_type,
       .free_by_type           = intel_i810_free_by_type,
       .agp_alloc_page         = agp_generic_alloc_page,
       .agp_destroy_page       = agp_generic_destroy_page,
       .agp_type_to_mask_type  = intel_i830_type_to_mask_type,

so we use bits and pieces from 810, 830, 915, and throw in
some new 965 routines too.  Why is this a mess ?
Because it's non-trivial to just look at this table
and spot bugs like "wait, that 810 should be using 915"
without lots of staring at data sheets.
Additionally each time we twist these routines to cope with
an additional chipset, we risk breaking previous generations.

Having functions do ONE thing is a good thing, even if
it means having 15 of them that look similar.
The alternative of a single function that becomes a nest
of if's & switches is just horrible.

It could be that all of the above is actually pointing to
the correct routines.  It could also be that the codepaths
in those routines, as twisty as they are, are fine, and this
is just some normal bug, but hunting for it becomes a lot
harder when the code is this baroque.

	Dave

-- 
http://www.codemonkey.org.uk
