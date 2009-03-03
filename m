Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZCCEVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZCCEVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZCCEVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:21:40 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:20939 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753715AbZCCEVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:21:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wv0k3jz7udJ4VIhSfwBpfJ5m+kxvFaulDlhdqPZYmv7XDtFXwGfhBVsjdUxXNsaS39TToOlJNw5YhNpUpltSXEmgcETHecfvT32Tuh4FdRF8HyEv3nSzBU+Xvvl+b6TSNe9EmtAqoa5bBVRtn7wqUR7lDDsYctJAGqldd4v5pAk=  ;
X-YMail-OSG: Ylw7u2QVM1kZnnaUA8nGWRGPriXYbU_o9b_kkgJlLC3EeSGBX7qCC4GltRSW54BCayMBpJsTWxVkHYZ6FwCigImfvO7ZowB3pLMc1mevrP5htonAIgTlIsqE2AT5Dl30e233UCRFWA8P7MjvPk2sb19NKI31oaNP.iPXO03IqHEMb90NESAf7TEbyeCWZg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Tue, 3 Mar 2009 15:20:59 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <200903020106.51865.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903031521.00217.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009 08:16:23 Linus Torvalds wrote:
> On Mon, 2 Mar 2009, Nick Piggin wrote:
> > I would expect any high performance CPU these days to combine entries
> > in the store queue, even for normal store instructions (especially for
> > linear memcpy patterns). Isn't this likely to be the case?
>
> None of this really matters.

Well that's just what I was replying to. Of course nontemporal/uncached
stores can't avoid cc operations either, but somebody was hoping that
they would avoid the write-allocate / RMW behaviour. I just replied because
I think that modern CPUs can combine stores in their store queues to get
the same result for cacheable stores.

Of course it doesn't make it free especially if it is a cc protocol that
has to go on the interconnect anyway. But avoiding the RAM read is a
good thing anyway.


> The big issue is that before you can do any write to any cacheline, if the
> memory is cacheable, it needs the cache coherency protocol to synchronize
> with any other CPU's that may have that line in the cache.
>
> The _only_ time a write is "free" is when you already have that cacheline
> in your own cache, and in an "exclusive" state. If that is the case, then
> you know that you don't need to do anything else.
>
> In _any_ other case, before you do the write, you need to make sure that
> no other CPU in the system has that line in its cache. Whether you do that
> with a "write and invalidate" model (which would be how a store buffer
> would do it or a write-through cache would work), or whether you do it
> with a "acquire exclusive cacheline" (which is how the cache coherency
> protocol would do it), it's going to end up using cache coherency
> bandwidth.
>
> Of course, what will be the limiting factor is unclear. On a single-socket
> thing, you don't have any cache coherency issues, an the only bandwidth
> you'd end up using is the actual memory write at the memory controller
> (which may be on-die, and entirely separate from the cache coherency
> protocol). It may be idle and the write queue may be deep enough that you
> reach memory speeds and the write buffer is the optimal approach.
>
> On many sockets, the limiting factor will almost certainly be the cache
> coherency overhead (since the cache coherency traffic needs to go to _all_
> sockets, rather than just one stream to memory), at least unless you have
> a good cache coherency filter that can filter out part of the traffic
> based on whether it could be cached or not on some socket(s).
>
> IOW, it's almost impossible to tell what is the best approach. It will
> depend on number of sockets, it will depend on size of cache, and it will
> depend on the capabilities and performance of the memory controllers vs
> the cache coherency protocol.
>
> On a "single shared bus" model, the "write with invalidate" is fine, and
> it basically ends up working a lot like a single socket even if you
> actually have multiple sockets - it just won't scale much beyond two
> sockets. With HT or QPI, things are different, and the presense or absense
> of a snoop filter could make a big difference for 4+ socket situations.
>
> There simply is no single answer.
>
> And we really should keep that in mind. There is no right answer, and the
> right answer will depend on hardware. Playing cache games in software is
> almost always futile. It can be a huge improvement, but it can be a huge
> deprovement too, and it really tends to be only worth it if you (a) know
> your hardware really quite well and (b) know your _load_ pretty well too.
>
> We can play games in the kernel. We do know how many sockets there are. We
> do know the cache size. We _could_ try to make an educated guess at
> whether the next user of the data will be DMA or not. So there are
> unquestionably heuristics we could apply, but I also do suspect that
> they'd inevitably be pretty arbitrary.
>
> I suspect that we could make some boot-time (or maybe CPU hotplug time)
> decision that simply just sets a threshold value for when it is worth
> using non-temporal stores. With smaller caches, and with a single socket
> (or a single bus), it likely makes sense to use non-temporal stores
> earlier.
>
> But even with some rough heuristic, it will be wrong part of the time. So
> I think "simple and predictable" in the end tends to be better than
> "complex and still known to be broken".
>
> Btw, the "simple and predictable" could literally look at _where_ in the
> file the IO is. Because I know there are papers on the likelihood of
> re-use of data depending on where in the file it is written. Data written
> to low offsets is more likely to be accessed again (think temp-files),
> while data written to big offsets are much more likely to be random or to
> be written out (think databases or simply just large streaming files).
>
> So I suspect a "simple and predictable" algorithm could literally be
> something like
>
>  - use nontemporal stores only if you are writing a whole page, and the
>    byte offset of the page is larger than 'x', where 'x' may optionally
>    even depend on size of cache.
>
> But removing it entirely may be fine too.
>
> What I _don't_ think is fine is to think that you've "solved" it, or that
> you should even try!

Right. I don't know if you misunderstood me or aimed this post at the
general discussion rather than my reply specifically.

I know even if a CPU does write combining in the store buffer and even
if it does have "big-hammer" nontemporal stores like x86 apparently does,
then there are still cases where nontemporal stores will win if the data
doesn't get used by the CPU again.

I agree that if a heuristic can't get it right a *significant* amount of
time, then it is not worthwhile. Even if it gets it right a little more
often than wrong, the unpredictability is a negative factor. I agree
completely with you there :)

I would like to remove it, as in Ingo's last patch, FWIW. But I can see
obviously there are cases where nontemporal helps, so there will never be
a "right" answer.

