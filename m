Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYGMQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYGMQXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 12:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYGMQXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 12:23:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:27601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYGMQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 12:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HtTaxEu4xCXSMyLCf5BGxIrt37oFlDHE15qGjAReWCixSYDocRoUYafpgUeiv25taV
         zE9TT5n5kI/kK/BQyTsVmE17Q0D/EAzMiwKJwrJG4JJVt5MFt41uF7qbrzw4eMa0Gs4s
         lLYF8eisT4X8qGMxj5IanLOurFael3MV/iRCc=
Date: Sun, 13 Jul 2008 20:23:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] lapic calibration results fix
Message-ID: <20080713162337.GC7459@asus>
References: <20080713113734.GB7459@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713113734.GB7459@asus>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Jul 13, 2008 at 03:37:34PM +0400]
| Ingo, Maciej,
| 
| it seems I found a bit strange code snippet in apic_32.c:setup_boot_APIC_clock.
| We set local_apic_timer_verify_ok = 1 before checking the results. I think
| the following patch make sense. Please take a look on.
| 
| ---
| We set lapic flag that clocksource calibration is
| fine too early. Fix it.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
| 
| Index: linux-2.6.git/arch/x86/kernel/apic_32.c
| ===================================================================
| --- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-13 15:25:20.000000000 +0400
| +++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-13 15:31:03.000000000 +0400
| @@ -489,8 +489,6 @@ void __init setup_boot_APIC_clock(void)
|  		    calibration_result / (1000000 / HZ),
|  		    calibration_result % (1000000 / HZ));
|  
| -	local_apic_timer_verify_ok = 1;
| -
|  	/*
|  	 * Do a sanity check on the APIC calibration result
|  	 */
| @@ -504,6 +502,8 @@ void __init setup_boot_APIC_clock(void)
|  		return;
|  	}
|  
| +	local_apic_timer_verify_ok = 1;
| +
|  	/* We trust the pm timer based calibration */
|  	if (!pm_referenced) {
|  		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");

Letme clarify a bit situation why I propose this path (it's not that
clear from its description).

While calibrating apic timer we use different 'flags' signaling if it
was success/fail. On 64bit platform lapic_timer_setup() does check
for CLOCK_EVT_FEAT_DUMMY bit which is set by default and cleared on
successfully calibrated timer. So 64bit is fine now. On 32bit we
use a different approach - local_apic_timer_verify_ok flag _BUT_
as I see it being set too early _before_ calibration result is checked
so we could have the following - kernel reports user that APIC timer
is too slow and disabled but local_apic_timer_verify_ok remains set
to 1 instead of 0.

		- Cyrill -
