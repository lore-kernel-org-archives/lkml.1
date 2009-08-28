Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbZH1D51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbZH1D51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 23:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZH1D51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 23:57:27 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64045 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZH1D50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 23:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=loHp63lNUbsSzf5vD2DjHvqKHOgFyTG/8jua+FyIea8/FOet/VI4pj5AKj6qoBdx/P
         u/NdANCgcnhyCQKHyKrlfOeP6tBjkd+DvMlxlvOBFswdY+Fai7wxrLza1HVi8qDiLRs+
         LnA1uSmLkfQyHa9/FajVofFiiFXlu31Hm88y8=
MIME-Version: 1.0
In-Reply-To: <20090827161929.253e001d@jbarnes-g45>
References: <664902dd0908270449x24f3ee12k615540ffe22e5b58@mail.gmail.com>
	 <20090827161929.253e001d@jbarnes-g45>
Date: Fri, 28 Aug 2009 11:57:27 +0800
Message-ID: <664902dd0908272057g143f5717k7ae12e8f0e12f67d@mail.gmail.com>
Subject: Re: (Re)assignment of PCI BARs
From: Beng Tan <bengtan1@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> A newer kernel could help, there have been some resource related fixes
> since 2.6.24.

Okay, I've compiled and tried the latest stable kernel (2.6.30.5)
using the instructions from
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild. This kernel loads
fine, but I still have the issue.

Dumps available at

http://208.100.55.9/cold_boot_20090828-2.6.30.5-custom/dmesg.txt
http://208.100.55.9/cold_boot_20090828-2.6.30.5-custom/iomem.txt
http://208.100.55.9/cold_boot_20090828-2.6.30.5-custom/lspci_vv.txt

dmesg shows ...

[    0.214238] pci 0000:0d:00.0: reg 10 64bit mmio: [0x000000-0xfffffff]

indicating that my laptop's bios is in error and allocated BAR 0 to
the first 256M of memory. This is obviously not right. My guess is
linux should be able to fix this?

However, later on in dmesg, I get ...

[    0.292416] pnp 00:00: mem resource (0x0-0x9fbff) overlaps
0000:0d:00.0 BAR 0 (0x0-0xfffffff), disabling
[    0.292421] pnp 00:00: mem resource (0x9fc00-0x9ffff) overlaps
0000:0d:00.0 BAR 0 (0x0-0xfffffff), disabling
[    0.292425] pnp 00:00: mem resource (0xc0000-0xcffff) overlaps
0000:0d:00.0 BAR 0 (0x0-0xfffffff), disabling
[    0.292429] pnp 00:00: mem resource (0xe0000-0xfffff) overlaps
0000:0d:00.0 BAR 0 (0x0-0xfffffff), disabling
[    0.292433] pnp 00:00: mem resource (0x100000-0x7f6d33ff) overlaps
0000:0d:00.0 BAR 0 (0x0-0xfffffff), disabling

and

[    0.344334] pci 0000:0d:00.0: BAR 0: can't allocate mem resource
[0xe0000000-0xe01fffff]
[    0.344337] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0d
[    0.344341] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.344348] pci 0000:00:1c.3:   MEM window: 0xefb00000-0xefcfffff
[    0.344354] pci 0000:00:1c.3:   PREFETCH window:
0x000000e0000000-0x000000e01fffff

so linux has not reallocated BAR 0 successfully.

> In your case, it looks like the BIOS isn't giving the bus with
> your card a large enough window (256M BAR on your card vs. a 2M windows
> on the bus).

Yes, the intervening bridge only has a 2M window. Is Linux supposed to
be intelligent enough to expand the bridge's window to 256M?

Would someone more knowledgeable be able to say whether this looks like a bug?

Also, I notice from iomem that PCI allocations start from 0xd0000000
up until the end of memory. There isn't actually a free 256M chunk in
this range.

Any idea who or what decides to start allocating at 0xd0000000? Is it
possible to tell linux to start allocating at 0xc0000000 instead?
There's nothing there so the space is free.

Also, booting the kernel with pci=assign-busses didn't affect the
issue. It just changed the bus numbering around.
