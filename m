Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbXKTB2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbXKTB2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXKTBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:58 -0500
Received: from gw.goop.org ([64.81.55.164]:33632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbXKTBO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:14:57 -0500
Message-ID: <474234E7.4070505@goop.org>
Date: Mon, 19 Nov 2007 17:14:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Zachary Amsden <zach@vmware.com>, Christoph Hellwig <hch@infradead.org>,
       Tobias Powalowski <t.powa@gmx.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
References: <200711131139.42791.t.powa@gmx.de>	<473A073C.2020201@goop.org>	<20071113222212.GA1322@infradead.org>	<1195001464.6352.109.camel@bodhitayantram.eng.vmware.com> <s5hlk8ujhdf.wl%tiwai@suse.de>
In-Reply-To: <s5hlk8ujhdf.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> I took at this problem (as I have an nvidia card on one of my
> workstations), and found out that the following suffer from
> EXPORT_SYMBOL_GPL changes:
>   

Which kernel version are you using?  This is different in .24-rc
compared to .23.

> * local_disable_irq(), local_irq_save*(), etc.
>   

These should be OK either way.  pv_irq_ops is not _GPL.

> * MSR-related macros like rdmsr(), wrmsr(), read_cr0(), etc.
>   wbinvd(), too.
>   

These could reasonably use the the native_* versions anyway, since the
driver won't be being used in an environment where these won't work. 
Perhaps they should be split out separate from the gdt/ldt operations,
which they should have no business touching.

> * pmd_val(), pgd_val(), etc are all involved with pv_mm_ops.
>   pmd_large() and pmd_bad() is also indirectly involved.
>   __flush_tlb() and friends suffer, too.
>   

Yeah, I guess they can be expected to play with pagetables.

> The easiest workaround I found was to undefine CONFIG_PARAVIRT before
> inclusion of linux kernel headers, but it is really ugly and hacky.
>   

Yeah.  It will explode if you are running in a virtual environment which
still gives the virtual machine graphics hardware access.

> Redefinig with raw_*() and native_*() is another way, but it takes
> much more work than defining these primitive functions in assembly.
>
> So, in short, with EXPORT_SYMBOL_GPL change, it's pretty hard to write
> a non-GPL driver in a same manner...
>   

Yeah.  I think removing the difference between PARAVIRT and non-PARAVIRT
is enough to justify the exports.  If we want to make the policy
decision that modules can't use pagetable or msr operations at all, then
that's a separate decision which can be applied uniformly to PARAVIRT
and non-PARAVIRT.

    J
