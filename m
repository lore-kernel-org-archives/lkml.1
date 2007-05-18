Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbXERBF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbXERBF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXERBFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:05:14 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:42239 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754993AbXERBFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:05:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH 2/3] drm modesetting core
Date: Thu, 17 May 2007 18:04:54 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171537.46639.jesse.barnes@intel.com> <20070517234135.GA18012@dreamland.darkstar.lan>
In-Reply-To: <20070517234135.GA18012@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171804.54626.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007, Luca Tettamanti wrote:
> Il Thu, May 17, 2007 at 03:37:45PM -0700, Jesse Barnes ha scritto:
> > This patch adds the core of the new DRM based modesetting system.
>
> A couple of comments on drm_fb since I'm somewhat familiar with fb code:
> > new file mode 100644
> > index 0000000..0d06792
> > --- /dev/null
> > +++ b/linux-core/drm_edid.c
> > @@ -0,0 +1,467 @@
> > +/*
> > + * Copyright (c) 2007 Intel Corporation
> > + *   Jesse Barnes <jesse.barnes@intel.com>
> > + *
> > + * DDC probing routines (drm_ddc_read & drm_do_probe_ddc_edid)
> > originally from
> > + * FB layer.
>
> Hum, why are you duplicating them here? fbmon.c has the
> infrastructure for parsing and even fixing known-broken EDIDs.

Yeah, there's more sharing that could be done... though I don't think the 
fb layer has the bits to actually grab EDIDs.  Also, DRM is shared with 
BSD...

> > +static bool edid_valid(struct edid *edid)
> > +{
> > +	int i;
> > +	u8 csum = 0;
> > +	u8 *raw_edid = (u8 *)edid;
> > +
> > +	if (memcmp(edid->header, edid_header, sizeof(edid_header)))
> > +		goto bad;
> > +	if (edid->version != 1)
> > +		goto bad;
> > +	if (edid->revision <= 0 || edid->revision > 3)
> > +		goto bad;
> > +
> > +	for (i = 0; i < EDID_LENGTH; i++)
> > +		csum += raw_edid[i];
> > +	if (csum)
> > +		goto bad;
> > +
> > +	return 1;
> > +
> > +bad:
> > +	return 0;
> > +}
>
> This is basically edid_check_header + edid_checksum.

Yep, pretty trivial stuff.

> get_detailed_timing?
>
> If you  can't use 'struct fb_videomode' we may refactor code around a
> common data structure instead of a copy&paste.

I agree that would be better.  I'll see what I can do to unify the two.

> > +static unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter
> > *adapter)
>
> [...]
>
> > +static unsigned char *drm_ddc_read(struct i2c_adapter *adapter)
>
> [...]
>
> Copy and paste from fb_dcc.c; furthermore a fix in drm_ddc_read hasn't
> been backported to the original code.

I think the original tries a few times... but it's still buggy.  I've got 
an old EDID 1.1 monitor whose EDID block is fetched by X but not by this 
code (or the original FB code) so I think we still have some timing bugs 
to fix.

> > +	info = framebuffer_alloc(sizeof(struct drmfb_par), device);
> > +	if (!info){
> > +		return -EINVAL;
> > +	}
>
> -ENOMEM? Plus, spurious brackets.

Fixed, thanks.

> > +	if (register_framebuffer(info) < 0)
> > +		return -EINVAL;
>
> You leak the fb_info structure on error path.

Oops, I'll fix that too.

At this point though, the drm_fb driver isn't actually used.  I recently 
added the intel_fb driver (mostly using code from intelfb) so we could 
have an accelerated DRM FB driver, hopefully that one's ok.

Thanks for looking at it.

Jesse

