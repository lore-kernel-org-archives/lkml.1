Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXHIVQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXHIVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXHIVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:16:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38513 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXHIVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:16:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WVCuSP/6WPpiszpBv2+Z3fh2le1bru5zot9QFbbHmDKoIL75JcY8azmmeI5ImAoYX
	6dd1RVmvpv48APu87unkQ==
Message-ID: <8f95bb250708091416w5fd4981ds667164d1c9fe9296@mail.gmail.com>
Date: Thu, 9 Aug 2007 14:16:16 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Cc: linux-kernel@vger.kernel.org, ak@suse.de, "Robin Holt" <holt@sgi.com>
In-Reply-To: <20070809133011.2d03c04a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808231719.GA7101@google.com>
	 <20070809133011.2d03c04a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 8 Aug 2007 16:17:19 -0700
> Aaron Durbin <adurbin@google.com> wrote:
>
> > In setup_APIC_timer with the HPET in use, a condition can arise while
> > waiting for the next irq slice to expire on the HPET which will either
> > cause an NMI watchdog to fire or a 3 minute busy loop if the NMI
> > watchdog is disabled.
> >
> > The HPET comparator and the counter keep incrementing during its normal
> > operation. When a comparison event fires the comparator will increment
> > by the designated period. If the HPET trigger occurs right after
> > the 'int trigger = hpet_readl(HPET_T0_CMP);' line, we will will spin
> > for up to 3 minutes (with a clock of 25MHz) waiting for the HPET
> > counter to wrap around. However, when the NMI watchdog is enabled the
> > NMI watchdog will detect a lockup and reboot the machine. This
> > scenario can be exasperated by the presence of an SMI which will
> > increase the window of opportunity for the condition to occur.
> >
> > The fix is to wait for the compartor to change which signals the
> > end of the tick slice.
> >
> > ---
> >
> > The last patch had a typo in the diff which really would cause the
> > problem state above. Sorry.
> >
> > diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
> > index 900ff38..06797e2 100644
> > --- a/arch/x86_64/kernel/apic.c
> > +++ b/arch/x86_64/kernel/apic.c
> > @@ -791,10 +791,12 @@ static void setup_APIC_timer(unsigned in
> >
> >       /* wait for irq slice */
> >       if (hpet_address && hpet_use_timer) {
> > +             /*
> > +              * Wait for the comparator value to change which signals that
> > +              * the tick slice has expired.
> > +              */
> >               int trigger = hpet_readl(HPET_T0_CMP);
> > -             while (hpet_readl(HPET_COUNTER) >= trigger)
> > -                     /* do nothing */ ;
> > -             while (hpet_readl(HPET_COUNTER) <  trigger)
> > +             while (trigger == hpet_readl(HPET_T0_CMP))
> >                       /* do nothing */ ;
> >       } else {
> >               int c1, c2;
>
> but, but.  Didn't this get fixed by
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm1/broken-out/fix-hpet-init-race.patch
> ?
>

That original patch looks good to me as well. I just checked git head to see if
this was already fixed upstream, and it didn't appear to be. Sorry for the
duplicate patch.

-Aaron
