Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXHGDDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXHGDDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 23:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXHGDCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 23:02:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009AbXHGDCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 23:02:49 -0400
Date: Mon, 6 Aug 2007 19:49:10 -0700
From: Greg KH <gregkh@suse.de>
To: "Denis V. Lunev" <den@sw.ru>
Cc: "Denis V. Lunev" <den@openvz.org>, dev@openvz.org,
       akpm@linux-foundation.org, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci_get_device call from interrupt in reboot fixups
Message-ID: <20070807024910.GB13657@suse.de>
References: <20070803103924.GA23786@iris.sw.ru> <20070804040806.GF23330@suse.de> <46B6CAC4.3080202@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6CAC4.3080202@sw.ru>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 11:16:20AM +0400, Denis V. Lunev wrote:
> Greg KH wrote:
> > On Fri, Aug 03, 2007 at 02:39:24PM +0400, Denis V. Lunev wrote:
> >> The following calltrace is possible now:
> >>  handle_sysrq
> >>    machine_emergency_restart
> >>      mach_reboot_fixups
> >>        pci_get_device
> >>          pci_get_subsys
> >> 	   down_read
> >> The patch obtains PCI device during initialization to avoid bothering PCI
> >> search engine in interrupt. Devices used in this code are not supposed to
> >> be pluggable, so it looks safe to keep them.
> > 
> > What devices are supposed to be affected here?  Are you sure that they
> > can't be removed later?  Grabbing references here might mess with them
> > in the future.
> Right now the list is the following:
> static struct device_fixup fixups_table[] = {
> { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
> cs5530a_warm_reset },
> { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
> };
> 
> Though, if the approach is not suitable, we can skip fixups if we came
> from sysrq.

I don't think we really need to do fixups when we are "crashing" like
this.  The user really isn't shutting down the kernel as it should
normally do.

Andrew, I really don't want to change the PCI core to handle this, as we
finally fixed a lot of issues with drivers trying to walk these lists
from interrupt context.  So if you want to just hide the warning message
as we are shutting down, that's fine with me.  Or just don't do the
fixups.  But grabbing a reference to the pci device is unsafe in my
opinion and I do not want to do that.

thanks,

greg k-h
