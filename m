Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbZEGSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbZEGSTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZEGSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:19:05 -0400
Received: from waste.org ([66.93.16.53]:54268 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZEGSTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:19:01 -0400
Date: Thu, 7 May 2009 13:14:34 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090507181434.GL31071@waste.org>
References: <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <20090507005016.GJ31071@waste.org> <20090507150231.GB2344@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507150231.GB2344@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:02:31PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Wed, May 06, 2009 at 12:57:17PM -0500, Matt Mackall wrote:
> > > On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
> > > > 
> > > > Matt, are you willing to ack my suggested patch which adds history to the 
> > > > mix? Did somebody test that? I have this memory of there being an 
> > > > "exploit" program to show the non-randomness of the values, but I can't 
> > > > recall details, and would really want to get a second opinion from 
> > > > somebody who cares about PRNG's.
> > > 
> > > I still don't like it. I bounced it off some folks on the adversarial
> > > side of things and they didn't think it looked strong enough either.
> > > Full MD5 collisions can be generated about as fast as they can be
> > > checked, which makes _reduced strength_ MD4 not much better than an
> > > LFSR in terms of attack potential. So I suggest we either:
> > > 
> > > a) take my original patch 
> > > b) respin your patch using at least SHA1 rather than halfMD4 and
> > > changing the name to get_random_u32
> > > 
> > > If you'd prefer (b), I'll do the legwork.
> > 
> > I've done some basic benchmarks on the primitives here in userspace:
> > 
> > halfMD4 get_random_int: about .326us per call or 12.2MB/s
> > sha1 get_random_int: about .660us per call or 6.1MB/s
> > dd /dev/urandom: 3.6MB/s
> > 
> > So I think the SHA1 solution is quite competitive on the 
> > performance front with far fewer concerns about its strength. I'll 
> > spin a proper patch tomorrow.
> 
> Hm, i'm not happy about that at all - that's like a ~2000 cycles 
> cost, probably fully cached! Do you have cache-cold numbers as well?

No, but you're free to benchmark my forthcoming patch. Given that I
haven't heard of anyone complaining about performance regressions in
exec() from the introduction of ASLR (nor can I find any on Google),
I've assumed doubling the RNG overhead would continue to remain in the
noise.

>  aldebaran:~/l> ./lat_proc fork
>  Process fork+exit: 61.7865 microseconds

Uh, what? There's no exec() involved in fork+exit, so hopefully ASLR
doesn't decide to make an appearance.

> As i mentioned it in the previous mail, i'd _really_ like to hear 
> your thread model and attack vector description. Does this overhead 
> justify the threat? Your change will only result in get_random_int() 
> not being considered fast anymore.

My threat model is that someone more clever and with a lot more
expertise attacking systems than either you or me will be able to
leverage the extreme weakness of this hash (O(1) attacks against the
*full* version!) into an attack that incrementally exposes the hidden
RNG state. I've asked a couple such people whether they think that's
likely, and they've said yes.

In fact, it's been known for over a decade that reduced-round MD4 such
as ours is *not one way* and that preimages (aka our hidden state) can
be found in less than an hour on a *mid-90s era PC*:

http://citeseer.ist.psu.edu/old/182935.html

Combine that with greatly improved techniques for attacking hashes in
the MD4 family in the last five years and you're probably looking at
less than a second of CPU time. Combine that with the fact that we're
using the hash in a feedback mode, and things only get easier.

On the question of 'what if we add in the TSC?', I'd first say (a) we
can't and shouldn't assume a TSC is available, though we certainly
should use it if it is. Second I'd say that there are numerous timing
attacks that have been done that suggest that guessing the TSC can be
done with useful probability. For instance, see the branch prediction
attacks against AES and RSA.

-- 
Mathematics is the supreme nostalgia of our time.
