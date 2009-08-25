Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZHYTxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZHYTxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZHYTxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:53:01 -0400
Received: from claw.goop.org ([74.207.240.146]:49461 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbZHYTxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:53:00 -0400
Message-ID: <4A94411E.708@goop.org>
Date: Tue, 25 Aug 2009 12:53:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>	 <4A943CBD.60808@goop.org> <1251229085.25686.2.camel@penberg-laptop>
In-Reply-To: <1251229085.25686.2.camel@penberg-laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 12:38, Pekka Enberg wrote:
> On Tue, 2009-08-25 at 12:34 -0700, Jeremy Fitzhardinge wrote:
>   
>> I don't think this is the real fix, and it seems a bit ugly.  I'm OK
>> with it as a workaround, but I think it will end up getting reverted if
>> applied.
>>     
> Yeah, I'm fine with that. It's just that we're really late in the
> release cycle now so I'd like to keep the fix as simple as possible.

Yeah, that's fine, but I think something like this would be simpler. 
Arnd, could you test it please?

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 25 Aug 2009 12:47:17 -0700
Subject: [PATCH] xen: suppress WP test

Xen always runs on CPUs which properly support WP enforcement in
privileged mode, so there's no need to test for it.

This also works around a crash reported by Arnd Hannemann, though
I think its just a band-aid for that case.

Reported-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 16d0d70..e5b903b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1069,6 +1069,7 @@ asmlinkage void __init xen_start_kernel(void)
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
 	new_cpu_data.hard_math = 1;
+	new_cpu_data.wp_works_ok = 1;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif



>  Do you think the real bug lies in Xen or...?
>   

I'm unsure.  If handling a trap ends up enabling interrupts for some
reason, then things would break horribly all over the place, so it would
have to be something a bit more subtle.  I'm looking into it.

    J
