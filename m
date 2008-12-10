Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYLJQ15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYLJQ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYLJQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:27:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756118AbYLJQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:27:31 -0500
Date: Wed, 10 Dec 2008 08:26:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume (was: Regression from
 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
In-Reply-To: <200812101705.18899.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
References: <200812020320.31876.rjw@sisk.pl> <200812101506.45691.elendil@planet.nl> <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain> <200812101705.18899.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo - who's the main apic person these days?

On Wed, 10 Dec 2008, Frans Pop wrote:

> On Wednesday 10 December 2008, Linus Torvalds wrote:
> > On Wed, 10 Dec 2008, Frans Pop wrote:
> > > Anybody interested in persuing this issue?
> > >
> > > > The third thing that worries me is the _very_ early occurrence of
> > > >
> > > > 	ACPI: Waking up from system sleep state S3
> > > > 	APIC error on CPU1: 00(40)
> > > > 	ACPI: EC: non-query interrupt received, switching to interrupt
> > > > mode
> >
> > Well, the "too early" part is fixed with the PCI resume changes in
> > -next, and googling for "APIC error on CPU1: 00(40)" shows that it's
> > actually pretty common. Which is sad, but makes it somewhat less scary.
> >
> > The fact that it happens at resume for you (and not randomly) does
> > imply that we perhaps don't have a wonderful APIC wakeup sequence and
> > are doing something slightly wrong. But it likely isn't a big deal.
> >
> > Is that message new? If it is, maybe you can pinpoint roughly when it
> > started happening, and we could try guess which change triggered it.
> 
> It's been there since 2.6.26.3, which was the first kernel I've run on 
> this notebook.

Hmm. Our IO-APIC reprogramming looks pretty simple, and may well be 
correct.

However, it looks like our _local_ APIC suspend/resume is a total piece of 
sh*t.  It's set up as a "system device" and has a single suspend/resume 
buffer, but the local APIC is a per-CPU thing. We even have a comment 
there (written by yours trule back in 2003!) that says:

         * FIXME! This will be wrong if we ever support suspend on
         * SMP! We'll need to do this as part of the CPU restore!

and back then suspend/resume on SMP was just a crazy notion, but now it's 
obviously every-day reality. 

So it looks like we don't reprogram the APIC -at-all- on secondary CPU's.

What am I missing?

			Linus
