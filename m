Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYBYBCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYBYBCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYBYBB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:01:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYBYBB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:01:56 -0500
Message-ID: <47C21284.7040607@zytor.com>
Date: Sun, 24 Feb 2008 16:57:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se>	<20080224135720.GA5323@elte.hu>	<18369.35401.678391.183329@harpo.it.uu.se> <18369.43239.964660.62249@harpo.it.uu.se>
In-Reply-To: <18369.43239.964660.62249@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> Here's how the breakage occurs:
> 1. arch/x86/kernel/tsc_32.c:tsc_init() sees !cpu_has_tsc,
>    so bails and calls setup_clear_cpu_cap(X86_FEATURE_TSC).
> 2. include/asm-x86/cpufeature.h:setup_clear_cpu_cap(bit) clears
>    the bit in boot_cpu_data and sets it in cleared_cpu_caps
> 3. arch/x86/kernel/cpu/common.c:identify_cpu() XORs all caps
>    in with cleared_cpu_caps
>    HOWEVER, at this point c->x86_capability correctly has TSC
>    Off, cleared_cpu_caps has TSC On, so the XOR incorrectly
>    sets TSC to On in c->x86_capability, with disastrous results.
> 
> The real bug is that clearing bits with XOR only works if the
> bits are known to be 1 prior to the XOR, and that's not true here.
> 
> A simple fix is to convert the XOR to AND-NOT instead. The following
> patch does that, and allows my 486 to boot 2.6.25-rc kernels again.
> 

Please fix it in both places.  Using XOR instead of AND-NOT is a bug, 
plain and simple.

	-hpa
