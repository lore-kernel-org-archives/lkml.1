Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbYDVPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbYDVPy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYDVPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:54:19 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:61292 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbYDVPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:54:18 -0400
Message-ID: <480E0A54.9010203@linux.vnet.ibm.com>
Date: Tue, 22 Apr 2008 17:55:00 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Organization: =?ISO-8859-1?Q?Christian_Ehrhardt=3A_IBM_Deutschland_?=
 =?ISO-8859-1?Q?Entwicklung_GmbH=2CVorsitzender_des_Aufsichtsrats=3A?=
 =?ISO-8859-1?Q?_Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_?=
 =?ISO-8859-1?Q?Kircher=2CSitz_der_Gesellschaft=3A_B=F6blingen=2CRe?=
 =?ISO-8859-1?Q?gistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_243?=
 =?ISO-8859-1?Q?294?=
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-fbdev-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com, Hollis Blanchard <hollisb@us.ibm.com>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH 1/3] radeonfb: Fix 64 bits resources on 32 bits archs
References: <20080422012723.BA9F2DE13F@ozlabs.org>
In-Reply-To: <20080422012723.BA9F2DE13F@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> This fixes radeonfb to not truncate 64 bits resources on 32 bits
> platforms. Unfortunately, there are still issues with addresses
> returned to userspace via struct fb_fix_screeninfo. This will
> have to be dealt with separately.

Thanks for this patch Benjamin, I use it together with what we have discussed in the "pci issue - wrong detection of pci ressources" thread.
Unfortunately I now hit exactly that issue with fb_fix_screeninfo you describe.

For everyone the fb_fix_screeninfo has two "unsigned long" vars that need to strore a IO address.
This fails in my case with a 32bit powerpc system (=sizeof(long)=4) which has paddr >4Gb and actually it should affect any 32bit platform with paddr>4Gb.
You see it e.g. when you try to initialize X11, the x11 radeon driver issues a FBIOGET_FSCREENINFO ioctl and because our address is >4Gb it get's clobbered by that unsigned long in the fb_fix_screeninfo structure (the value comes from a resource_size_t variable which has the correct 64bit).

struct fb_fix_screeninfo {
        char id[16];                    /* identification string eg "TT Builtin" */
        unsigned long smem_start;     /* Start of frame buffer mem */
[...]
        unsigned long mmio_start;     /* Start of Memory Mapped I/O   */
[...]

I tried the stupid solution to just change the fb_fix_screeninfo structure to resource_size_t, but that changes the size ioctl transports and would require awareness in the userspace applications using that ioctl.
The X11 & Framebuffer driver work on 64bit systems, so I think it's just an issue of not cutting that data down to 32bit when transporting it (has anyone already checked the x11 drivers, I hope they don't use unsigned long too).

I wanted to ask if there are any known workarounds atm that would allow me to use my X11 for now?

-- 

Grüsse / regards, 
Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization
