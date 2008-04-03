Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbYDCPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbYDCPxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbYDCPxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:53:08 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36278 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbYDCPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:53:05 -0400
Message-ID: <47F4FDCB.2000803@keyaccess.nl>
Date: Thu, 03 Apr 2008 17:54:51 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com> <47F2C8A2.3070303@keyaccess.nl> <200804021535.22011.bjorn.helgaas@hp.com>
In-Reply-To: <200804021535.22011.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-04-08 23:35, Bjorn Helgaas wrote:

>>    By the way, the original isapnp_parse_id explicitly encodes the top _6_
>>    bits in str[0] (& 0x3f) which seems odd. Bit 31 had better be 0 indeed,
>>    but I wonder why the original didn't just assume such.
> 
> Yes, I wonder about that, too.  Including that bit would mean that
> the first character of PNP IDs could include characters at offsets
> 0x20-0x3f, i.e., "`a..z{|}~" and DEL.  I poked around and found
> some IDs that seem to depend on that, e.g., "nEC8241" in the 8250_pnp
> serial driver.

Oh well, PC hardware...

> I changed this to include six bits for the first character, and
> masked off the top bit in PNPBIOS.  I think that should preserve
> the previous behavior; see what you think.

Yes, it should. I checked the ISAPnP specification and it explicitly fixes 
bit 31 at 0 (and defines the "compressed ASCII" as 5 bits). Given what you 
describe you probably don't have a good place to stash a comment but with 6 
bits being non-spec something like "appease broken ISAPnP hardware" would 
probably be good.

>>    2: There are 4 tests for ACPI_READ_WRITE_MEMORY here which are turned
>>       into IORESOURCE_MEM_WRITEABLE or 0. Not sure, but should they be
>>       turned into IORESOURCE_MEM_WRITEABLE or IORESOURCE_READONLY?
> 
> One would expect that "mem.write_protect == 1" would mean read-only.
> Unfortunately, I'm too lazy to un-obfuscate the ACPI CA logic that
> deals with mem.write_protect, since it seems to be all table-driven.
> In the absence of understanding, I tried to preserve the existing
> behavior.  I think I did, i.e., if "write_protect == ACPI_READ_WRITE_MEMORY",
> we add in IORESOURCE_MEM_WRITEABLE, otherwise do nothing.  If I
> goofed that up, let me know.

No, you didn't, is fine.

> I have an ISA question here, too: previously isapnp_read_resources()
> set only res.start for IO and MMIO resources and left res.end unset
> (should be zero, I think).  I don't think ISA tells you the size, so
> I assumed "1", but I don't know if that's the right thing to do.  My
> reasoning was "zero is obviously wrong, two could be too big and
> generate bogus conflicts, so one is the only possible choice."

Yes, as far as I'm aware the actual value is of no consequence. The size is 
not a setable parameter; to hardware they're only base address registers, It 
used to be kept simply at -1 (in an unsigned sort of way) and as far as I'm 
aware, we're also not interested yet at this level.

However, now that you made me look closer and in context -- there's actually 
a possibly somewhat serious problem here.

isapnp_read_resources() stores the resources as read from the hardware at 
the index in the table that matches the actual index in the hardware and 
isapnp_set_resources() stores them back into those same hardware indices.

Now by using pnp_add_foo_resource() which just scans for the first _UNSET 
resource, the resources might not end up in the same linear position in 
table/list if intermediate resources were unset in hardware (!ret). A 
subsequent isapnp_set_resources() would them restore the value to the wrong 
hardware index.

The IORESOURCE_ flags currently reserve too few bits (IORESOURCE_BITS,  8) 
to be able to store the hardware index: IORESOURCE_MEM and IORESOURCE_DMA 
need 2 and 1 respectively and there are 1 and 0 available respectively. It's 
ofcourse possible to hijack a few more bits in IORESOURCE_ flags but you're 
turning this into a list. I suppose the idea is to make it a simple list of 
struct resource, but perhaps a resource-private "driver_data" sort of field 
comes in handy for more than this already? Swiping more of IORESOURCE_ is a 
bit ugly...

In any case, I missed this, but ISAPnP is still (at least in principle) 
broken with the current set therefore.

> I also made the _len() functions inlines and restructured the logic in
> both _len() and _valid() functions.  I couldn't stand the thought of all
> those extra list traversals in there :-)  I'd appreciate a double-check
> of that.

Will do.

Rene.
