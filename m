Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXLEPpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXLEPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXLEPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:44:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36997 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbXLEPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:44:46 -0500
Date: Wed, 5 Dec 2007 07:46:21 -0800
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: 2.6.24-rc4-mm1: kobj changes fallout on powerpc
Message-ID: <20071205154621.GB23940@kroah.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205091515.GA19962@lixom.net> <20071205131140.GA13189@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205131140.GA13189@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 06:41:40PM +0530, Kamalesh Babulal wrote:
> On Wed, Dec 05, 2007 at 03:15:15AM -0600, Olof Johansson wrote:
> > powerpc allyesconfig fails on the following two drivers (iseries_defconfig
> > fails for the veth one):
> > 
> > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> > drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> > drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'
> > drivers/net/iseries_veth.c: In function 'veth_module_init':
> > drivers/net/iseries_veth.c:1714: error: 'struct device_driver' has no member named 'kobj'
> > 
> > I'm guessing it's some of Greg's kobj/driver patches that missed to
> > change this, but it's not obvious to me how it should be fixed.
> > 
> > 
> > -Olof
> Hi,
> 
> Probably this patch should fix the build failure (The kobject related
> structure have been moved to driver_private struct).

Yes, but as driver_private is not known by any driver, I don't think
this patch will work at all.

> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.24-rc4/drivers/net/ehea/ehea_main.c	2007-12-04 09:56:10.000000000 +0530
> +++ linux-2.6.24-rc4/drivers/net/ehea/~ehea_main.c	2007-12-05 18:01:31.000000000 +0530
> @@ -2809,7 +2809,7 @@ static int ehea_driver_sysfs_add(struct 
>  {
>  	int ret;
>  
> -	ret = sysfs_create_link(&driver->kobj, &dev->kobj,
> +	ret = sysfs_create_link(&driver->driver_private->kobj, &dev->kobj,
>  				kobject_name(&dev->kobj));

What are you trying to do here?  The driver core already sets up this
symlink for you automatically, why are you createing yet-another-link
with a different name?  This should just be removed entirely, it's not
needed at all.

So, to fix the build properly, just delete the sysfs_create_link() call
entirely.

thanks,

greg k-h
