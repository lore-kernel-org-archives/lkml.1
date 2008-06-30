Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYF3R5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYF3R5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYF3R5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:57:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42247 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762190AbYF3R5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:57:33 -0400
Message-ID: <48691E8B.4040605@sgi.com>
Date: Mon, 30 Jun 2008 10:57:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com> <48691556.2080208@zytor.com>
In-Reply-To: <48691556.2080208@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>>
>> FYI, I did try this out and it caused the bootloader to scramble the
>> loaded data.  The first corruption I found was the .x86cpuvendor.init
>> section contained all zeroes.
>>
> 
> Explain what you mean with "the bootloader" in this context.
> 
>     -hpa


After the code was loaded (the compressed code, it seems that my GRUB
doesn't support uncompressed loading), the above section contained
zeroes.  I snapped it fairly early, around secondary_startup_64, and
then printed it in x86_64_start_kernel.

The object file had the correct data (as displayed by objdump) so I'm
assuming that the bootloading process didn't load the section correctly.

Below was the linker script I used:

--- linux-2.6.tip.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.tip/include/asm-generic/vmlinux.lds.h
@@ -373,9 +373,13 @@

 #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
 #define PERCPU(align)                                                  \
-       . = ALIGN(align);                                               \
+       .data.percpu.abs = .;                                           \
        percpu : { } :percpu                                            \
-       __per_cpu_load = .;                                             \
+       .data.percpu.rel : AT(.data.percpu.abs - LOAD_OFFSET) {         \
+               BYTE(0)                                                 \
+               . = ALIGN(align);                                       \
+               __per_cpu_load = .;                                     \
+       }                                                               \
        .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
                *(.data.percpu.first)                                   \
                *(.data.percpu.shared_aligned)                          \
@@ -383,8 +387,8 @@
                *(.data.percpu.page_aligned)                            \
                ____per_cpu_size = .;                                   \
        }                                                               \
-       . = __per_cpu_load + ____per_cpu_size;                          \
-       data : { } :data
+       . = __per_cpu_load + ____per_cpu_size;
+
 #else
 #define PERCPU(align)                                                  \
        . = ALIGN(align);                                               \

It showed all the correct address in the map and __per_cpu_load was a
relative symbol (which was the objective.)

Btw, our simulator, which only loads uncompressed code, had the data correct,
so it *may* only be a result of the code being compressed.

Thanks,
Mike
