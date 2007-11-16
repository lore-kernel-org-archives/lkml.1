Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXKPUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXKPUyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXKPUyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:54:33 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:23207 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbXKPUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:54:32 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 15:54:32 EST
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH]: PNP: Increase the value of PNP constant
Date: Fri, 16 Nov 2007 13:46:37 -0700
User-Agent: KMail/1.9.6
Cc: Zhao Yakui <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, shaohua.li@intel.com,
       Thomas Renninger <trenn@suse.de>
References: <1195198798.2460.18.camel@yakui_zhao.sh.intel.com> <473DCAE0.9040401@keyaccess.nl>
In-Reply-To: <473DCAE0.9040401@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161346.37749.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 09:52:48 am Rene Herman wrote:
> On 16-11-07 08:39, Zhao Yakui wrote:
> 
> > Subject: PNP: Increase the value of PNP constant
> > From: Zhao Yakui  <yakui.zhao@intel.com>
> > 
> > On some systems the number of resources(IO,MEM) returnedy by PNP
> > device is greater than the PNP constant, for example motherboard devices. 
> > It brings that some resources can't be reserved and resource confilicts.
> > This will cause PCI resources are assigned wrongly in some systems, and
> > cause hang. This is a regression since we deleted ACPI motherboard
> > driver and use PNP system driver.
> > 
> > Andrew, I thought this is an urgent issue and should be fixed ASAP, and
> > this is a good candidate for -stable tree

Thomas Renninger is working on PNP patches so we can accomodate any
number of resources.  We had talked about an interim solution like
the one Shaohua is proposing, but thought the space overhead was
objectionable:

I (Bjorn) wrote:
> ...  We're going from 16 resource structs
> per PNP device to 42.  Each struct resource looks like about 7
> longs or pointers, so on a 32-bit system with 16 PNP devices, we
> are going from about 7K to almost 19K just for these tables, most
> of which are mostly empty.  On a 64-bit system, it goes from about
> 14K to over 37K.

However, we did not realize that switching from the ACPI motherboard
driver to the PNP driver would cause a regression.  Since that's the
case, I don't think we have much choice -- I think we have to either
increase the table sizes until we can handle things dynamically, or
switch back to the ACPI motherboard driver until we have Thomas's
work.  For a -stable patch, I think enlarging the tables is safer.

The space analysis above was based on increasing PNP_MAX_PORT from
8 to 32 and PNP_MAX_IRQ from 2 to 4 (total increase of 26 resources
per device).  Shaohua's patch adds 16 port and 8 mem resources for
an increase of 24, so will use slightly less space.

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

> > Signed-off-by: Li Shaohua <shaohua.li@intel.com>
> > Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
> > 
> > ---
> >  drivers/pnp/pnpacpi/rsparser.c |   18 ++++++++++++++++--
> >  include/linux/pnp.h            |    4 ++--
> >  2 files changed, 18 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6.24-rc2/include/linux/pnp.h
> > ===================================================================
> > --- linux-2.6.24-rc2.orig/include/linux/pnp.h
> > +++ linux-2.6.24-rc2/include/linux/pnp.h
> > @@ -13,8 +13,8 @@
> >  #include <linux/errno.h>
> >  #include <linux/mod_devicetable.h>
> >  
> > -#define PNP_MAX_PORT		8
> > -#define PNP_MAX_MEM		4
> > +#define PNP_MAX_PORT		24
> > +#define PNP_MAX_MEM		12
> 
> This fairly significantly grows (for example?) a struct pnp_resource_table. 
> Are 24 and 12 really sensible?
> 
> Rene.

