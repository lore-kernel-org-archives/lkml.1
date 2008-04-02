Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbYDBVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbYDBVff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbYDBVf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:35:27 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38962 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbYDBVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:35:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
Date: Wed, 2 Apr 2008 15:35:21 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080401151634.730901933@ldl.fc.hp.com> <47F2C8A2.3070303@keyaccess.nl>
In-Reply-To: <47F2C8A2.3070303@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021535.22011.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 05:43:30 pm Rene Herman wrote:
> On 01-04-08 17:16, Bjorn Helgaas wrote:
> 
> > This series of patches does some PNP housecleaning and
> > consolidation.
> 
> Quite a series...

Thanks again for your detailed review and for fixing my ISAPNP
mistakes.  That was a lot of code to go through.

> [patch 05/37] PNP: add pnp_eisa_id_to_string()
> 
>    +void pnp_eisa_id_to_string(u32 id, char *str)
>    +{
>    +       id = be32_to_cpu(id);
>    +       str[0] = '@' + ((id >> 26) & 0x1f);
>    +       str[1] = '@' + ((id >> 21) & 0x1f);
>    +       str[2] = '@' + ((id >> 16) & 0x1f);
>    +       str[3] = hex_asc((id >> 12) & 0xf);
>    +       str[4] = hex_asc((id >>  8) & 0xf);
>    +       str[5] = hex_asc((id >>  4) & 0xf);
>    +       str[6] = hex_asc((id >>  0) & 0xf);
>    +       str[7] = '\0';
>    +}
> 
>    I'd much prefer 'A' - 1 over '@'. While no doubt not a practical issue,
>    it's more portable that way and more importantly, clearer.

I copied that from acpi_ex_eisa_id_to_string(), but I agree that
"'A' - 1" is much clearer, so I changed it.

>    By the way, the original isapnp_parse_id explicitly encodes the top _6_
>    bits in str[0] (& 0x3f) which seems odd. Bit 31 had better be 0 indeed,
>    but I wonder why the original didn't just assume such.

Yes, I wonder about that, too.  Including that bit would mean that
the first character of PNP IDs could include characters at offsets
0x20-0x3f, i.e., "`a..z{|}~" and DEL.  I poked around and found
some IDs that seem to depend on that, e.g., "nEC8241" in the 8250_pnp
serial driver.

I changed this to include six bits for the first character, and
masked off the top bit in PNPBIOS.  I think that should preserve
the previous behavior; see what you think.

> [patch 08/37] PNP: change pnp_add_card_id() to allocate its own pnp_id 
> structures
> 
>    Same problem with hexadecimal as before. Bisection would get a bogus
>    card id here, but fixed in 09/37.

Thanks for pointing that out.  I changed it to use hex_asc() so bisection
should work.

> [patch 22/37] PNP: make generic pnp_add_io_resource()
> 
>    int pnp_add_io_resource(..., resource_size_t len, ...)
>    {
>          [ ... ]
> 
>          if (len <= 0 || end >= 0x10003) {
> 
>    len is a u32 or u64, so (len <= 0) == (len == 0)

I changed it to "len == 0", thanks.

> [patch 23/37] PNP: make generic pnp_add_mem_resource()
> 
>    1: Same comment for pnp_add_mem_resource as 22/37

Also changed to "len == 0".

>    2: There are 4 tests for ACPI_READ_WRITE_MEMORY here which are turned
>       into IORESOURCE_MEM_WRITEABLE or 0. Not sure, but should they be
>       turned into IORESOURCE_MEM_WRITEABLE or IORESOURCE_READONLY?

One would expect that "mem.write_protect == 1" would mean read-only.
Unfortunately, I'm too lazy to un-obfuscate the ACPI CA logic that
deals with mem.write_protect, since it seems to be all table-driven.
In the absence of understanding, I tried to preserve the existing
behavior.  I think I did, i.e., if "write_protect == ACPI_READ_WRITE_MEMORY",
we add in IORESOURCE_MEM_WRITEABLE, otherwise do nothing.  If I
goofed that up, let me know.

I have an ISA question here, too: previously isapnp_read_resources()
set only res.start for IO and MMIO resources and left res.end unset
(should be zero, I think).  I don't think ISA tells you the size, so
I assumed "1", but I don't know if that's the right thing to do.  My
reasoning was "zero is obviously wrong, two could be too big and
generate bogus conflicts, so one is the only possible choice."

> [patch 30/37] PNP: convert resource accessors to use pnp_get_resource(), not 
> pnp_resource_table
> 
>    Is there a reason to not make pnp_{port,mem,irq,dma}_{start,end,flags}()
>    inlines?
> 
>    static inline resource_size_t pnp_port_start(struct pnp_dev *dev,
>                                                 unsigned int bar)
>    {
>            struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
>            return res->start;
>    }

No good reason; I think I was just being lazy and making the code
shorter.  I changed them all to static inlines.  (After making this
change, I did trip over a use of pnp_mem_flags() as an lvalue, so I
added a patch that removed that usage.)

I also made the _len() functions inlines and restructured the logic in
both _len() and _valid() functions.  I couldn't stand the thought of all
those extra list traversals in there :-)  I'd appreciate a double-check
of that.

>    Also, you have pnp_{port,mem,irq,dma}_valid() returning a resource_size_t.
>    They should return int, I presume.

Fixed, thanks.

I'll add in a couple more patches to (finally) remove the fixed-size
pnp_resource_table and post a v3 in a day or two.

Bjorn
