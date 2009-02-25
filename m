Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbZBYI7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbZBYI7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZBYI7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:59:43 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:23924 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752979AbZBYI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:59:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ydRHhbNwG8KmHA29Xqh/D+5H6y2EJPn/RnzsA7kwXRrbk4fSPlhXsC2tGINKlW+TLmz/M1aMZuz2qYkAix3Q2PFKVAFEq0s5RiAU3hPsybi8aJreGVULShwqeBOLc2Vt7jSchtLOHMdUbashfsPO2rYpZ16S1Xf45PYDOGAfRMQ=  ;
X-YMail-OSG: 8aafKZIVM1mC2KUfMnBXGl7kpfq1lTn94hKKsI4aIO1eTCEC0eJN0Jt8AR5sko5itzfVWJe55oWJu0P6MfaOF9eFdjytpxuzfVlhgYgZXYe7g0X0JkXa58BAP8JNFNqCbP4R324wEI_kUQ4hSkjtk0R4U.2oahkLI8zZJHLKnNA5f.GTAD.RhK3gDp5WQo0giV4XoC5dB.PogTV0RJzB4cGwbzK_o.dQick-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Wed, 25 Feb 2009 19:59:05 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902251909.42928.nickpiggin@yahoo.com.au> <20090225082958.GA9322@elte.hu>
In-Reply-To: <20090225082958.GA9322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251959.05853.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 19:29:58 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 25 February 2009 18:25:03 Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > On Wednesday 25 February 2009 02:52:34 Linus Torvalds wrote:
> > > > > On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > > > > > it does make some kind of sense to try to avoid the noncached
> > > > > > > versions for small writes - because small writes tend to be for
> > > > > > > temp-files.
> > > > > >
> > > > > > I don't see the significance of a temp file. If the pagecache is
> > > > > > truncated, then the cachelines remain dirty and so you can't
> > > > > > avoid an eventual store back to RAM?
> > > > >
> > > > > No, because many small files end up being used as scratch-pads
> > > > > (think shell script sequences etc), and get read back immediately
> > > > > again. Doing non-temporal stores might just be bad simply because
> > > > > trying to play games with caching may simply do the wrong thing.
> > > >
> > > > OK, for that angle it could make sense. Although as has been
> > > > noted earlier, at this point of the copy, we don't have much
> > > > idea about the length of the write passed into the vfs (and
> > > > obviously will never know the higher level intention of
> > > > userspace).
> > > >
> > > > I don't know if we can say a 1 page write is nontemporal, but
> > > > anything smaller is temporal. And having these kinds of
> > > > behavioural cutoffs I would worry will create strange
> > > > performance boundary conditions in code.
> > >
> > > I agree in principle.
> > >
> > > The main artifact would be the unaligned edges around a bigger
> > > write. In particular the tail portion of a big write will be
> > > cached.
> > >
> > > For example if we write a 100,000 bytes file, we'll copy the
> > > first 24 pages (98304 bytes) uncached, while the final 1696
> > > bytes cached. But there is nothing that necessiates this
> > > assymetry.
> > >
> > > For that reason it would be nice to pass down the total size of
> > > the write to the assembly code. These are single-usage-site APIs
> > > anyway so it should be easy.
> > >
> > > I.e. something like the patch below (untested). I've extended
> > > the copy APIs to also pass down a 'total' size as well, and
> > > check for that instead of the chunk 'len'. Note that it's
> > > checked in the inlined portion so all the "total == len" special
> > > cases will optimize out the new parameter completely.
> >
> > This does give more information, not exactly all (it could be
> > a big total write with many smaller writes especially if the
> > source is generated on the fly and will be in cache, or if the
> > source is not in cache, then we would also want to do
> > nontemporal loads from there etc etc).
>
> A big total write with many smaller writes should already be
> handled in this codepath, as long as it's properly iovec-ed.

No I'm talking about this next case:

> We can do little about user-space doing stupid things as doing a
> big write as a series of many smaller-than-4K writes.

Not necessarily smaller than 4K writes, but even as a series of 4K
writes. It isn't stupid thing to do if the source memory is always
in cache. But if you destination is unlikely to be used, then you
still would want nontemporal stores.


> > > This should express the 'large vs. small' question
> > > adequately, with no artifacts. Agreed?
> >
> > Well, no artifacts, but it still has a boundary condition
> > where one might cut from temporal to nontemporal behaviour.
> >
> > If it is a *really* important issue, maybe some flags should
> > be incorporated into an extended API? It not, then I wonder if
> > it is important enough to add such complexity for?
>
> the iozone numbers in the old commits certainly are convincing.

Yes. The common case should be not touching the page again.


> The new numbers from Salman are convincing too - and his fix

I'm not exactly convinced. The boundary behaviour condition is a
real negative. What I question is whether that benchmark is not
doing something stupid. He is quoting the write(2)-only portion
of the benchmark, so the speedup does not come from the app reading
back results from cache. It comes from either overwriting the same
dirty cachelines (a performance critical program should really
avoid doing this if possible anyway); or the cached stores simply
pipelining better with non-store operations (but in that case you
probably still want non-temporal stores anyway because if your
workload is doing any real work, you don't want to push its cache
out with these stores).

So, can we find something that is more realistic? Doesn't gcc
create several stages of temporary files?

