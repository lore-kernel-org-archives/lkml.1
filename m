Return-Path: <linux-kernel-owner+w=401wt.eu-S1767661AbXDFOeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767661AbXDFOeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767663AbXDFOeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:34:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35298 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767661AbXDFOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:34:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Natalie Protasevich <nataliep@google.com>, Andi Kleen <ak@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       auke-jan.h.kok@intel.com
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz>
	<46126EAA.3050000@intel.com>
	<Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz>
	<46128C92.2020908@intel.com>
	<Pine.LNX.4.64.0704031940080.28249@twin.jikos.cz>
	<Pine.LNX.4.64.0704041748330.28249@twin.jikos.cz>
	<m1r6r0awc2.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704061503310.31796@twin.jikos.cz>
Date: Fri, 06 Apr 2007 08:32:48 -0600
In-Reply-To: <Pine.LNX.4.64.0704061503310.31796@twin.jikos.cz> (Jiri Kosina's
	message of "Fri, 6 Apr 2007 15:23:05 +0200 (CEST)")
Message-ID: <m1r6qx8tf3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jikos@jikos.cz> writes:

> Hi Eric,
>
> after struggling with this issue for some time, I think that it's just 
> some incosistent usage of NR_IRQS throughout the source probably due to 
> some include hell. I really don't understand the how the mach-*/ includes 
> are supposed to work.
>
> I found out (by disassembling resulting vmlinux binaries) that in 
> arch/i386/kernel/entry.S, the loop in irq_entries_start does too little 
> iterations compared to NR_IRQS value as seen in for example io_apic.c
>
> The super-stupid proof-patch below fixes the panic on my system. It's just 
> to demonstrate that the i386 includes really need fixing to be consistent 
> somehow.

Thanks, and that would do it, it  makes sense why it was the irq patch
that caused problems.  I had forgotten about the number of stubs issue.

I had to clean that up on x86_64 as well and it probably makes most sense
to put that cleanup as well, so we have a small fixed number of stubs
which would make the includes not matter.

Bleh.  Hopefully soon.

Eric

> diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
> index 976438c..b20dc07 100644
> --- a/arch/i386/kernel/entry.S
> +++ b/arch/i386/kernel/entry.S
> @@ -53,6 +53,8 @@
>  #include <asm/dwarf2.h>
>  #include "irq_vectors.h"
>  
> +#define NR_IRQS 4096
> +
>  /*
>   * We use macros for low-level operations which need to be overridden
>   * for paravirtualization.  The following will never clobber any registers:
>
> -- 
> Jiri Kosina
