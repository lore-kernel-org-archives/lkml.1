Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYAYPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYAYPKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYAYPKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:10:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50612 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbYAYPKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:10:31 -0500
Date: Fri, 25 Jan 2008 16:10:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
Message-ID: <20080125151017.GB11846@elte.hu>
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com> <20080125142150.GA27767@elte.hu> <p73ir1i7y1t.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir1i7y1t.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> >
> > what we should probably do instead is to have a filter function:
> >
> >    new_end = trim_range_to_mtrr_cached(start, end);
> >
> > and then we could iterate through every e820 map entry that is 
> > marked as usable RAM, and send it through this filter. If the filter 
> > returns the same value that got passed in, we keep the e820 entry 
> > unchanged. If the filter returns a new "end" value, we use that in 
> > the e820 map.
> 
> To be fully generic you would need to allow it to adjust start too.

no, to be fully generic it would have to be able to 'split' e820 entries 
up and punch holes into them - but we dont want to go that far i think. 
The most common problem is mismatch at the end of a range.

but what matters more is to have full, generic _detection_ of the 
problem - and that's what we dont do right now. (and that's what my 
reply outlines)

The _fixup_ which we base on this information can then be anything from 
"trivially trim the end" up to a complex "punch holes" solution or the 
simplest "print nasty warning message and do nothing else" solution.

> > that way, the current Tom2 hack is just a natural extension to the 
> > filter function: it would (on AMD CPUs) recognize (within 
> > trim_range_to_mtrr_cached filter) that all memory addresses above 
> > 4GB are marked as cacheable via Tom2.
> >
> > Or something like this. Hm?
> 
> I agree that would be the correct way to do it.
> 
> Later on with PAT that filter could also do PAT related checks and 
> something like this will likely be needed anyways.

a "what is the effective MTRR caching attribute of this physical 
address" type of function would benefit PAT too, yes.

	Ingo
