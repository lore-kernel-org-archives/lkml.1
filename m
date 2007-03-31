Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXCaQ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXCaQ5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXCaQ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:57:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:24941 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbXCaQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qnVvLiJGgjW7NQDt54PGFiiFl8u196j/ZNasTAF/73l5Jnu4Ar2vfWnE2VokRllaM2b4jOPInugn/NofXcya67+EidhRxW9O23IBDaDXTjHidq1ld54Qg64Z6DREj6M5eysryx1RUYcStBES/hBod88QuvGnBSa8w5QczJufRJI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: tglx@linutronix.de
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Date: Sat, 31 Mar 2007 19:56:35 +0300
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain>
In-Reply-To: <1175356272.28263.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311956.35922.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 18:51:11 Thomas Gleixner wrote:
> On Thu, 2007-03-29 at 15:46 +0200, Maxim Levitsky wrote:
> > Subject: Add suspend/resume for HPET
> > This adds support of suspend/resume on i386 for HPET
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> >
> > +static struct sysdev_class hpet_class = {
> > +	set_kset_name("hpet"),
> > +	.suspend	= hpet_suspend,
> > +	.resume		= hpet_resume,
> > +};
> > +
> > +static struct sys_device hpet_device = {
> > +	.id		= 0,
> > +	.cls		= &hpet_class,
> > +};
> 
> Sorry for being inresponsive. I was travelling and unexpectedly cut off
> from the internet for some days.
> 
> While I agree in principle with the patch, I'm a bit uncomfortable. The
> sys device suspend / resume ordering is not guaranteed and relies on the
> registering order.
> 
> Jeff still seems to have problems with CONFIG_NO_HZ=n and it might be
> caused by time keeping / tick management resume happening before the
> HPET resume.
> 
> The required resume order is:
> 
> clocksources
> timekeeping
> clockevents
> tick management
> 
> I'm not sure how to do this properly with the sys device facilities, but
> I look into it.
> 
> /me goes off to understand the sys device magic.
> 
> 	tglx
> 
> 
> 

Hi,

So maybe I was right afrer all,
Maybe it is better to add a suspend/resume hook to each clock source and call 
it from timekeeping_resume() ?

Or maybe even unite clocksources with clockevents, don't know 

By the way I want to report maybe a bug / maybe a feature :-)  : 
(sorry for long explanation)

Basically I have two clockevent sources : PIT(HPET) and APIC
(Actually I it seems that in next version of kernel HPET will be switched out 
of 'legacy replacement mode' , so PIT and HPET and RTC could coexist of same system,
But HPET won't be able to generate IRQ0, and it will be assigned some IRQ, possibly shared with other devices)

APIC timer  is chosen by default and works fine, 
since I don't have C2/C2 states on my system (ICH8 doesn't support them :-( )

But if I force it off (nolapic_timer) HPET or PIC is chosen and strangely they are
 put in _periodic_ mode although they are capable of one-shot mode
Is this a bug ?

Secondary I am getting a very strange behavior if I use CONFIG_NOHZ + !CONFIG_HIGH_RES_TIMERS
and try to suspend to ram:

System resumes, but gets crazy:
'top' shows that  ksoftirqd consumes 9999 % of cpu time (this is not a typo)
And other 'normal' programs that are running show same 9999 too.
System slows to crawl.

Also I found that one of APICS is in periodic mode,  and second is in one shoot mode.
And I tested this with or without my patch (thank goodness it is not my fault)

CONFIG_NOHZ + CONFIG_HIGH_RES_TIMERS work just fine.

Best regards,
	Maxim Levitsky
