Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZEKNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZEKNO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZEKNOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:14:49 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:43127 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZEKNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=kOf3awns9iUczk8LNO9reR2p6/Td72dviQ0jH3wxrtQsXyNPKcmio6R/RyY0hxOukO
         mdNW3GHlkw9YIGYWhFM1RJZK9mufeQ/jVQ2LLWK3AXRfLjTiXKuvBtBZDpijqebSYywe
         kfLCLgunt0yxmx0fR0Ko0RJdKpAzsfCe08HnA=
Message-ID: <4A0824C2.4000109@gmail.com>
Date: Mon, 11 May 2009 09:14:42 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws> <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws>
In-Reply-To: <4A071F1A.1090702@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA367B4E6E4DDED24DDAAD4CA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA367B4E6E4DDED24DDAAD4CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> Anthony Liguori wrote:
>> =20
>>>   I'm surprised so much effort is going into this, is there any
>>> indication that this is even close to a bottleneck in any circumstanc=
e?
>>>    =20
>>
>> Yes.  Each 1us of overhead is a 4% regression in something as trivial =
as
>> a 25us UDP/ICMP rtt "ping".m  =20
>
> It wasn't 1us, it was 350ns or something around there (i.e ~1%).

I wasn't referring to "it".  I chose my words carefully.

Let me rephrase for your clarity: *each* 1us of overhead introduced into
the signaling path is a ~4% latency regression for a round trip on a
high speed network (note that this can also affect throughput at some
level, too).  I believe this point has been lost on you from the very
beginning of the vbus discussions.

I specifically generalized my statement above because #1 I assume
everyone here is smart enough to convert that nice round unit into the
relevant figure.  And #2, there are multiple potential latency sources
at play which we need to factor in when looking at the big picture.  For
instance, the difference between PF exit, and an IO exit (2.58us on x86,
to be precise).  Or whether you need to take a heavy-weight exit.  Or a
context switch to qemu, the the kernel, back to qemu, and back to the
vcpu).  Or acquire a mutex.  Or get head-of-lined on the VGA models IO.=20
I know you wish that this whole discussion would just go away, but these
little "300ns here, 1600ns there" really add up in aggregate despite
your dismissive attitude towards them.  And it doesn't take much to
affect the results in a measurable way.  As stated, each 1us costs ~4%.=20
My motivation is to reduce as many of these sources as possible.

So, yes, the delta from PIO to HC is 350ns.  Yes, this is a ~1.4%
improvement.  So what?  Its still an improvement.  If that improvement
were for free, would you object?  And we all know that this change isn't
"free" because we have to change some code (+128/-0, to be exact).  But
what is it specifically you are objecting to in the first place?  Adding
hypercall support as an pv_ops primitive isn't exactly hard or complex,
or even very much code.

Besides, I've already clearly stated multiple times (including in this
very thread) that I agree that I am not yet sure if the 350ns/1.4%
improvement alone is enough to justify a change.  So if you are somehow
trying to make me feel silly by pointing out the "~1%" above, you are
being ridiculous.

Rather, I was simply answering your question as to whether these latency
sources are a real issue.  The answer is "yes" (assuming you care about
latency) and I gave you a specific example and a method to quantify the
impact.

It is duly noted that you do not care about this type of performance,
but you also need to realize that your "blessing" or
acknowledgment/denial of the problem domain has _zero_ bearing on
whether the domain exists, or if there are others out there that do care
about it.  Sorry.

>
>> for request-response, this is generally for *every* packet since you
>> cannot exploit buffering/deferring.
>>
>> Can you back up your claim that PPC has no difference in performance
>> with an MMIO exit and a "hypercall" (yes, I understand PPC has no "VT"=

>> like instructions, but clearly there are ways to cause a trap, so
>> presumably we can measure the difference between a PF exit and somethi=
ng
>> more explicit).
>>  =20
>
> First, the PPC that KVM supports performs very poorly relatively
> speaking because it receives no hardware assistance

So wouldn't that be making the case that it could use as much help as
possible?

>   this is not the right place to focus wrt optimizations.

Odd choice of words.  I am advocating the opposite (broad solution to
many arches and many platforms (i.e. hypervisors)) and therefore I am
not "focused" on it (or really any one arch) at all per se.  I am
_worried_ however, that we could be overlooking PPC (as an example) if
we ignore the disparity between MMIO and HC since other higher
performance options are not available like PIO.  The goal on this
particular thread is to come up with an IO interface that works
reasonably well across as many hypervisors as possible.  MMIO/PIO do not
appear to fit that bill (at least not without tunneling them over HCs)

If I am guilty of focusing anywhere too much it would be x86 since that
is the only development platform I have readily available.


>
>
> And because there's no hardware assistance, there simply isn't a
> hypercall instruction.  Are PFs the fastest type of exits?  Probably
> not but I honestly have no idea.  I'm sure Hollis does though.
>
> Page faults are going to have tremendously different performance
> characteristics on PPC too because it's a software managed TLB.
> There's no page table lookup like there is on x86.

The difference between MMIO and "HC", and whether it is cause for
concern will continue to be pure speculation until we can find someone
with a PPC box willing to run some numbers.  I will point out that we
both seem to theorize that PFs will yield lower output than
alternatives, so it would seem you are actually making my point for me.

>
> As a more general observation, we need numbers to justify an
> optimization, not to justify not including an optimization.
>
> In other words, the burden is on you to present a scenario where this
> optimization would result in a measurable improvement in a real world
> work load.

I have already done this.  You seem to have chosen to ignore my
statements and results, but if you insist on rehashing:

I started this project by analyzing system traces and finding some of
the various bottlenecks in comparison to a native host.  Throughput was
already pretty decent, but latency was pretty bad (and recently got
*really* bad, but I know you already have a handle on whats causing
that).  I digress...one of the conclusions of the research was that  I
wanted to focus on building an IO subsystem designed to minimize the
quantity of exits, minimize the cost of each exit, and shorten the
end-to-end signaling path to achieve optimal performance.  I also wanted
to build a system that was extensible enough to work with a variety of
client types, on a variety of architectures, etc, so we would only need
to solve these problems "once".  The end result was vbus, and the first
working example was venet.  The measured performance data of this work
was as follows:

802.x network, 9000 byte MTU,  2 8-core x86_64s connected back to back
with Chelsio T3 10GE via crossover.

Bare metal            : tput =3D 9717Mb/s, round-trip =3D 30396pps (33us =
rtt)
Virtio-net (PCI)    : tput =3D 4578Mb/s, round-trip =3D 249pps (4016us rt=
t)
Venet      (VBUS): tput =3D 5802Mb/s, round-trip =3D 15127 (66us rtt)

For more details:  http://lkml.org/lkml/2009/4/21/408

You can download this today and run it, review it, compare it.  Whatever
you want.

As part of that work, I measured IO performance in KVM and found HCs to
be the superior performer.  You can find these results here:=20
http://developer.novell.com/wiki/index.php/WhyHypercalls.  Without
having access to platforms other than x86, but with an understanding of
computer architecture, I speculate that the difference should be even
more profound everywhere else in lieu of a PIO primitive.  And even on
the platform which should yield the least benefit (x86), the gain
(~1.4%) is not huge, but its not zero either.  Therefore, my data and
findings suggest that this is not a bad optimization to consider IMO.=20
My final results above do not indicate to me that I was completely wrong
in my analysis.

Now I know you have been quick in the past to dismiss my efforts, and to
claim you can get the same results without needing the various tricks
and optimizations I uncovered.  But quite frankly, until you post some
patches for community review and comparison (as I have done), it's just
meaningless talk.
=20
Perhaps you are truly unimpressed with my results and will continue to
insist that my work including my final results are "virtually
meaningless".  Or perhaps you have an agenda.  You can keep working
against me and try to block anything I suggest by coming up with what
appears to be any excuse you can find, making rude replies on email
threads and snide comments on IRC, etc.  It's simply not necessary.

Alternatively, you can work _with_ me to help try to improve KVM and
Linux (e.g. I still need someone to implement a virtio-net backend, and
who knows it better than you).  The choice is yours.  But lets cut the
BS because it's counter productive, and frankly, getting old.

Regards,
-Greg




--------------enigA367B4E6E4DDED24DDAAD4CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoIJMIACgkQP5K2CMvXmqFlUwCfd9BCs7Q42rLF4Iu7UxBk6vIt
zNwAn3xGPd49dLnrxl8cNOiMxKN+mE8x
=AoeA
-----END PGP SIGNATURE-----

--------------enigA367B4E6E4DDED24DDAAD4CA--
