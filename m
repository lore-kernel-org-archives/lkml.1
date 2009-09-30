Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZI3XKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZI3XKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZI3XKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:10:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbZI3XKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:10:00 -0400
Date: Thu, 1 Oct 2009 01:09:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       torvalds@osdl.org
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930230947.GA9346@elte.hu>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu> <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930223956.GE17712@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Wed, Sep 30, 2009 at 11:48:59PM +0200, Ingo Molnar wrote:
> > I.e. something like the patch below. Completely untested.
> 
> [..]
> 
> > Note, while looking at the interaction of decode_mce() with the other 
> > MCE code i also noticed a few other things and made the following 
> > cleanups/fixes:
> > 
> >  - Fixed the mce_decode() weak alias - a weak alias is really not good
> >    here, it should be a proper callback. A weak alias will be overriden
> >    if a piece of code is built into the kernel - not good, obviously.
> 
> The original idea was for the edac_mce_amd.o module to override the 
> weak symbol but the problem with that is that when CONFIG_CPU_SUP_AMD 
> is set, MCE decoding is built in by default thus overriding the weak 
> symbol even on non-AMD systems running distro kernels with multiple 
> x86 CPU types support. Your patch solves that.
> 
> However, currently we can't get rid of the decoding code when booted 
> on non-AMD boxes - it amounts to ~ 15K of object code on non-debug 
> builds. Is it worth the trouble to add it to initmem on such boxes and 
> remove it during boot?

it's ~5K here. Btw., how would that work? Initmem cannot generally be 
discarded optionally like that.

But even if it's 15K, as long as it's in well-concentrated code staying 
out of the hotpath (which it is here) is not nearly as much of a problem 
as forms of bloat affecting the hotpath. We do have other forms of CPU 
support code too which could remove an equal amount of code.

Generally, if your hardware is so constrained that it cannot keep 
general x86 compatibility code around, you will build a specific bzImage 
tailored specifically to that hardware environment. Such a box can 
twiddle the existing config options just fine to include (or exclude) 
this code.

> >  - The patch initializes the callback on AMD family 10h and 11h - a
> >    quick glance suggests that decoding of earlier models isnt supported?
> 
> Actually, the K8 error types and messages should be decoded just fine 
> too. I'll doublecheck and adjust the family check accordingly.

Ok.

Thanks,

	Ingo
