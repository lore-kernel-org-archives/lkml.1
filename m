Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbYFDWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbYFDWbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbYFDWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:31:10 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:51068 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYFDWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:31:09 -0400
Message-ID: <484717A6.4060403@keyaccess.nl>
Date: Thu, 05 Jun 2008 00:31:02 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <4845D937.2000205@keyaccess.nl> <4846810B.2030301@keyaccess.nl> <200806041450.10576.bjorn.helgaas@hp.com>
In-Reply-To: <200806041450.10576.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-06-08 22:50, Bjorn Helgaas wrote:

> On Wednesday 04 June 2008 05:48:27 am Rene Herman wrote:
>> On 04-06-08 01:52, Rene Herman wrote:
> 
>> ADS7181 in fact might as well delete the IRQ from the dependents and add
>> "irq 2/9,10,11 High-Edge Optinal" in front as an independent same as 
>> ADS7151. That way, all the cloning can go.
> 
> We currently clone for AZT0002 as well as ADS7181.  Can we do the
> same for both?  It would be nice to get rid of the cloning code
> if we can.

Yes. AZT0002 (the MPU401 on an AZT2320 chip) is the exact same as 
ADS7181 (the MPU401 on an AD1816 chip).

IORESOURCE_IRQ_OPTIONAL clears the path for doing things better. I see 
its dependent 2 can then just go entirely in fact.

Hardware says:

Dependent: 00 - Priority preferred
   irq 2/9 High-Edge
   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 01 - Priority acceptable
   irq 2/9 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 02 - Priority functional
   irq 2/9,10,11 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding

We want it to end up as:

irq 2/9,10,11 High-Edge (Optional)
Dependent: 00 - Priority preferred
   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding

So walk dependents deleting IRQs, except last dependent IRQ which is 
cloned into a new independent (inserted in front would be best for 
ISAPnP since the spec does recommend this) while making it optional and 
then just delete the last dependent completely (it would be same as the 
previous dependent after all).

Rene.
