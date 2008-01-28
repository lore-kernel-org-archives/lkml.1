Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYA1REZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYA1REZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYA1RES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:04:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYA1RER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:04:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 18:02:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <20080128150022.GE27928@elte.hu> <20080128161239.GA28906@elte.hu>
In-Reply-To: <20080128161239.GA28906@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281802.01748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Ingo Molnar wrote:
> 
> > >   * driver might have split up a kernel 4MB mapping.
> > >   */
> > > -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> > > +char swsusp_pg_dir[PAGE_SIZE]
> 
> hm, random-qa found build breakage with this patch:
> 
>  arch/x86/kernel/built-in.o: In function `wakeup_start':
>  : undefined reference to `swsusp_pg_dir'
> 
> config attached.

I see.  CONFIG_HIBERNATION && CONFIG_ACPI -> CONFIG_ACPI_SLEEP
and the Makefile in arch/x86/kernel/acpi/ wants to build wakeup.S, which is
not necessary.  Hmm.

We can do a couple of things:
(1) make wakeup_$(BITS).o depend on CONFIG_SUSPEND (alone)
    This will build it if CONFIG_SUSPEND is set, but CONFIG_ACPI is not
    (still, that's consistent with the change in question).
(2) make wakeup_$(BITS).o depend on CONFIG_SUSPEND and CONFIG_ACPI
(3) define CONFIG_ACPI_SUSPEND depending on ACPI and SUSPEND and
    make wakeup_$(BITS).o as well as swsusp_pg_dir depend on that (most
    elegant)

Which one do you prefer?

In case you choose (3), please drop the patch and I'll send a new one to Len.

Thanks,
Rafael
