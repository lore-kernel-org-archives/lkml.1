Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYBNPUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYBNPUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYBNPUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:20:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbYBNPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:20:17 -0500
Date: Thu, 14 Feb 2008 16:19:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080214151953.GA22068@elte.hu>
References: <20080213155725.GA19523@elte.hu> <p73ir0r25t4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir0r25t4.fsf@bingen.suse.de>
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
> > Thomas Gleixner (1):
> >       x86: EFI: fix use of unitialized variable and the cache logic
> 
> Your honor, I would like to register a differing opinion...

As i mentioned it (in the portion of my email that you clipped), there 
are other pending CPA patches in x86.git:

> > [there are more CPA cleanups still brewing but none of that is 
> > urgent.]

We didnt plan to push these secondary alias fixes out yet with 
yesterday's push, and i disagree with you about their urgency.

> I submitted that fix originally in a different form, but it got 
> finally stripped down to this. However in my opinion the full version 
> of the patch is still needed, otherwise EFI still does the mapping 
> wrong.

well, not really. Firtly, and most importantly, can you see any failures 
on any real boxes?

I'd be surprised if you could see any failures, because secondary 
aliases have little practical relevance today. Getting the _primary_ 
alias right is the most important task of CPA and -git does that all 
correctly. (we'd be seeing crashes left and right in -rc1 if it didnt)

Secondary virtual alias discovery indeed has an ugly-looking but 
fortunately harmless bug in -git (fixed in x86.git#mm).

The fix is rather straightforward, but we want to test it some more. 
We'll push the fix probably before -rc2 though, in the next few days.

> On 64bit cpa will still change cache attributes on random low pages 
> and cause illegal caching attribute aliases on both 32bit and 64bit.

Well, this is moot with latest x86.git, but you are still wrong.

Firstly, what we do currently incorrectly (and which is fixed in 
x86.git) is that we do a __pa() on a vmalloc/ioremap-range address on 
64-bit in secondary alias discovery. But as i showed it to you days ago 
in my reply, while it will yield a "random" looking address, but that 
address is a guaranteed-high physical address in the higher than 
0x410000000000 (i.e. 65TB+) physical range, so we'll just return 
harmlessly from the filter function. So yes, it's very much ugly and 
unintended and we've been working on fixing it (and have fixed it).

Secondly, your suggestion that inconsistent caching attribute aliases 
are not permitted is incorrect. They are very much not allowed under 
PAT, and they are "nice to avoid" even on non-PAT (early CPU iterations 
sometimes have erratas in this area), but we always had them in one way 
or another - permanently and temporarily as well. What Linux still 
relies on fundamentally for cache attributes are the MTRR attributes.

Anyway, please take a look at today's x86.git#mm:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

it should handle secondary aliases correctly - but we are still working 
on some other cleanups to make it complete.

If anyone proves us wrong (with a specific example - what is mapped 
where, and what bad effect does it have, or if it's available a 
crashlog, etc.) we'll certainly reconsider.

	Ingo
