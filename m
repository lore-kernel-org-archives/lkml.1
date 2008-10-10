Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYJJTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYJJTEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761862AbYJJTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:04:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:35665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760546AbYJJTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:04:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,391,1220252400"; 
   d="scan'208";a="390023718"
Date: Fri, 10 Oct 2008 12:03:50 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
Message-ID: <20081010190350.GA25931@linux-os.sc.intel.com>
References: <20081010150017.GD7328@localhost> <7E82351C108FA840AB1866AC776AEC46378236B8@orsmsx505.amr.corp.intel.com> <20081010163101.GG7328@localhost> <7E82351C108FA840AB1866AC776AEC46378238AE@orsmsx505.amr.corp.intel.com> <20081010171645.GI7328@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010171645.GI7328@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:16:45AM -0700, Cyrill Gorcunov wrote:
> [Pallipadi, Venkatesh - Fri, Oct 10, 2008 at 10:07:38AM -0700]
> |
> |
> | >-----Original Message-----
> | >From: Cyrill Gorcunov [mailto:gorcunov@gmail.com]
> | >Sent: Friday, October 10, 2008 9:31 AM
> | >To: Pallipadi, Venkatesh
> | >Cc: Ingo Molnar; Maciej W. Rozycki; LKML
> | >Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
> | >
> | >[Pallipadi, Venkatesh - Fri, Oct 10, 2008 at 09:11:06AM -0700]
> | >|
> | >|
> | >| Agree with the APIC_DIVISOR part.
> | >|
> | >| But, not sure why/how the second change is related to this
> | >APIC_DIVISOR being 16.
> | >| Also, another nit. Technically we are not setting the "APIC
> | >counter to maximum"
> | >| as we do divide by 16 before programming initial count
> | >register in __setup_APIC_LVTT().
> | >|
> | >| Thanks,
> | >| Venki
> | >|
> | >
> | >From __setup_APIC_LVTT(0xffffffff, 0, 0) caller point of view we do
> | >set maximum possible value. How you could make it bigger?
> | >(without additional changes _inside_ __setup_APIC_LVTT itself).
> |
> |
> | The basic question is why are we making this change now? Is the old value
> | breaking some system today? Or Is it not to break some future system with
> | very high bus clock freq? If we are doing it to future proof things,
> | we should be making more changes inside __setup_APIC_LVTT and make
> | this maximum possible value..
> |
> | >Actually I wouldn't mind if you fix the comment if you don't like
> | >this 'correlation' btw CLKs divisor and APIC_DIVISOR. No problem :)
> |
> | No problem. I can send a separate patch to change this calibration
> | count to maximum once I understand why exactly we are doing it now :).
> |
> | Thanks,
> | Venki
> |
> 
> We do unify apic code I would say.
> 

If there is no pressing reason to change the initial calibration value, how
about the simple patch below.

The 10^9 value that is used for 100 mS calibration time is pretty big as
tglx's comment points out. We will only underflow it if there is a
bus clock running at 10 GHz * 16 = 160 Ghz.

This way we will not fix something that is not really broken today and will not
break in foreseeable future.

Thanks,
Venki




From: Cyrill Gorcunov <gorcunov@gmail.com>
Author: Cyrill Gorcunov <gorcunov@gmail.com>

x86: apic - unify APIC_DIVISOR

Use APIC_DIVISOR being set to 16 for both 32/64bit
mode.

Also typo error (CONFG instead of proper CONFIG) fixed.
The error was caught by Venkatesh Pallipadi, thanks a lot Venkatesh!

See details on http://lkml.org/lkml/2008/10/9/425

Reported-by: Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Acked-by: Venkatesh Pallipadi <Venkatesh Pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -332,11 +332,7 @@ int lapic_get_maxlvt(void)
  */
 
 /* Clock divisor */
-#ifdef CONFG_X86_64
-#define APIC_DIVISOR 1
-#else
 #define APIC_DIVISOR 16
-#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
