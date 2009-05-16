Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZEPK01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZEPK01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 06:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZEPK0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 06:26:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZEPK0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 06:26:15 -0400
Date: Sat, 16 May 2009 12:25:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86: update_mptable need pci_routeirq
Message-ID: <20090516102555.GA6261@elte.hu>
References: <4A0DC7DC.7000204@kernel.org> <200905151552.53139.bjorn.helgaas@hp.com> <4A0DE6C5.6060903@kernel.org> <200905151608.25250.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905151608.25250.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Friday 15 May 2009 04:03:49 pm Yinghai Lu wrote:
> > Bjorn Helgaas wrote:
> > > On Friday 15 May 2009 03:13:20 pm Yinghai Lu wrote:
> > >> Bjorn Helgaas wrote:
> > >>> On Friday 15 May 2009 01:51:56 pm Yinghai Lu wrote:
> > >>>> to get all device irq routing and save them
> > >>> This changelog isn't really enough for me to understand
> > >>> what's going on.
> > >>>
> > >>>> Index: linux-2.6/arch/x86/kernel/mpparse.c
> > >>>> ===================================================================
> > >>>> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> > >>>> +++ linux-2.6/arch/x86/kernel/mpparse.c
> > >>>> @@ -17,6 +17,7 @@
> > >>>>  #include <linux/acpi.h>
> > >>>>  #include <linux/module.h>
> > >>>>  #include <linux/smp.h>
> > >>>> +#include <linux/pci.h>
> > >>>>  
> > >>>>  #include <asm/mtrr.h>
> > >>>>  #include <asm/mpspec.h>
> > >>>> @@ -961,6 +962,7 @@ static int __initdata enable_update_mpta
> > >>>>  static int __init update_mptable_setup(char *str)
> > >>>>  {
> > >>>>  	enable_update_mptable = 1;
> > >>>> +	pci_routeirq = 1;
> > >>> I hate to see new uses of pci_routeirq.  It'd be nice to remove it
> > >>> completely someday.  But maybe it can't be helped.
> > >>>
> > >>>>  	return 0;
> > >>>>  }
> > >>>>  early_param("update_mptable", update_mptable_setup);
> > >>> "update_mptable" is apparently a boot option, but it's not mentioned
> > >>> in Documentation/kernel-parameters.txt.  Is this some sort of debug
> > >>> code or BIOS-writer's helper?  Same with "alloc_mptable".  Why do
> > >>> we have this stuff?
> > >>>
> > >> 1. kexec path: after acpi kernel and use kexec to load kerenl with mptable support only or acpi=off
> > >> 2. help to BIOS engineer to understand how to set mptable and irq routing setup by chipset.
> > >>    esp system have several cards and there is bridge in those cards.
> > ...
> > > Is (1) common enough to worry about?  What OSes don't have ACPI
> > > support?  What advantage is there to using "acpi=off"?
> > ...
> > 
> > some one want to disable acpi, because acpid is using 100%...
> 
> I'd rather fix the problem with acpid than make it easier to use 
> "acpi=off".

Well, acpi=off is frequently used. Besides of that, there's a design 
and future-proof-ness issue as well: having a correct mptable is 
good in sense of not having all our collective eggs in the ACPI 
basket. ACPI also has IP attached and there are vendors who are 
loathe to use it for one reason or another.

So as long as Yinghai is willing to maintain this path and is 
willing to keep it correct, and as long as we _have_ an acpi=off 
option in the upstream kernel it makes sense to make the kexec 
environment as correct and inclusive as possible.

acpid looping should of course be fixed separately. Almost all 
distros ship with acpi enabled so there's no shortage of bugs being 
reported, and there's no need to artificially make it harder for 
people to not use acpi if they so choose.

	Ingo
