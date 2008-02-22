Return-Path: <linux-kernel-owner+w=401wt.eu-S935223AbYBVOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223AbYBVOR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYBVORt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:17:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:55510 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYBVORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:17:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W7zIdTpLgkdUJ1xgaEwy+OK4DOOTsGIFC0dKFxPrxgXklV+tVTPMeubcTeujVccX7ZC1LMEFgthp7x6YzlhPW9SrzFppwcxtd9VCs2YEFBIx8lEDaMO3FLZJu53gOghMTJ0x84ZODwgFl8GAGadOYEvK/Za43osUCbNyZtEfxdM=
Message-ID: <93564eb70802220617x4de21db0g3291cfc4905c48c5@mail.gmail.com>
Date: Fri, 22 Feb 2008 23:17:44 +0900
From: "Samuel Masham" <samuel.masham@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Cc: "Rob Landley" <rob@landley.net>, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org
In-Reply-To: <20080129111622.GC7237@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801280217.38273.rob@landley.net>
	 <20080129111622.GC7237@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Tue, Jan 29, 2008 at 8:16 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Jan 28, 2008 at 02:17:37AM -0600, Rob Landley wrote:
>
>  > The 2.6.23 kernel built for mips with the attached .config works fine for me
>  > under qemu (both big endian and little endian), but a 2.6.24 mips kernel
>  > segfaults initializing the ne2k driver (again when run under qemu).
>  >
>  > I've traced it to this commit:
>
>  Known problem.  The issue only hits when probing IRQs as the NE2000 driver
>  does.  This got dropped on the floor in December.

In 2.6.24.2 under qemu (default config as well as my one) its still
dies at this point.

Unfortunately just reversing this patch dosen't help for me.

It seems that handle_IRQ_event is passed a null pointer for the action.

[17179569.896000] [<80067544>] handle_IRQ_event+0x148/0x154
[17179569.896000] [<800692dc>] handle_percpu_irq+0x4c/0xbc
[17179569.896000] [<80010d88>] plat_irq_dispatch+0xe8/0x110
[17179569.896000] [<80011424>] ret_from_irq+0x0/0x4
[17179569.896000] [<80069680>] probe_irq_on+0xe0/0x304
[17179569.896000] [<80384148>] ne_probe1+0x5c0/0x798
[17179569.896000] [<80384434>] do_ne_probe+0x114/0x1f8
[17179569.896000] [<80384568>] ne_probe+0x50/0x94
[17179569.896000] [<803839b8>] probe_list2+0x70/0x9c
[17179569.896000] [<80383a98>] net_olddevs_init+0xb4/0xf0
[17179569.896000] [<80367b44>] kernel_init+0x14c/0x3b0
[17179569.896000] [<80013350>] kernel_thread_helper+0x10/0x18

....

If i just avoid the probing by giving the correct irq  (23?) to the ne
driver things still look very odd...

eg:-

[17179569.908000] eth0: interrupt from stopped card

and when trying to mount the root fs

[17179574.636000] eth0: Interrupted while interrupts are masked!
isr=0x40 imr=0x0.
[17179574.640000] eth0: Interrupted while interrupts are masked!
isr=0x0 imr=0x0.
[17179574.644000] eth0: Interrupted while interrupts are masked!
isr=0x2 imr=0x0.
[17179574.648000] eth0: Interrupted while interrupts are masked!
isr=0x0 imr=0x0.
[17179574.652000] eth0: Interrupted while interrupts are masked!
isr=0x40 imr=0x0.

though it has mounted the root fs a few times with all that going on....

Is this all known issues or should I dig further?

Samuel


>
>   Ralf
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
