Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYA3ODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYA3ODy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYA3ODc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:03:32 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:55309 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbYA3OD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=PsyHCFoi27RnRfycG0ME1O/YHuHamiFMyYksqmdBuY2Azvc8x9kYWiR2RvUFU6RvPmNu2B8Oc2YPOTb/PPvYRmicyegmFrZ2IB8pW/j1ps43yarNBt0o/zqWux34TbG6rb8hbaEuyX/8vTEhaKkJHCsFwCZdA/WMcybEbOZMh20=
Date: Wed, 30 Jan 2008 15:03:15 +0100
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-pcmcia@lists.infradead.org, linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [HD64461_PCMCIA_driver] - Shared IRQ lines / Segfaults
Message-Id: <20080130150315.307708e0.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080130130559.GA30360@roarinelk.homelinux.net>
References: <20080130132036.87299f09.Kristoffer.ericson@gmail.com>
	<20080130130559.GA30360@roarinelk.homelinux.net>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 14:05:59 +0100
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> On Wed, Jan 30, 2008 at 01:20:36PM +0100, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Driver detects card insertion / ejection and sets power properly. The mapping looks resonable also compairing to a working 2.6.17 driver.
> > modprobe hostap_cs
> > hostap_cs: Registered netdevice wifi0
> > Unable to handle kernel NULL pointer dereference at virtual address 00000028
> > pc = 8d0031b8
> > *pde = 00000000
> > Oops: 0000 [#1]
> > Modules linked in: hostap_cs hostap orinoco_cs orinoco hermes atmel_cs atmel
> > 
> > Pid : 283, Comm:             modprobe
> > PC is at generic_inw+0x8/0x20
> > PC  : 8d0031b8 SP  : 8ecaba74 SR  : 400000f0 TEA : c0045040    Not tainted
> > R0  : 00000028 R1  : 8d2d9030 R2  : 8d2ac050 R3  : 00000007
> > R4  : 00000028 R5  : 00000002 R6  : 00000080 R7  : 8ecf06a0
> > R8  : 8ee62000 R9  : 00008a32 R10 : c002a1b0 R11 : 8ee62000
> > R12 : 00000080 R13 : 8ee62000 R14 : 8ecf06a0
> > MACH: 0000458f MACL: 00001110 GBR : 296ce450 PR  : 8d0031b8
> > 
> > Call trace: 
> > [<c002a1fa>] prism2_interrupt+0x4a/0xc50 [hostap_cs]
> 
> The oops output suggests it crashes in 
> drivers/net/wireless/hostap/hostap_hw.c::prism2_check_magic(),
> specifically when it tries to read the HF384X_SWSUPPORT0_OFF register
> (which ist at offset 0x28, just like the oopsing address).
> So, looking at the HFA384X_INW macro, it seems dev->base_addr is NULL.
> I suspect this is because of set_io_map() callback in the hd64461.c
> socket driver.  The comment there says IO area is statically mapped,
> yet it returns null; I suggest you let it return the base address of
> the IO area instead.

I tried returning the base IO area but didn't make any difference. I took a look at some other pcmcia drivers
set_io_map and it looks it should only return 0 on success. 

When setting up the socket I define socket->io_offset = 0xba000000 which it should use. A bit lost why it doesn't get used though.
Its the only IO area so thats why its static. Perhaps the io_offset is ment to be used with base_addr?

> 
> -- 
>  Manuel Lauss
