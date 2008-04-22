Return-Path: <linux-kernel-owner+w=401wt.eu-S1763772AbYDVTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763772AbYDVTKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761583AbYDVTKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:10:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764023AbYDVTKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:10:08 -0400
Date: Tue, 22 Apr 2008 21:09:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Message-ID: <20080422190901.GA1104@elte.hu>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org> <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422095315.GA28014@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Yesterday I did 2 suspend/resumes after 1 hour of uptime and ran 
> > git-status for a fraction of a second until it was killed. So I can 
> > perfectly reproduce it when I suspend, resume and produce some io 
> > load. I guess it's time to bisect 2.6.25-rc8-mm2 as I'm able to 
> > reproduce it the best and haven't seen that bug in -rc8-mm1 for over 
> > week of suspending and working.
> 
> the most dangerous x86 change we added was the PAT stuff. Does it 
> influence the crashes in any way if you boot with 'nopat' or if you 
> disable CONFIG_X86_PAT=y into the .config?

note that full PAT (where in essence Linux takes over control of the 
cache attributes via PTEs, instead of relying on the BIOS initialized 
MTRRs alone) you should only get with -mm or with x86.git applied.

I.e. x86 PAT might explain any -mm issue but not the upstream -git 
issue.

In upstream -git we dont have the second wave of the PAT changes applied 
yet (the /dev/mem bits) so CONFIG_X86_PAT is not yet activated. (it's 
only safe to enable if we have all the changes together and perfectly 
control all cache attributes in the system)

i.e. PAT complications here would not happen in form of real cache 
attribute conflicts [i.e. the lockups and corruptions cannot be due to 
that] - but as side-effects to other code it changes.

and most of the PAT failures we ever saw had different patterns anyway: 
the leading failure was API rejections and hence non-working Xorg or 
non-working ioremap() in certain drivers. The worst-case scenario, early 
in the PAT code's cycle, was a spontaneous triple fault - months ago.

the basis for the PAT changes was the hardening of the CPA code and its 
general use for everything (such as DEBUG_PAGEALLOC). And much of that 
happened and was finished in v2.6.25. Nothing conceptually new really 
happened there - and even where we touched the code in .26 it happened 
long ago and would have surfaced by now.

... but ... nothing can be excluded.

	Ingo
