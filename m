Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYEAUrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYEAUrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYEAUrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:47:40 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:18286 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbYEAUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:47:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
Date: Thu, 1 May 2008 14:47:37 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl>
In-Reply-To: <47F4FDCB.2000803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011447.38234.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 09:54:51 am Rene Herman wrote:
> However, now that you made me look closer and in context -- there's actually 
> a possibly somewhat serious problem here.
> 
> isapnp_read_resources() stores the resources as read from the hardware at 
> the index in the table that matches the actual index in the hardware and 
> isapnp_set_resources() stores them back into those same hardware indices.
> 
> Now by using pnp_add_foo_resource() which just scans for the first _UNSET 
> resource, the resources might not end up in the same linear position in 
> table/list if intermediate resources were unset in hardware (!ret). A 
> subsequent isapnp_set_resources() would them restore the value to the wrong 
> hardware index.
> 
> The IORESOURCE_ flags currently reserve too few bits (IORESOURCE_BITS,  8) 
> to be able to store the hardware index: IORESOURCE_MEM and IORESOURCE_DMA 
> need 2 and 1 respectively and there are 1 and 0 available respectively. It's 
> ofcourse possible to hijack a few more bits in IORESOURCE_ flags but you're 
> turning this into a list. I suppose the idea is to make it a simple list of 
> struct resource, but perhaps a resource-private "driver_data" sort of field 
> comes in handy for more than this already? Swiping more of IORESOURCE_ is a 
> bit ugly...
> 
> In any case, I missed this, but ISAPnP is still (at least in principle) 
> broken with the current set therefore.

I want to understand this better.  I think the case we're concerned
about is this:

  Memory descriptor 0 is not assigned, i.e., its base and limit/range
  registers starting at 0x40 contain zeroes, but Descriptor 1, starting
  at 0x48, *is* assigned.

The 2.6.25 "get_resources" code doesn't touch the resource table for
Descriptor 0, so its entry remains "unset".  The "set_resources" code
skips Descriptor 0 because its resource table entry is "unset" and
writes Descriptor 1.

When I convert the table to a list, I have to make sure that we write
the Descriptor 1 resources to the correct place starting at 0x48, not
to the Descriptor 0 registers.  To do this, I made "get_resources" set
the pnp_resource.index field to the current descriptor index, and
"set_resources" uses pnp_resource.index to compute the register address.

However, PNPBIOS, PNPACPI, and even ISAPNP Resource Data is all based
on the ordinal position in list (see the fourth paragraph of section
4.6.1 of the ISA spec).  Having pnp_resource.index in addition to a
list position adds a lot of confusion.

I think a better solution would be to get rid of pnp_resource.index
and have "get_resources" add a "disabled" resource for Descriptor 0,
so the Nth MEM resource in the list would always correspond to the
Nth Memory Descriptor register.

Does this make sense?

Bjorn
