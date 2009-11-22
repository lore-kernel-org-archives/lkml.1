Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZKVLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZKVLIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZKVLIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:08:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40061 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZKVLIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=RX7jogcjyjVQp9AHEaNnzfD8u0TYEbhGDuUb1VkmWDnAv3gWLFX7cCU63xRXY8c1U5
         ee5kbZHMn8Wp1srPHMM5F9jdpQRqGMQx4d6mrW0jG3Jf/y9vPLCBf4l3SP14hfNvZwI3
         k4dsc1NJCCtYV1RKAo7eR7MjUXGBix4DMEdMk=
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
 cnt32_to_63().
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091122081328.GB24558@elte.hu>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
	 <20091122081328.GB24558@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sun, 22 Nov 2009 19:08:05 +0800
Message-ID: <1258888086.4548.52.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > +
> > +	  If unsure, disable it.
> > +
> > +config HR_SCHED_CLOCK_UPDATE
> > +	bool "Update sched_clock() automatically"
> > +	depends on HR_SCHED_CLOCK
> > +	default y
> > +	help
> > +	  Because Some of the MIPS c0 count period is quite short and because
> > +	  cnt32_to_63() needs to be called at least once per half period to
> > +	  work properly, a kernel timer is needed to set up to ensure this
> > +	  requirement is always met.
> 
> s/Some/some
> 

Will apply all of the above feedbacks and the later relative ones,
thanks!

> Why is this a config option? I suspect that hardware that _needs_ this 
> keep-warm periodic tick we should enable it unconditionally and 
> automatically - otherwise the user can misconfigure the kernel with a 
> bad clock.
> 

It will be really hard to let the users make decision, so I tell them to
enable it if not sure. perhaps it's better to remove this option.

but one issue I have found here, if enabled this keep-warm by default, I
can not always get the result of function graph tracer, not sure what
the exact reason is. and even if get the result, lots of them are the
results about timer(that mod_timer() and sched_clock() is called
frequently?).

and as we can see from arch/arm/mach-pxa/time.c, there is also no
keep_warm there, which means that if the frequency of that MIPS is very
low, it will need enough seconds to make that 32bit long c0 count
overrall. so, they will not need this keep-warm. perhaps we can use that
mips_hpt_frequency variable to determine setup that keep-warm or not.
but it's hard to design the number of frequency.

[...]
> > + */
> > +static unsigned long __maybe_unused tclk2ns_scale;
> > +static unsigned long __maybe_unused tclk2ns_scale_factor;
> 
> 
> __read_mostly?
> 

Yes.

[...]
> > +static void __maybe_unused setup_sched_clock_update(unsigned long tclk)
> > +{
> > +	unsigned long data;
> > +
> > +	data = (0xffffffffUL / tclk / 2 - 2) * HZ;

Because the MIPS c0 count's frequency is half of the cpu frequency(Hi,
Ralf, does every MIPS c0 count meet this feature?), so, the above line
should be:

data = (0xffffffffUL / tclk - 2) * HZ;

> > +	setup_timer(&cnt32_to_63_keepwarm_timer, cnt32_to_63_keepwarm, data);
> > +	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
> > +}
[...]
> >  
> > +#ifdef CONFIG_HR_SCHED_CLOCK
> > +	setup_sched_clock(&clocksource_mips);
> > +#endif
> >  	clocksource_register(&clocksource_mips);
> >  
> > +#ifdef CONFIG_HR_SCHED_CLOCK_UPDATE
> > +	setup_sched_clock_update(mips_hpt_frequency);
> > +#endif
> >  	return 0;
> 
> You could make the functions inline and move the #ifdef into those 
> functions.
> 
> That wold also remove those __maybe_unused tags.
> 

will apply it, thanks ;)

Regards,
	Wu Zhangjin

