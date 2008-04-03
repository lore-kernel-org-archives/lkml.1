Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbYDCRL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbYDCRL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbYDCRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:35 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:38733 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759998AbYDCRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:29 -0400
Message-ID: <47F50FF0.40602@keyaccess.nl>
Date: Thu, 03 Apr 2008 19:12:16 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl> <200804031043.43068.bjorn.helgaas@hp.com>
In-Reply-To: <200804031043.43068.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-04-08 18:43, Bjorn Helgaas wrote:

> On Thursday 03 April 2008 09:54:51 am Rene Herman wrote:
>> However, now that you made me look closer and in context -- there's actually 
>> a possibly somewhat serious problem here.
>>
>> isapnp_read_resources() stores the resources as read from the hardware at 
>> the index in the table that matches the actual index in the hardware and 
>> isapnp_set_resources() stores them back into those same hardware indices.
>>
>> Now by using pnp_add_foo_resource() which just scans for the first _UNSET 
>> resource, the resources might not end up in the same linear position in 
>> table/list if intermediate resources were unset in hardware (!ret). A 
>> subsequent isapnp_set_resources() would them restore the value to the wrong 
>> hardware index.
>>
>> The IORESOURCE_ flags currently reserve too few bits (IORESOURCE_BITS,  8) 
>> to be able to store the hardware index: IORESOURCE_MEM and IORESOURCE_DMA 
>> need 2 and 1 respectively and there are 1 and 0 available respectively. It's 
>> ofcourse possible to hijack a few more bits in IORESOURCE_ flags but you're 
>> turning this into a list. I suppose the idea is to make it a simple list of 
>> struct resource, but perhaps a resource-private "driver_data" sort of field 
>> comes in handy for more than this already? Swiping more of IORESOURCE_ is a 
>> bit ugly...
>>
>> In any case, I missed this, but ISAPnP is still (at least in principle) 
>> broken with the current set therefore.
> 
> Hmm...  you're right.  And I think it could bite PNPBIOS and PNPACPI
> as well -- they don't read/write hardware registers directly, but the
> firmware still depends on preserving the resource order.  I'll have to
> ponder that for a while.

Both PNPBIOS and PNPACPI should be fine it seems:

pnpbios_get_resources()
   pnpbios_read_resources_from_node()
     pnpbios_parse_allocated_resource_data()
       pnpbios_parse_allocated_irqresource()
       pnpbios_parse_allocated_dmaresource()
       pnpbios_parse_allocated_ioresource()
       pnpbios_parse_allocated_memresource()

where the latter do the same scan for the first _UNSET resource as the new 
code does. Same thing for ACPI in the path

pnpacpi_get_resources()
   pnpacpi_parse_allocated_resource()
      pnpacpi_allocated_resource()
        pnpacpi_parse_allocated_irqresource()
        pnpacpi_parse_allocated_dmaresource()
        pnpacpi_parse_allocated_ioresource()
        pnpacpi_parse_allocated_memresource()
        pnpacpi_parse_allocated_address_space()
          pnpacpi_parse_allocated_memresource()

Rene.
