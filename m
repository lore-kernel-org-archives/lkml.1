Return-Path: <linux-kernel-owner+w=401wt.eu-S2992621AbXCGVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992621AbXCGVaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992622AbXCGVaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:30:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:22846 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992621AbXCGVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:30:13 -0500
Message-ID: <45EF2ED5.5040905@ru.mvista.com>
Date: Thu, 08 Mar 2007 00:29:57 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [patch 5/6] powerpc 2.6.20-rt8: fix a boot error for	handle_percpu_irq
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi1wk125dj.wl@toshiba.co.jp>
In-Reply-To: <yyi1wk125dj.wl@toshiba.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tsutomu OWA wrote:
>   To fix the following boot time error by removing ack member added by
> the rt patch.

> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> Processor 1 found.
> Brought up 2 CPUs
> ------------[ cut here ]------------
> kernel BUG at arch/powerpc/platforms/cell/interrupt.c:86!
> pu 0x1: Vector: 700 (Program Check) at [c00000000fff3c80]
>     pc: c000000000033f9c: .iic_eoi+0x58/0x64
>     lr: c00000000009add8: .handle_percpu_irq+0xd4/0xf4
>     sp: c00000000fff3f00
>    msr: 9000000000021032
>   current = 0xc000000000fee040
>   paca    = 0xc000000000509e80
>     pid   = 0, comm = swapper
> kernel BUG at arch/powerpc/platforms/cell/interrupt.c:86!
> enter ? for help
> [link register   ] c00000000009add8 .handle_percpu_irq+0xd4/0xf4
> [c00000000fff3f00] c00000000009ada8 .handle_percpu_irq+0xa4/0xf4 (unreliable)
> [c00000000fff3f90] c000000000023bb8 .call_handle_irq+0x1c/0x2c
> [c000000000ff7950] c00000000000c910 .do_IRQ+0xf8/0x1b8
> [c000000000ff79f0] c000000000034f34 .cbe_system_reset_exception+0x74/0xb4
> [c000000000ff7a70] c000000000022610 .system_reset_exception+0x40/0xe0
> [c000000000ff7af0] c000000000003378 system_reset_common+0xf8/0x100
> --- Exception: 100 (System Reset) at c000000000035008 .cbe_power_save+0x94/0xb0
> [c000000000ff7e70] c000000000012030 .cpu_idle+0xc8/0x144
> [c000000000ff7f00] c000000000026894 .start_secondary+0x150/0x174
> [c000000000ff7f90] c000000000008364 .start_secondary_prolog+0xc/0x10
> 1:mon>
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
>   I found a pile of e-mail started by Sergei Shtylyov on linuxppc-dev regarding this.
>     Subject: [PATCH] 2.6.18-rt7: PowerPC: fix breakage in threaded fasteoi type IRQ handlers
>     From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>     Date: Sun, 19 Nov 2006 22:43:34 +0300

>   Though I don't quite get the conclusion, the code does not work at least
> on celleb when handle_percpu_irq is applied.  Since the handle_percpu_irq calls

    Hmmm, I was under impression that I was fixing fasteoi flow case... Sorry 
if it broke something but it really shouldn't even have been there at all. :-/

> both .ask and .eoi and when ask is set to iic_eoi, then iic_eoi() is called twice
> for one interrupt.  It hits BUG_ON(iic->eoi_ptr < 0)!

>   Anthor workaround could be to add one more irq_chip structure for handle_percpu_irq
> which does not have ack member...

>   Any comments?

    Well, I've told Ingo long ago that he shouldn't add that to the -rt patch 
(it's been refused from the very start but then got "restored" along with 
previously dropped genTOD patches).

> Signed-off-by: Tsutomu Owa <tsutomu.owa@toshiba.co.jp>
> -- owa
> 
> diff -rup linux-rt8/arch/powerpc/platforms/cell/interrupt.c rt/arch/powerpc/platforms/cell/interrupt.c
> --- linux-rt8/arch/powerpc/platforms/cell/interrupt.c	2007-02-20 14:30:38.000000000 +0900
> +++ rt/arch/powerpc/platforms/cell/interrupt.c	2007-03-02 18:48:52.000000000 +0900
> @@ -90,7 +90,6 @@ static struct irq_chip iic_chip = {
>  	.typename = " CELL-IIC ",
>  	.mask = iic_mask,
>  	.unmask = iic_unmask,
> -	.ack = iic_eoi,
>  	.eoi = iic_eoi,
>  };

WBR, Sergei
