Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYEDOO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYEDOO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYEDOOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:14:20 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44739 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYEDOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:14:18 -0400
Message-ID: <481DC4E2.7060803@keyaccess.nl>
Date: Sun, 04 May 2008 16:14:58 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl> <200805011447.38234.bjorn.helgaas@hp.com>
In-Reply-To: <200805011447.38234.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-05-08 22:47, Bjorn Helgaas wrote:

> I want to understand this better.  I think the case we're concerned
> about is this:
> 
>   Memory descriptor 0 is not assigned, i.e., its base and limit/range
>   registers starting at 0x40 contain zeroes, but Descriptor 1, starting
>   at 0x48, *is* assigned.
> 
> The 2.6.25 "get_resources" code doesn't touch the resource table for
> Descriptor 0, so its entry remains "unset".  The "set_resources" code
> skips Descriptor 0 because its resource table entry is "unset" and
> writes Descriptor 1.

Yes.

> When I convert the table to a list, I have to make sure that we write
> the Descriptor 1 resources to the correct place starting at 0x48, not
> to the Descriptor 0 registers.  To do this, I made "get_resources" set
> the pnp_resource.index field to the current descriptor index, and
> "set_resources" uses pnp_resource.index to compute the register address.
> 
> However, PNPBIOS, PNPACPI, and even ISAPNP Resource Data is all based
> on the ordinal position in list (see the fourth paragraph of section
> 4.6.1 of the ISA spec).  Having pnp_resource.index in addition to a
> list position adds a lot of confusion.

I agree. Got confused/uneasy about the difference myself looking at the 
dynamic code.

> I think a better solution would be to get rid of pnp_resource.index
> and have "get_resources" add a "disabled" resource for Descriptor 0,
> so the Nth MEM resource in the list would always correspond to the
> Nth Memory Descriptor register.
> 
> Does this make sense?

It does. Ofcourse, you can than also not reuse _UNSET resources as you did 
previously but that's for the best anyway.

In trying to come up with problems I'm only finding a difference in an added 
failure mode with respect to the static array if we run out of memory at a 
bad time and this is quite unserious.

Yes, I'd say to just do that. It might appear a bit clumsy from an 
implementation standpoint but the only thing this stuff should be doing is 
enable inane amounts of possible resources for one device without forcing 
them on all.

Rene
