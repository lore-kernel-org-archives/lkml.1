Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbYFLNJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbYFLNJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760597AbYFLNIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:08:46 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:49141 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760223AbYFLNIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:08:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=0f7Bj0FoVxJS5QouK0jPFdkZMARZ8KvrHS+x7CjNKm+4RdZid6lLmSQJoejSyNvcQ9WpXKzeIM72dbdNtmosODdorL2gdaWvsVaGcyKammIT358eP75iHUGj8lQzTkENWbFIWsFygEFZ5L8NfUMueUg2MDys8MSkpo9L1dbDSVg=  ;
X-YMail-OSG: 0CtLjNQVM1nOcryqvCQ.hhAowSf8k8WatWxYjbVxQUGM2ZpTE1cpituQOQczcMA6o5.NL.CY9kmR_Z8U6j1gd_mRurni0Zj5YbbjAedYjWn93M.lHGHQE_wznEsDYcyD8P3dAhrIBavDEwrVQcbHztXx
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Thu, 12 Jun 2008 23:08:35 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <200806111535.24523.nickpiggin@yahoo.com.au> <18513.4925.711881.794221@cargo.ozlabs.ibm.com>
In-Reply-To: <18513.4925.711881.794221@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806122308.35556.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 22:14, Paul Mackerras wrote:
> Nick Piggin writes:
> >                 /* turn off LED */
> >                 val64 = readq(&bar0->adapter_control);
> >                 val64 = val64 &(~ADAPTER_LED_ON);
> >                 writeq(val64, &bar0->adapter_control);
> >                 s2io_link(nic, LINK_DOWN);
> >         }
> >         clear_bit(__S2IO_STATE_LINK_TASK, &(nic->state));
> >
> > Now I can't say definitively that this is going to be wrong on
> > powerpc, because I don't know the code well enough. But I'd be
> > 90% sure that the unlock is not supposed to be visible to
> > other CPUs before the writeqs are queued to the card. On x86 it
> > wouldn't be.
>
> Interestingly, there is also a store to cacheable memory
> (nic->device_enabled_once), but no smp_wmb or equivalent before the
> clear_bit.  So there are other potential problems here besides the I/O
> related ones.

Yeah there sure is. That sucks too, but we go one step at a time ;)
I think proposing a strong ordering between set_bit/clear_bit would
actually be quite noticable slowdown in core kernel code at this
point.

Which reminds me, I have been meaning to do another pass of test and
set bit / clear bit conversions to the _lock primitives...


> Anyway, I have done some tests on a dual G5 here with putting a sync
> on both sides of the store in writel etc. (i.e. making readl/writel
> strongly ordered w.r.t. everything else), and as you predicted, there
> wasn't a noticeable performance degradation, at least not on the
> couple of things I tried.  So I am now inclined to accept your
> suggestion that we should do that.  I should probably do some similar
> checks on POWER6 and a few other machines first, though.

Oh good, thanks for looking into it. I guess it might be a little more
noticable on bigger POWER systems. And I think we might even need to do
a PCI read after every writel on sn2 systems in order to get the
semantics I want.

I can't say it won't be noticable. But if we consider the number of
drivers (maybe one or two dozen well maintained ones), and number of
sites in each driver (maybe one or two submission and completion
fastpaths which should have a minimum of IO operations in each one)
that will have to be converted in order to get performance as good or
better than it is currently with relaxed accessors.... and weigh that
against all the places in those and every other crappy obscure
driver that we *won't* have to audit, I really think we end up with
a net win even with some short term pain.
