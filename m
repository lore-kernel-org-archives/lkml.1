Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZEEGCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZEEGCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZEEGCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:02:44 -0400
Received: from waste.org ([66.93.16.53]:54952 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZEEGCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:02:43 -0400
Date: Tue, 5 May 2009 00:50:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090505055011.GE31071@waste.org>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 03:24:15PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 4 May 2009, Eric W. Biederman wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > On Mon, 4 May 2009 12:00:12 -0700 (PDT)
> > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > >
> > >> 
> > >> 
> > >> On Mon, 4 May 2009, Jake Edge wrote:
> > >> >
> > >> > This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
> > >> > wchan to non-privileged processes", adding some of Eric Biederman's
> > >> > suggestions as well as the start_stack change (only give out that
> > >> > address if the process is ptrace()-able).  This has been tested
> > >> > with ps and top without any ill effects being seen.
> > >> 
> > >> Looks sane to me. Anybody objects?
> > >> 
> > >
> > > Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Looks sane here.
> > 
> > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Ok, applied.
> 
> Also, does anybody have any commentary or opinion on the patch by Matt 
> Mackall to use stronger random numbers than "get_random_int()". I wonder 
> what the performance impact of that is - "get_random_int()" is very cheap 
> by design, and many users may consider calling "get_random_bytes()" to be 
> overkill and a potential performance issue.
> 
> Quite frankly, the way "get_random_bytes()" works now (it does a _full_ 
> sha thing every time), I think it's insane overkill. But I do have to 
> admit that our current "get_random_int()" is insane _underkill_.
> 
> I'd like to improve the latter without going to quie the extreme that 
> matt's patch did.

ASLR aside, get_random_u32 is the right interface (strong,
well-defined type) for random.c to export and get_random_int (weak,
ambiguous type) is the wrong one.

As to what's the appropriate sort of RNG for ASLR to use, finding a
balance between too strong and too weak is tricky. I'd rather move
things to a known safe point and back it off to acceptable performance
from there if anyone complains. So let's do my patch now.

Looking forward:

A faster-but-weakened RNG for ASLR (and similar purposes) will still
need to be strong in the cryptographic sense. Which probably means
having secret state (per cpu?) that changes at every call via a strong
cipher or hash (though lighter than the full RNG). Alternately, we use
a weak primitive (eg halfmd4) with per-task secrets. Not really keen
on the latter as a user may expose outputs across task boundaries that
allow backtracking attacks against the ASLR. In other words, the
latter requires disciplined users, while the former doesn't.

-- 
Mathematics is the supreme nostalgia of our time.
