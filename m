Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXGMDQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXGMDQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXGMDP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:15:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:43366 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbXGMDP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=alRR0R+6zYNNtzuxqn4M3UOGNHTSIv4ivUUfivNq/p78A/2wCcROhwTHgKezQxx9gNZP6Zeb1exEOL0DPGYakWQYZrVba9pfBrvG3a6SqDPxMjJ38H2FOzFdpzScBOnKqNGIrR8gJxCc6u4KjqD5Vp9H3wFOrHNiBmcuZyoaNrs=
Message-ID: <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
Date: Fri, 13 Jul 2007 08:45:57 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <4695EC25.6050003@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695EC25.6050003@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Timo,

Thanks for your report!

On 7/12/07, Timo Lindemann <tlindemann@arcor.de> wrote:
> a problem report to something giving me a real headache:

> [2.] The version 2.6.22 of the linux kernel hangs when initializing the
> integrated ohci controller of the nvidia MCP51 chipset (pci device ids
> vendor:product == 10de:26d). I have traced through various printks that
> pci_init calls pci_fixup_device, later on in quirk_usb_ohci_handoff
> (file linux/drivers/usb/host/pci-quirks.c) kernel freezes in this
> section:
> ...
> if (control & OHCI_CTRL_IR) {
>         int wait_time = 500;
>         writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
>         writel(OHCI_ORC, base + OHCI_CMDSTATUS); // this never returns
> ...
> after this, kernel apparently goes into busy waiting (fans gradually
> turn louder) and hangs indefinitely. I have also made sure that writel
> (in linux/include/asm/io.h) really is entered, but never returns.

[ Added David Brownell to Cc: ]

> [6.] Reproducible by booting any version 2.6.21+ on that machine
> (nvidia MCP51-Chipset, see the lspci output)
> [...]
> [7.7] What is striking about that problem is that kernel 2.6.20.6 does
> not even enter the section mentioned in [2.].

2.6.20 works, 2.6.21 doesn't, right? You could try git-bisect on Linus'
tree (if you can use git) to find the offending commit that broke it:

http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html

and

http://www.reactivated.net/weblog/archives/2006/01/
using-git-bisect-to-find-buggy-kernel-patches/
(long URL broken in 2 lines)

You don't need to "make clean" between git-bisect builds, but be
prepared to lose a couple of hours on this still :-)

> [7.1] the ver_linux output under 2.6.20.6, in the directory of 2.6.22,
> says:
>
> Gnu C                  4.2.1

Others have reported problems booting with gcc-4.2-compiled
kernels too. Could you try building with 4.1?

> Modules Loaded         rt2500* nvidia* forcedeth
>
> * nvidia and rt2500 are most assuredly not involved in this. They are
> not loaded by that kernel.
> [...]
> [7.3] no modules have been configured (all in-kernel)

You're saying there are no modules, then how come those three
are loaded? Also try reproducing the problem without proprietary
(nvidia) drivers, please.

> [7.5] (I cannot run this with 2.6.22. In 2.6.20.6, the output can be
> retrieved from http://cip.uni-trier.de/~lindem/lspci.txt as this is
> really large)

Ok.

> [X.] I tried hard to understand what's going on, but ultimately, I could
> not yet write a fix, workaround, or anything like that, so I am asking
> for help/enlightenment, or even an already-done fix. Really very
> sorry. Also, different options like noapic, nolapic, acpi=off,
> pci=routeirq|biosirq|usepirqmask were already tried; I also tried
> disabling quirks for that particular vendor:device-combination, which
> leads to another freeze further along. Also, commenting the writel()
> will hang indefinitely in the following wait_time loop.
>
> I can only guess that it might
> have to do with the patch
> "commit 4302a595cd9c6363b495460497ecbda49fa16858
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Fri Dec 15 06:53:55 2006 +1100
> USB: Rework the OHCI quirk mecanism as suggested by David
> "
> but I don't really have a clue, so this might be groundless suspicion.
> If so, I apologize about that.

As mentioned earlier, git-bisect could help us narrow this down.
It's not a silver bullet, but often useful.

[ BTW, just-after a new kernel release is often an unlucky period to
report bugs, it appears ... everybody gets busy with not missing the
merge window to push in their shiny new stuff :-) ]

Thanks,
Satyam
