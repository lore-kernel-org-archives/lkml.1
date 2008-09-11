Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbYIKHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYIKHeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYIKHeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:34:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYIKHd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:33:59 -0400
Date: Thu, 11 Sep 2008 09:33:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080911073337.GF27877@elte.hu>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C7FA91.9050302@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> >> So i'd suggest a different, more carful approach: keep the new code 
> >> you wrote, but print a WARN()ing if prev_map is not unmapped yet when 
> >> the next mapping is acquired. That way the ACPI code can be fixed 
> >> gradually and without breaking existing functionality.
> >>     
> >
> > ok, i stuck in your patches into tip/master today and -tip testing 
> > quickly found an early-ioremap leak:
> >
> > [   36.625100] calling  check_early_ioremap_leak+0x0/0x3d
> > [   36.630253] ------------[ cut here ]------------
> > [   36.634884] WARNING: at arch/x86/mm/ioremap.c:577 check_early_ioremap_leak+0x28/0x3d()
> > [   36.642811] Debug warning: early ioremap leak of 1 areas detected.
> >
> > find the full log below with ioremap-leak-tracing turned on. I've 
> > excluded these commits for now from tip/master.
> >   
> 
> Yes, that leak is expected, unfortunately.  __acpi_map_table() has no 
> corresponding unmap, and only maintains one mapping.  So it will leak 
> its last mapping when it switches over from using __acpi_map_table() 
> to ioremap().
> 
> So, yes, its ugly, but its guaranteed to be a single leaked mapping. 
> But I'm not sure what the best approach to deal with it is.

the false positive should be avoided, for example by unmapping the 
'prev' mapping shortly before the leak check.

> (All those other backtraces are just informational, right?)

no, they cause hard failures in my test setup. Nor do we want to litter 
the bootup log with messages that are not correct.

	Ingo
