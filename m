Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbZBYMCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbZBYMCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbZBYMB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:01:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbZBYMBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:01:55 -0500
Date: Wed, 25 Feb 2009 13:01:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090225120139.GB14279@elte.hu>
References: <20090224020304.GA4496@google.com> <200902251909.42928.nickpiggin@yahoo.com.au> <20090225082958.GA9322@elte.hu> <200902251959.05853.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251959.05853.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> No I'm talking about this next case:
> 
> > We can do little about user-space doing stupid things as 
> > doing a big write as a series of many smaller-than-4K 
> > writes.
> 
> Not necessarily smaller than 4K writes, but even as a series 
> of 4K writes. It isn't stupid thing to do if the source memory 
> is always in cache. But if you destination is unlikely to be 
> used, then you still would want nontemporal stores.

I dont disagree that it would be nice to handle that case too, i 
just dont see how.

Unless you suggest some new logic that tracks the length of a 
continuous write to a file, and whether it got read back 
recently, i dont see how this could be done sanely.

That's the deal generally: if an app gives the kernel enough 
information in a syscall, the kernel can act on it reasonably. 

Sometimes, for important cases we allow apps to set attributes 
that function across syscalls too - like here we could extend 
madvise() to hint the kind of access ... but i doubt it would be 
used widely.

Sometimes, for _really_ important cases the kernel will also try 
to auto-detect patterns of use. We do that for readahead and we 
do that for socket buffers - and a few other things. Do you 
suggest we should do it here too?

Anyway ... i wouldnt mind if the lowlevel code used more hints 
if they are present and useful.

And unlike the 'final tail' case which indeed was quirky 
behavior and was worth fixing (hence the 'total' patch), the 
'should the kernel detect many small writes being one real big 
write' question is not a quirk but a highlevel question that the 
lowlevel copy code (nor the lowlevel pagecache code) can answer. 
So it's all a bit different.

> > The new numbers from Salman are convincing too - and his fix
> 
> I'm not exactly convinced. The boundary behaviour condition is 
> a real negative. What I question is whether that benchmark is 
> not doing something stupid. He is quoting the write(2)-only 
> portion of the benchmark, so the speedup does not come from 
> the app reading back results from cache. It comes from either 
> overwriting the same dirty cachelines (a performance critical 
> program should really avoid doing this if possible anyway); or 
> the cached stores simply pipelining better with non-store 
> operations (but in that case you probably still want 
> non-temporal stores anyway because if your workload is doing 
> any real work, you don't want to push its cache out with these 
> stores).
> 
> So, can we find something that is more realistic? Doesn't gcc 
> create several stages of temporary files?

i dont think this is really about performance critical apps, and 
i suspect the numbers will be even more convincing if a read() 
is inserted inbetween.

Lets face it, 99% of the Linux apps out there are not coded with 
'performance critical' aspects in mind.

So what we have to do is to watch out for common and still sane 
patterns of kernel usage - and optimize them, not dismiss them 
with 'this could be done even faster with XYZ'. (As long as it 
does not hurt sane usages - which i think this does not.)

	Ingo
