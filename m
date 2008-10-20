Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYJTVWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYJTVWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYJTVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:22:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbYJTVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:22:22 -0400
Date: Mon, 20 Oct 2008 14:21:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brandon Philips <bphilips@suse.de>
Cc: airlied@redhat.com, zhenyu.z.wang@intel.com, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-agp: Avoid oops for G33 on 1MB stolen case
Message-Id: <20081020142130.5c46bd7e.akpm@linux-foundation.org>
In-Reply-To: <20081014225817.GA29267@plankton.lan>
References: <20081014225817.GA29267@plankton.lan>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 15:58:17 -0700
Brandon Philips <bphilips@suse.de> wrote:

> This is similar to f443675affe3f16dd428e46f0f7fd3f4d703eeab which was
> reverted because it broke older X.org driver. This patch only fixes
> the 1MB stolen case since it causes an oops.
> 
> Xorg will not work without the accompanying patch[1] but avoiding an
> oops and making it possible to work with patched xorg driver is
> reasonable.
> 
> [1] http://ifup.org/~philips/review/xf86-video-intel-G33-1mb.patch
> 
> Explanation of the oops:
> 
> > static void intel_i830_init_gtt_entries(void)
> ...
> >         } else if (IS_G33) {
> >         /* G33's GTT size defined in gmch_ctrl */
> >                 switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
> >                 case G33_PGETBL_SIZE_1M:
> >                         size = 1024;
> >                         break;
> ...
> >                 size += 4;
> 
> size = 1028
> 
> Then since we have the BIOS setting 1MB for the device in the GMCH
> control we get to here:
> 
> >         } else {
> >                 switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> >                 case I855_GMCH_GMS_STOLEN_1M:
> >                         gtt_entries = MB(1) - KB(size);
> >                         break;
> 
> MB(1) = 1 * 1024 * 1024
> KB(1028) = 1028 * 1024
> 
> MB(1) - KB(1028) = -4096
> 
> >         gtt_entries /= KB(4);
> >         intel_private.gtt_entries = gtt_entries;
> 
> We end up with -1 in gtt_entries.
> 
> This leads to intel_i915_configure reading/writing to areas outside of
> mapped memory and the oops.
> 
> Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=391261
> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>
> 
> ---
>  drivers/char/agp/intel-agp.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/drivers/char/agp/intel-agp.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/agp/intel-agp.c
> +++ linux-2.6/drivers/char/agp/intel-agp.c
> @@ -559,6 +559,14 @@ static void intel_i830_init_gtt_entries(
>  	} else {
>  		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
>  		case I855_GMCH_GMS_STOLEN_1M:
> +			if (IS_G33) {
> +				size = 0;
> +				printk(KERN_WARNING PFX
> +				       "Warning: G33 chipset with 1MB"
> +					" allocated. Older X.org Intel drivers"
> +					" will not work.\n");
> +				WARN_ON(1);
> +			}
>  			gtt_entries = MB(1) - KB(size);
>  			break;
>  		case I855_GMCH_GMS_STOLEN_4M:

Is the bug which this patch addresses present in the 2.6.27 kernel?

Thanks.
