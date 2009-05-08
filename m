Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZEHHS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZEHHS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZEHHSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:18:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:48433 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZEHHSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:18:49 -0400
Message-Id: <4A03F947.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 08 May 2009 08:20:07 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "the arch/x86 maintainers" <x86@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/x86-64: clean up warnings
	 aboutIST-using traps
References: <4A032EE0.9030607@goop.org>
In-Reply-To: <4A032EE0.9030607@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 07.05.09 20:56 >>>
>Ignore known IST-using traps.  Aside from the debugger traps, they're
>low-level faults which Xen will handle for us, so the kernel needn't
>worry about them.  Keep warning in case unknown trap starts using IST.
>
>Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>---
> arch/x86/xen/enlighten.c |   22 ++++++++++++++++++++--
> 1 files changed, 20 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>index cb49f57..88f3aa4 100644
>--- a/arch/x86/xen/enlighten.c
>+++ b/arch/x86/xen/enlighten.c
>@@ -439,12 +439,30 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
> 
> 	addr = gate_offset(*val);
> #ifdef CONFIG_X86_64
>+	/*
>+	 * Look for known traps using IST, and substitute them
>+	 * appropriately.  The debugger ones are the only ones we care
>+	 * about.  Xen will handle faults like double_fault and
>+	 * machine_check, so we should never see them.  Warn if
>+	 * there's an unexpected IST-using fault handler.
>+	 */
> 	if (addr == (unsigned long)debug)
> 		addr = (unsigned long)xen_debug;
> 	else if (addr == (unsigned long)int3)
> 		addr = (unsigned long)xen_int3;
>-	else
>-		WARN_ON(val->ist != 0);
>+	else if (addr == (unsigned long)double_fault ||
>+		 addr == (unsigned long)stack_segment) {

I don't think you want to exclude handling stack faults: Ordinary memory
references using rsp or rbp as the base register will cause these instead
of general protection faults when the resulting effective address is non-
canonical.

>+		/* Don't need to handle these */
>+		return 0;
>+#ifdef CONFIG_X86_MCE
>+	} else if (addr == (unsigned long)machine_check) {
>+		return 0;
>+#endif
>+	} else {
>+		/* Some other trap using IST? */
>+		if (WARN_ON(val->ist != 0))
>+			return 0;
>+	}
> #endif	/* CONFIG_X86_64 */
> 	info->address = addr;
> 
>-- 
>1.6.0.6

Jan

