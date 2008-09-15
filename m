Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYIOKUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYIOKUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 06:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYIOKTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 06:19:52 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37877 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYIOKTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 06:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQUljdfkQsJr+yHjgGJOIjRT5fpW32DgXVOxowH4rRGvGmGuo5gpcXkj/RUya4WN18
         FBso2htiDgMUMqSngSiBZwQG1ZWM7dZ3Ogn4Xx+EbFIKO71fxJwbhLbk9VAFJU8Cxuvt
         9twfFg39sPIXYihOOpt58EUbSHTJOTFi3nM0A=
Date: Mon, 15 Sep 2008 14:20:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: smpboot - check if we have ESR register in
	wakeup_secondary_cpu
Message-ID: <20080915102007.GB7131@lenovo>
References: <20080914175849.GC3907@lenovo> <20080915075655.GC29585@elte.hu> <20080915100119.GA7131@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915100119.GA7131@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Sep 15, 2008 at 02:01:19PM +0400]
| [Ingo Molnar - Mon, Sep 15, 2008 at 09:56:55AM +0200]
| | 
| | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| | 
| | > We should check if we have ESR register before writting to it.
| | > 
| | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| | > ---
| | > 
| | > Please review!
| | > it seems the same nit in do_boot_cpu - checking now.
| | > 
| | > Index: linux-2.6.git/arch/x86/kernel/smpboot.c
| | > ===================================================================
| | > --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-14 19:43:03.000000000 +0400
| | > +++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-14 21:49:36.000000000 +0400
| | > @@ -598,10 +598,12 @@ wakeup_secondary_cpu(int logical_apicid,
| | >  	 * Give the other CPU some time to accept the IPI.
| | >  	 */
| | >  	udelay(200);
| | > -	maxlvt = lapic_get_maxlvt();
| | > -	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
| | > -		apic_write(APIC_ESR, 0);
| | > -	accept_status = (apic_read(APIC_ESR) & 0xEF);
| | > +	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| | > +		maxlvt = lapic_get_maxlvt();
| | > +		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
| | > +			apic_write(APIC_ESR, 0);
| | > +		accept_status = (apic_read(APIC_ESR) & 0xEF);
| | > +	}
| | >  	pr_debug("NMI sent.\n");
| | 
| | hm, is there any non-integrated lapic that has more than 3 lvts? iirc 
| | lvts were introduced with the integrated lapic.
| | 
| | 	Ingo
| | 
| 
| Yes Ingo, but don't forget the next line in former
| 
| 	accept_status = (apic_read(APIC_ESR) & 0xEF);
| 
| so we're protected in writting but _not_ in reading - which
| is buggy a bit :-)
|
| 		- Cyrill -

Ingo - could you replace in this patch message and subject -
writting to reading - it will be more correct.

		- Cyrill -
