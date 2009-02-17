Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZBQHp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZBQHp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZBQHpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:45:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:50293 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751069AbZBQHpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:45:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19m9yR+kcRmay/U3RpdbrcksJ0Hz+ipJzCzUl6sp6
	n5WSpKKc7xhltp
Subject: Re: 2.6.29-rc4 regression
From: Mike Galbraith <efault@gmx.de>
To: Tim Blechmann <tim@klingt.org>
Cc: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <499961AF.8030909@klingt.org>
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org>
	 <20090213190740.GD25042@erda.amd.com> <20090216112313.359ef437@thinkpad>
	 <20090216113349.GF25042@erda.amd.com>  <499961AF.8030909@klingt.org>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 08:45:40 +0100
Message-Id: <1234856740.6867.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 13:53 +0100, Tim Blechmann wrote:
> >>> still, I can not reproduce this with my tests with v2.6.29-rc4. The
> >>> regression on the systems I have runs fine on rc4. On the system you
> >>> have, is commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 the first bad
> >>> one? If so, I will split the patch into smaller pieces to find the
> >>> change that introduces the bug.
> >> i got revision df13b31c286b3e91c556167954eda088d90a4295 working, by not
> >> resetting the counter width:
> >>
> >> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> >> index 12e207a..f0e019d 100644
> >> --- a/arch/x86/oprofile/op_model_ppro.c
> >> +++ b/arch/x86/oprofile/op_model_ppro.c
> >> @@ -76,12 +76,14 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
> >>  			return;
> >>  	}
> >>  
> >> +#if 0
> >>  	if (cpu_has_arch_perfmon) {
> >>  		union cpuid10_eax eax;
> >>  		eax.full = cpuid_eax(0xa);
> >>  		if (counter_width < eax.split.bit_width)
> >>  			counter_width = eax.split.bit_width;
> >>  	}
> >> +#endif
> >>
> >>
> >> this tweak did not work on later kernels, that i tested, though, and i 
> >> haven't had time to look into it in more detail.
> 
> hm, i just tried to compile 2.6.28 with this patch applied, and there
> the NMIs are delivered correctly.
> 
> > Thanks Tim, on later kernels, is it the behaviour you mentioned that
> > no NMIs are delivered and you do not receive any NMI?
> 
> on the current 2.6.29-rc5, no NMIs are delivered. however i have also
> applied the performance counter branch from tip, maybe that interferes
> with oprofile?

Hm.

If you're using latest tip, there _should_ be no interference.  There
was a problem a short while back in that both perfcounters and oprofile
register die handlers, but that was resolved by increasing oprofile's
handler priority, so that it takes over NMI handling while profiling.

I just did an oprofile test run with x86-tip/master while kerneltop was
running.  NMIs stopped being handled by kerneltop once oprofile started,
and resumed after oprofile finished... seems to be working.

	-Mike 

