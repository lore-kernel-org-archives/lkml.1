Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYIHO0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYIHO0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIHO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:26:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYIHO0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:26:34 -0400
Date: Mon, 8 Sep 2008 16:26:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080908142619.GA10580@elte.hu>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C46BCB.2060209@goop.org>
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

> >> However, unlike early_ioremap(), __acpi_map_table() just maintains 
> >> a single mapping which gets replaced each call, and has no 
> >> corresponding unmap function.  Implement this by just removing the 
> >> previous mapping each time its called.  Unfortunately, this will 
> >> leave a stray mapping at the end.
> >
> > It would be better to just fix the ACPI code to unmap.
> 
> I was concerned that would cause lots of cross-arch churn, but of 
> course the only other relevant architecture is ia64.  I'll prep a 
> followup patch.

uhm, there's a nasty trap in that route: it can potentially cause a lot 
of breakage.

It's not robust to assume that the ACPI code is sane wrt. 
mapping/unmapping, because it currently simply doesnt rely on robust 
unmapping (in the linear range).

I tried it in the past and i found tons of crappy ACPI code all around 
that just never unmapped tables. Leaking ACPI maps are hard to find as 
well, and it can occur anytime during bootup.

As a general principle it might be worth fixing those places, and we've 
hardened up the early-ioremap code for leaks during the PAT rewrite, 
still please realize that it can become non-trivial and it might cause a 
lot of unhappy users.

So i'd suggest a different, more carful approach: keep the new code you 
wrote, but print a WARN()ing if prev_map is not unmapped yet when the 
next mapping is acquired. That way the ACPI code can be fixed gradually 
and without breaking existing functionality.

There's another complication: ACPI might rely on multiple mappings being 
present at once, so unmapping the previous one might not be safe. But it 
_should_ be fine most of the time as __acpi_map_table() is only used 
inearly init code - and we fixed most of these things in the PAT 
patchset in any case.

	Ingo
