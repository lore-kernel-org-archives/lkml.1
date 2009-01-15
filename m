Return-Path: <linux-kernel-owner+w=401wt.eu-S1764401AbZAOLVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764401AbZAOLVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZAOLVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:21:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZAOLVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:21:08 -0500
Date: Thu, 15 Jan 2009 12:21:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive
	counter groups
Message-ID: <20090115112100.GC22850@elte.hu>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com> <20090114095743.GA1389@elte.hu> <18798.44766.734357.560006@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18798.44766.734357.560006@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > (btw., the percpu allocation code seems to have bitrotten a bit - the 
> > logic around perf_reserved_percpu looks wrong and somewhat complicated.)
> 
> Yes, it has.  I don't think it was ever fixed to apply only to hardware 
> counters when software counters were added.
> 
> Side question - were you intending to make the various software counters 
> able to act as interrupting counters?  That will mean e.g. that anything 
> that increments current->maj_flt or current->min_flt (i.e. 
> do_page_fault, __get_user_pages) will need to check if that causes any 
> counter to overflow, which could be a bit invasive.

Yes, eventually my intention was to bring all the sw counters up to that 
level, and allow system sampling via sw counter overflows. It's an 
arguably powerful concept.

I first wanted to see where they all go though, and how many of them we 
want, and how nuanced we want to make them.

Initially we can sample via __builtin_return_address(0) addresses, or 
pt_regs(current)->rip or so. Later on we could use save_stack_trace() 
perhaps, for a more vectored sample.

It would result in some rather cool kerneltop output: we could see a 
profile of which functions generate pagefaults, or which places generate 
context-switches, which places migrate a lot, etc.

> > Again, which restrictions users/developers are more willing to live 
> > with will be shown in actual usage of these facilities.
> 
> Indeed.

So my approach was always to have a good guess about what the best usage 
pattern is, but also to not be rigid and ignore/exclude other usecases. 
The main principle of this subsystem is to be maximally useful in 
performance analysis, via modern and flexible abstractions. Pinning and 
exclusivity fits into that just fine - they are mechanism to improve the 
quality of the statistics.

	Ingo
