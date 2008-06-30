Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbYF3Uvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbYF3Uvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYF3Uvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:51:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42917 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYF3Uvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:51:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>
	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>
	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>
	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
	<485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
Date: Mon, 30 Jun 2008 13:50:42 -0700
In-Reply-To: <48691E8B.4040605@sgi.com> (Mike Travis's message of "Mon, 30 Jun
	2008 10:57:31 -0700")
Message-ID: <m14p7asl3x.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> H. Peter Anvin wrote:
>> Mike Travis wrote:
>>>
>>> FYI, I did try this out and it caused the bootloader to scramble the
>>> loaded data.  The first corruption I found was the .x86cpuvendor.init
>>> section contained all zeroes.
>>>
>> 
>> Explain what you mean with "the bootloader" in this context.
>> 
>>     -hpa
>
>
> After the code was loaded (the compressed code, it seems that my GRUB
> doesn't support uncompressed loading), the above section contained
> zeroes.  I snapped it fairly early, around secondary_startup_64, and
> then printed it in x86_64_start_kernel.
>
> The object file had the correct data (as displayed by objdump) so I'm
> assuming that the bootloading process didn't load the section correctly.
>
> Below was the linker script I used:
>
> --- linux-2.6.tip.orig/include/asm-generic/vmlinux.lds.h
> +++ linux-2.6.tip/include/asm-generic/vmlinux.lds.h
> @@ -373,9 +373,13 @@
>
>  #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
>  #define PERCPU(align)                                                  \
> -       . = ALIGN(align);                                               \
> +       .data.percpu.abs = .;                                           \
>         percpu : { } :percpu                                            \
> -       __per_cpu_load = .;                                             \
> +       .data.percpu.rel : AT(.data.percpu.abs - LOAD_OFFSET) {         \
> +               BYTE(0)                                                 \
> +               . = ALIGN(align);                                       \
> +               __per_cpu_load = .;                                     \
> +       }                                                               \
>         .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
>                 *(.data.percpu.first)                                   \
>                 *(.data.percpu.shared_aligned)                          \
> @@ -383,8 +387,8 @@
>                 *(.data.percpu.page_aligned)                            \
>                 ____per_cpu_size = .;                                   \
>         }                                                               \
> -       . = __per_cpu_load + ____per_cpu_size;                          \
> -       data : { } :data
> +       . = __per_cpu_load + ____per_cpu_size;
> +
>  #else
>  #define PERCPU(align)                                                  \
>         . = ALIGN(align);                                               \
>
> It showed all the correct address in the map and __per_cpu_load was a
> relative symbol (which was the objective.)
>
> Btw, our simulator, which only loads uncompressed code, had the data correct,
> so it *may* only be a result of the code being compressed.

Weird.  Grub doesn't get involved in the decompression the kernel does it
all itself so we should be able to track where things go bad.

Last I looked the compressed code was formed by essentially.
objcopy vmlinux -O binary vmlinux.bin
gzip vmlinux.bin
And then we take on a magic header to the gzip compressed file.

Are things only bad with the change above?

Eric
