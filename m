Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZEFG56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZEFG56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZEFG5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:57:49 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52239 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZEFG5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:57:48 -0400
Message-Id: <4A015158.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 06 May 2009 07:59:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix build with older binutils
References: <4A0055B3.76EA.0078.0@novell.com>
 <20090505163930.GA18579@uranus.ravnborg.org>
In-Reply-To: <20090505163930.GA18579@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 05.05.09 18:39 >>>
>I like the way your patch simplies the linker scrip for x86.
>We have recently merged the linker scripts for 32 and 64 bit,
>and I tried to apply your patch on top of the unified version.
>(Applied manually obviously).
>
>With a 64 bit defconfig build I got:
>/home/sam/x-tools/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld: section .vsyscall_0 [00000000016c6000 -> >00000000016c60e7] overlaps section .init.rodata [00000000016c5a00 -> 00000000016c6348]
>make[1]: *** [.tmp_vmlinux1] Error 1
>
>I did not try to build a kernel with your original patch.
>
>Can you spot anything obvious wrong in my patch.
>It is on top of x86/kbuild in -tip.

Yeah, the placement of .init.start appears to be wrong - it should the
SMP/x86-64 case of the per-CPU segment, and it should also be the
one getting the :init attached. Hopefully that won't get us back to the
binutils problem I was originally encountering - what is the extra .init.start
section good for anyway? And why does __init_end continue to live
outside of any section (this sort of thing causes problems with
CONFIG_RELOCATABLE and older binutils afair, as such symbols get
marked absolute by the latter)? While this was the case (and a mistake)
for x86-64 prior to the merge, it was properly placed in a section for
ix86, and hence I'd view it as a regression there.

Btw., why is .data.nosave being placed differently for 32- and 64-bit?

Jan

