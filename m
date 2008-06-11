Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYFKGDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYFKGDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYFKGCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:02:52 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:45025 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751955AbYFKGCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:02:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iTYVtlrIjBDV4MeZlsKwXjMeP+CU5BzJRbQw1kTkPmwElJgW5rrkeCZlGXRMXL+GM+Hj3xFwumxoufqwxBj5CSV1p3YX88ttsX4YidQIoX/tU7U2aq2kisVoNtHmF9QA0o7YLViY7rGjMqtqw1PvQASa/0AHji2bbAKILhSLTF0=  ;
X-YMail-OSG: SAmNji8VM1khJrZJhddcoc5GjPS7NvFN.I3T0eMWEAPTrg8uo28a1gAyBwTeNRCb5PchroxGWwBXWrSKGkENsWGzvVChR0Vr2J_kNPttO9gKrGTMbiO6R.HV20spuKhV0QA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 11 Jun 2008 16:02:40 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <18511.24317.31038.926337@cargo.ozlabs.ibm.com> <200806111535.24523.nickpiggin@yahoo.com.au>
In-Reply-To: <200806111535.24523.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111602.40751.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 15:35, Nick Piggin wrote:
> On Wednesday 11 June 2008 15:13, Paul Mackerras wrote:
> > Nick Piggin writes:
> > > > I just wish we had even one actual example of things going wrong with
> > > > the current rules we have on powerpc to motivate changing to this
> > > > model.
> > >
> > > ~/usr/src/linux-2.6> git grep test_and_set_bit drivers/ | wc -l
> > > 506
> > > How sure are you that none of those forms part of a cobbled-together
> > > locking scheme that hopes to constrain some IO access?
> >
> > My comment was precisely about the fact that this sort of argument is
> > actually FUD.  I want one example that is demonstrably wrong, not just
> > a "how sure are you".
>
> But this is a case where you really should be scared, so FUD is
> completely appropriate.
>
> At least, I don't see how it is at all worse than FUD about how much
> slower everything will be with stronger ordering, and how nobody will
> be able to do anything about it. In reality, for most devices it will
> not be measurable, and for some like network or disk might use a bit
> of a tweak in one or two fastpaths.
>
> If the driver author honestly does not know the code well enough to
> say whether a particular ordering is allowed or not, then it should
> just not be allowed.
>
>
> Anyway, what do I win if I give you a concrete example?
>
> I found one in the first file I picked out of my grep: drivers/net/s2io.c
>
>         if (test_and_set_bit(__S2IO_STATE_LINK_TASK, &(nic->state))) {
>                 /* The card is being reset, no point doing anything */
>                 goto out_unlock;
>         }
>
> ...
>                 val64 = readq(&bar0->adapter_control);
>                 val64 |= ADAPTER_LED_ON;
>                 writeq(val64, &bar0->adapter_control);
>                 s2io_link(nic, LINK_UP);
>         } else {
>                 if (CARDS_WITH_FAULTY_LINK_INDICATORS(nic->device_type,
>                                                       subid)) {
>                         val64 = readq(&bar0->gpio_control);
>                         val64 &= ~GPIO_CTRL_GPIO_0;
>                         writeq(val64, &bar0->gpio_control);
>                         val64 = readq(&bar0->gpio_control);
>                 }
>                 /* turn off LED */
>                 val64 = readq(&bar0->adapter_control);
>                 val64 = val64 &(~ADAPTER_LED_ON);
>                 writeq(val64, &bar0->adapter_control);
>                 s2io_link(nic, LINK_DOWN);
>         }
>         clear_bit(__S2IO_STATE_LINK_TASK, &(nic->state));
>
> Now I can't say definitively that this is going to be wrong on
> powerpc, because I don't know the code well enough. But I'd be
> 90% sure that the unlock is not supposed to be visible to
> other CPUs before the writeqs are queued to the card. On x86 it
> wouldn't be.

And I hope you're reading this, sn2 guys :)

The mmiowb() audit for spin_unlock was a nice idea, but this example
shows that unless you *really* know the code and have actually audited
everything, then you should not be messing with relaxing of ordering
etc.

Now obviously the example I quote is a slowpath, in which case it can
very happily continue to use strongly ordered io accessors, and you
will never ever notice the extra sync or PCI read or whatever after
the writeq. Then you can easily relax the couple of fastpaths that
matter, put barriers in there, comment them, and you're away: you now
have a *working* driver (that doesn't randomly lose adapter_control
bits twice a year), and that is also faster than it was when it was
broken because you've specifically used the very weakly ordered IO
accessors in the fast paths that matter.

And when somebody plugs in some obscure hardware into your box that
you haven't audited and put mmiowb etc etc into, then guess what? It
is also not going to blow up in an undebuggable way 6 months later in
the middle of <insert something important here>. The worst case is
that the user notices it is running a bit slowly and sends a full
profile output the next day.
