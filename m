Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYJ3WFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYJ3WFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYJ3WFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:05:04 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51766 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYJ3WFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:05:02 -0400
Subject: Re: [PATCH] fix ACPI induced voyager compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081030215819.GI30303@elte.hu>
References: <1225400518.19324.11.camel@localhost.localdomain>
	 <20081030215819.GI30303@elte.hu>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 17:04:59 -0500
Message-Id: <1225404299.19324.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 22:58 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > >From c339b7cdc39399855ec07dfbff67304f9c7fa49a Mon Sep 17 00:00:00 2001
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Wed, 29 Oct 2008 10:58:13 -0500
> > Subject: [VOYAGER] x86: don't pull asm/acpi.h into fixmap_32.h
> > 
> > If it's not needed it causes compile failures.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  arch/x86/include/asm/fixmap_32.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
> > index 09f29ab..c3302ee 100644
> > --- a/arch/x86/include/asm/fixmap_32.h
> > +++ b/arch/x86/include/asm/fixmap_32.h
> > @@ -25,7 +25,9 @@ extern unsigned long __FIXADDR_TOP;
> >  
> >  #ifndef __ASSEMBLY__
> >  #include <linux/kernel.h>
> > +#ifdef CONFIG_ACPI
> >  #include <asm/acpi.h>
> > +#endif
> 
> hm, that's quite ugly - such headers are supposed to be safe even if 
> CONFIG_APIC is not turned on.
> 
> What kind of compiler failures are you getting, could you send the 
> .config that triggers it? I'm curious what the real cause of the build 
> failure is - the #ifdef you are adding seems to fix a symptom, not a 
> real bug - and maybe we can do a better fix.

It's the problem of voyager wanting its own definition of
phys_cpu_present_map.  acpi.h pulls in mpspec.h which contaminates the
voyager_smp.c build.

Realistically, I was surprised that's the only problem, since mpspec.h
contains an awful lot of apic related stuff.

It was you who did this with:

commit 4c1cbafb88490757a38119c41229251369bcecbc
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jun 3 09:28:52 2008 +0200

    x86 mpparse: build fix

James


