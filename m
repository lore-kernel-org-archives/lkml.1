Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYFKFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYFKFfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYFKFfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:35:36 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:20514 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751826AbYFKFff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:35:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iovYnExdRVdRDbHYJOm3RX0dqe3PbcEwrjcT2c6jZ16kSjlYWkaXRJpi1kJrSvl+SA06UjUTYLv4vXvj+oCtD28xcOAjthHE1PBo6DjmtJUuaXaOf8crf5Fv3Fb75NPiPSmXwGVPr0oYSVFmcE4Hi5JCylSa+K3t2VfXTLromQs=  ;
X-YMail-OSG: 9.Y3oWgVM1nIs_rIj.RLYgMWJgcf7diWhG7kF4a3BZ205h.CgaFBumzQQtqA7WPFoa4kUTyB4Ny_FkKTon80BY0YJo13fUcvKTAGlT82j2cLYcezHC_QNRkmZreCV7QCS.g-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 11 Jun 2008 15:35:24 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <200806111500.30789.nickpiggin@yahoo.com.au> <18511.24317.31038.926337@cargo.ozlabs.ibm.com>
In-Reply-To: <18511.24317.31038.926337@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111535.24523.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 15:13, Paul Mackerras wrote:
> Nick Piggin writes:
> > > I just wish we had even one actual example of things going wrong with
> > > the current rules we have on powerpc to motivate changing to this
> > > model.
> >
> > ~/usr/src/linux-2.6> git grep test_and_set_bit drivers/ | wc -l
> > 506
> > How sure are you that none of those forms part of a cobbled-together
> > locking scheme that hopes to constrain some IO access?
>
> My comment was precisely about the fact that this sort of argument is
> actually FUD.  I want one example that is demonstrably wrong, not just
> a "how sure are you".

But this is a case where you really should be scared, so FUD is
completely appropriate.

At least, I don't see how it is at all worse than FUD about how much
slower everything will be with stronger ordering, and how nobody will
be able to do anything about it. In reality, for most devices it will
not be measurable, and for some like network or disk might use a bit
of a tweak in one or two fastpaths.

If the driver author honestly does not know the code well enough to
say whether a particular ordering is allowed or not, then it should
just not be allowed.


Anyway, what do I win if I give you a concrete example?

I found one in the first file I picked out of my grep: drivers/net/s2io.c

        if (test_and_set_bit(__S2IO_STATE_LINK_TASK, &(nic->state))) {
                /* The card is being reset, no point doing anything */
                goto out_unlock;
        }

...
                val64 = readq(&bar0->adapter_control);
                val64 |= ADAPTER_LED_ON;
                writeq(val64, &bar0->adapter_control);
                s2io_link(nic, LINK_UP);
        } else {
                if (CARDS_WITH_FAULTY_LINK_INDICATORS(nic->device_type,
                                                      subid)) {
                        val64 = readq(&bar0->gpio_control);
                        val64 &= ~GPIO_CTRL_GPIO_0;
                        writeq(val64, &bar0->gpio_control);
                        val64 = readq(&bar0->gpio_control);
                }
                /* turn off LED */
                val64 = readq(&bar0->adapter_control);
                val64 = val64 &(~ADAPTER_LED_ON);
                writeq(val64, &bar0->adapter_control);
                s2io_link(nic, LINK_DOWN);
        }
        clear_bit(__S2IO_STATE_LINK_TASK, &(nic->state));

Now I can't say definitively that this is going to be wrong on
powerpc, because I don't know the code well enough. But I'd be
90% sure that the unlock is not supposed to be visible to
other CPUs before the writeqs are queued to the card. On x86 it
wouldn't be.


> > But surely you have to audit the drivers anyway to ensure they are OK
> > with the current powerpc scheme. In which case, once you have audited
> > them and know they are safe, you can easily convert them to the even
> > _faster_ __readl/__writel, and just add the appropriate barriers.
>
> The trouble is that as code gets maintained, using __writel + explicit
> barriers is more fragile because some people will change the code, or
> add new code, without understanding the barriers.

If the relaxed writel and explicit barriers are not well documented and
well understood, then they should not be used.

And if the memory ordering issues are not well understood, then it
should be done with locking and strongly ordered IO accessors.


> So whenever a 
> driver gets converted to using __writel + barriers, we will end up
> having to watch every change that goes into it forever.  Whereas with

*You* don't have to watch it, the maintainer does. And if they can't
understand the barriers, then it should not be converted to use them.
Unless you want to take over maintainership. And if you do, then you
should be watching all changes that go into it.


> the current scheme there's a much smaller set of gotchas to watch out
> for, and the gotchas are things that already raise red flags, such as
> open-coded locking and any sort of "clever" lockless scheme.

And with the strongly ordered scheme, there is much smaller set of
gotchas again, and it behaves the same as the x86 it was developed on,
and you don't get confused by the list of rules: IO access is either
strongly ordered or weakly ordered.
