Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYDXJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYDXJlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYDXJlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:41:23 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:53451 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYDXJlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:41:15 -0400
X-Greylist: delayed 3388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 05:41:14 EDT
Message-ID: <480FE1CB.8000202@keyaccess.nl>
Date: Thu, 24 Apr 2008 03:26:35 +0200
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
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
References: <20080418204955.342963315@ldl.fc.hp.com> <200804211710.38660.bjorn.helgaas@hp.com> <480E5246.5000804@keyaccess.nl> <200804231708.53572.bjorn.helgaas@hp.com>
In-Reply-To: <200804231708.53572.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-04-08 01:08, Bjorn Helgaas wrote:

> My idea is that the list should end up in the same order as the
> resource list from the BIOS, e.g., the _CRS and _PRS lists for
> ACPI.  In the case of ISAPNP, it'll be in the order that we read
> things from the hardware registers.
> 
> I think I should probably make pnp_new_resource() always allocate
> a new resource and get rid of the idea of reusing something already
> in the list.

I'd agree.

> I updated the patches and my ACPI box with the inactive devices now boots
> (it failed with the v3 patches).  I'll work on the pnp_new_resource()
> thing tomorrow, but I'll send you the current patches now in case you
> have a chance to try them on your ISA box.

Could do a quick test and its cs4236 soundcard works fine with them. There 
are a few "current resources: after pnp_assign_resources (failed)" in there 
but they might be expected, I didn't yet look. There's a dmesg from booting 
it and "modprobe snd-cs4236" at:

http://members.home.nl/rene.herman/dmesg-2.6.25-pnpv3.9

Matching "options" files:

root@6bap:~# for OPTIONS in /sys/devices/pnp1/01\:01/01\:01.0?/options; do 
echo; echo $OPTIONS; echo; cat $OPTIONS; done

/sys/devices/pnp1/01:01/01:01.00/options

Dependent: 01 - Priority preferred
    port 0x534-0x534, align 0x3, size 0x4, 16-bit address decoding
    port 0x388-0x388, align 0x7, size 0x4, 16-bit address decoding
    port 0x220-0x220, align 0x1f, size 0x10, 16-bit address decoding
    irq 5 High-Edge
    dma 1 8-bit byte-count compatible
    dma 0,1 8-bit byte-count compatible
Dependent: 02 - Priority acceptable
    port 0x534-0xffc, align 0x3, size 0x4, 16-bit address decoding
    port 0x388-0x388, align 0x7, size 0x4, 16-bit address decoding
    port 0x220-0x260, align 0x1f, size 0x10, 16-bit address decoding
    irq 5,7,2/9,11,12,15 High-Edge
    dma 1,3 8-bit byte-count compatible
    dma 0,1,3 8-bit byte-count compatible
Dependent: 03 - Priority functional
    port 0x534-0xffc, align 0x3, size 0x4, 16-bit address decoding
    port 0x388-0x3f8, align 0x7, size 0x4, 16-bit address decoding
    port 0x220-0x300, align 0x1f, size 0x10, 16-bit address decoding
    irq 5,7,2/9,11,12,15 High-Edge
    dma 0,1,3 8-bit byte-count compatible

/sys/devices/pnp1/01:01/01:01.01/options

Dependent: 01 - Priority preferred
    port 0x200-0x200, align 0x7, size 0x8, 16-bit address decoding
Dependent: 02 - Priority acceptable
    port 0x208-0x208, align 0x7, size 0x8, 16-bit address decoding

/sys/devices/pnp1/01:01/01:01.02/options

port 0x120-0xff8, align 0x7, size 0x8, 16-bit address decoding

/sys/devices/pnp1/01:01/01:01.03/options

Dependent: 01 - Priority preferred
    port 0x330-0x330, align 0x7, size 0x2, 16-bit address decoding
    irq 2/9 High-Edge
Dependent: 02 - Priority acceptable
    port 0x330-0x360, align 0x7, size 0x2, 16-bit address decoding
    irq 2/9,11,12,15 High-Edge
Dependent: 03 - Priority functional
    port 0x330-0x3e0, align 0x7, size 0x2, 16-bit address decoding

/sys/devices/pnp1/01:01/01:01.04/options

Dependent: 01 - Priority acceptable
    port 0x1e8-0x1e8, align 0x0, size 0x8, 16-bit address decoding
    port 0x3ee-0x3ee, align 0x0, size 0x1, 16-bit address decoding
    irq 11,12 High-Edge
Dependent: 02 - Priority acceptable
    port 0x168-0x168, align 0x0, size 0x8, 16-bit address decoding
    port 0x36e-0x36e, align 0x0, size 0x1, 16-bit address decoding
    irq 2/9,11,12 High-Edge

Rene.
