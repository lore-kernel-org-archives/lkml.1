Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYEGCR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYEGCR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbYEGCRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:17:47 -0400
Received: from homer.mvista.com ([63.81.120.158]:57041 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYEGCRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:17:46 -0400
Subject: Re: x86: Clean up computation of HPET .mult variables
From: Daniel Walker <dwalker@mvista.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20080506205003.GA3749@beyonder.ift.unesp.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
	 <1210031888.17132.85.camel@localhost.localdomain>
	 <20080506021321.GA4928@Pilar.virtua.com.br>
	 <1210044218.17132.109.camel@localhost.localdomain>
	 <20080506125920.GA26295@beyonder.ift.unesp.br>
	 <1210090880.17132.140.camel@localhost.localdomain>
	 <20080506205003.GA3749@beyonder.ift.unesp.br>
Content-Type: text/plain
Date: Tue, 06 May 2008 19:17:41 -0700
Message-Id: <1210126661.17132.223.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 17:50 -0300, Carlos R. Mafra wrote:
> so there is no difference at all at this precision level!
> 
> Out of curiosity I computed the "exact" value by hand and
> got 292935555.9 so we can't even talk about "error" because
> the difference is in the extra digit not considered with
> the precision I used to print the results.
> 
> And if you look at the patch to do computation using 
> clocksource_hz2mult() you will see that it is uglier
> than the simple call to div_sc(), as you have to
> consider an extra variable hpet_freq and do an extra
> do_div() together with an extra rounding.
> 
> So I think you will be ok with the patch now, right? :-)

Not yet ..

I used you patch with some formatting changes and I get,

clocksource_hpet.mult   walker = 292935555
clocksource_hpet.mult my patch = 292935555

Same as yours .. just checking ;)

Now I modify the shift value from 22 to 25 and I get this,

clocksource_hpet.mult   walker = 2343484437
clocksource_hpet.mult my patch = 2343484446

I don't think this is due to rounding .. I'm not really sure why they're
different .. I would assume the clocksource_hz2mult is more correct, but
feel free to check into it if you want..

The reason I'm messing with the shift is cause 22 is actually too low..
For your period it can be 25, which would give better accuracy.

If you want to check the shift calculation I used it looks like this,

static inline u32 clocksource_hz2shift(u32 bits, u32 hz)
{
       u64 temp;

       for (; bits > 0; bits--) {
               temp = (u64) NSEC_PER_SEC << bits;
               do_div(temp, hz);
               if ((temp >> 32) == 0)
                       break;
       }
       return bits;
}

Daniel

