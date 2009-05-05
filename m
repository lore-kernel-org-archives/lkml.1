Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZEEQPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZEEQPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZEEQP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:15:26 -0400
Received: from waste.org ([66.93.16.53]:38595 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZEEQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:15:25 -0400
Date: Tue, 5 May 2009 11:10:30 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Roland McGrath <roland@redhat.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090505161029.GG31071@waste.org>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain> <m1r5z40yyr.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 08:17:43AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 5 May 2009, Eric W. Biederman wrote:
> > 
> > Yes, not mixing the result back (which would give us some kind of
> > pseudo random number generator) is the problem.
> 
> Guys, so how about this?
> 
> It's a really simple patch that basically just open-codes the current 
> "secure_ip_id()" call, but when open-coding it we now use a _static_ 
> hashing area, so that it gets updated every time.
> 
> And to make sure somebody can't just start from the same original seed of 
> all-zeroes, and then do the "half_md4_transform()" over and over until 
> they get the same sequence as the kernel has, each iteration also mixes in 
> the same old "current->pid + jiffies" we used - so we should now have a 
> regular strong pseudo-number generator, but we also have one that doesn't 
> have a single seed.
> 
> Note: the "pid + jiffies" is just meant to be a tiny tiny bit of noise. It 
> has no real meaning. It could be anything. I just picked the previous 
> seed, it's just that now we keep the state in between calls and that will 
> feed into the next result, and that should make all the difference.
> 
> I made that hash be a per-cpu data just to avoid cache-line ping-pong: 
> having multiple CPU's write to the same data would be fine for randomness, 
> and add yet another layer of chaos to it, but since get_random_int() is 
> supposed to be a fast interface I did it that way instead. I considered 
> using "__raw_get_cpu_var()" to avoid any preemption overhead while still 
> getting the hash be _mostly_ ping-pong free, but in the end good taste won 
> out.

It's an ok model, but I'd be much happier if we used a decent
hash function. I'm not a cryptanalyst, so I can't rattle off all the
known attacks against this hash function, but it can no longer be
considered any kind of cryptographic primitive. I would not be at all
surprised if it was possible to recover the entire secret state by
observing some small set of RNG outputs and then use that to backtrack
the RNG to reveal the layout of a recently launched process.

(Sending off a couple queries to some folks who are good at breaking
such things to confirm my hunches.)

Also, the current function name must go. It is seriously misleading.
get_random_u32 please.

-- 
Mathematics is the supreme nostalgia of our time.
