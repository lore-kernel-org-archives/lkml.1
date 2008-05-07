Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYEGUx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYEGUx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYEGUxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:53:09 -0400
Received: from www.tglx.de ([62.245.132.106]:43053 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYEGUxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:53:06 -0400
Date: Wed, 7 May 2008 22:52:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507124650.GD29935@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Adrian Bunk wrote:

Can you please stop changing the subject lines? There is no need that
you grandstand your important findings.

> > >  Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The
> > > commit message for that change is completely and totally unhelpful.
> > 
> > others like to to whitebox methods, ..., please try attach patch to
> > see if duron support PAT.
> 
> 
> There surely is documentation available covering this?

There is, but there is no known validation of working CPUs, erratas
...

We have a well identified set of CPUs which can handle PAT and we dont
want to open up a can of worms by unconditionally enabling it on any
piece of silicon which claims to support PAT. This was made clear from
the first submission of PAT.

Also there is no downside on these older systems. They are fine with
MTRRs and have been for years. We can revisit that once PAT support
has stabilized.

> And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then 
> manual setting of X86_FEATURE_PAT at all?

The reason is to make cpu_has_pat a useful check and to avoid checking
cpu vendors, families and models inside of the PAT code. That's a good
thing actually, because the PAT code only cares about that cpu_has_pat
flag.

Clearing it in the cpuinfo is just a cosmetic side effect which does
no harm at all.

> There's no indication in the code, and as Rene already says there's even
> no description at all in commit 9307cacad0dfe3749f00303125c6f7f0523e5616
>
> Such code really needs a comment explaining why we have to do this at all.

Yes, that's a valid complaint. The changelog is pretty useless.
 
> There must be some CPUs with the "pat" flag set but not being usable?
> Which?

See above.

> According to the linux-kernel discussions there might not be any broken 
> CPU at all - but in this case the whitelist will not fill itself, and 
> expecting people to note that their flags changed and complaining is not 
> really a good approach.

But this is a much better approach than enabling it on everything and
getting flooded with hard to debug problems. PAT can fire back in
various ways and restricting the stabilization of new software to a
set of working hardware is just basic good engineering practice.

> And that your commit added the same clear/set code in three different 
> places doesn't look good - this really deserved from the beginning being 
> factored out into an own function to avoid future problems when CPUs get 
> added (like what happens with your patch here - it touches only one 
> place, and since the same context is present in two places in the same 
> file "patch" might even choose freely where it gets applied...).

Did you even look into the code which does all this feature trickery
based on CPU vendors, families and models ? This is something which
can not be changed easily. It's on our todo list and you wouldnt have
noticed if 32 and 64 bit would still live in different trees.

This feature and detection code is hard to clean up and definitely out
of the scope of this patch.

> Guys, even if it compiles in all randconfig configurations and works on 
> all test machines this is exactly the kind of stuff that causes 
> headaches in the future.

Dude, we are working hard to get x86 in shape, but we can not change
it over in no time except if we stop development on x86 completely for
two kernel versions. No, we have to clean this up gradually and accept
that there is still duplicated code moving in.

> And this patch (by the author of the code himself) is the first time 
> where it breaks.

Very interesting analysis. What broke ? This CPU was never in the set
of supported ones at all.

Anyway, you are welcome to review x86 code - it can definitely use
more eyeballs, but please try to inform yourself about the topic or
ask polite questions before yelling at people who contribute in a
very valuable way.

Thanks,

	tglx
