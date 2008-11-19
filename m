Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbYKSEcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbYKSEcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 23:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYKSEbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 23:31:51 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35652 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538AbYKSEbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 23:31:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZVXqqNaefLleW2s2NyqkdCha/x6ne6KGWXBRYx7jnM09ta7I9asBwDGJOCRz58qQFUZSARHkNardnE/EhWN5g/TwDsvaAIuYLoVXwzgTl+pETqrm9fhDVWLFzSOYI4iGXmefixOGSX8DU6PmveXMQ8FyeEfqCvhWdt64+B0XLdQ=  ;
X-YMail-OSG: H_wFC9IVM1nWZAy0VmRqpiX_CEaH4ldKV6.jLUAf5B5MX.Id8FvjWeSQQrvPfm69m3LoKzCtq4VSKhxB9NGbTujVq14rd0cj9xv9aw80jYu52OgDobDEIQCfckZesNhNXGaSOYLF1zUAo_xPDWHJGgQ_Apca2UD1_FNA46iuTMf2IDD6ZfLnWyZpVaQh
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Date: Wed, 19 Nov 2008 15:31:41 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, dada1@cosmosbay.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, shemminger@vyatta.com
References: <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org> <200811182044.11055.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0811180731480.18283@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811180731480.18283@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191531.41652.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 02:58, Linus Torvalds wrote:
> On Tue, 18 Nov 2008, Nick Piggin wrote:
> > On Tuesday 18 November 2008 07:58, David Miller wrote:
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > >
> > > > Ok. It could easily be something like a cache footprint issue. And
> > > > while I don't know my sparc cpu's very well, I think the
> > > > Ultrasparc-IIIi is super- scalar but does no out-of-order and
> > > > speculation, no?
> > >
> > > I does only very simple speculation, but you're description is
> > > accurate.
> >
> > Surely it would do branch prediction, but maybe not indirect branch?
>
> That would be "branch target prediction" (and a BTB - "Branch Target
> Buffer" to hold it), and no, I don't think Sparc does that. You can
> certainly do it for in-order machines too, but I think it's fairly rare.
>
> It's sufficiently different from the regular "pick up the address from the
> static instruction stream, and also yank the kill-chain on mispredicted
> direction" to be real work to do. Unlike a compare or test instruction,
> it's not at all likely that you can resolve the final address in just a
> single pipeline stage, and without that, it's usually too late to yank the
> kill-chain.
>
> (And perhaps equally importantly, indirect branches are relatively rare on
> old-style Unix benchmarks - ie SpecInt/FP - or in databases. So it's not
> something that Sparc would necessarily have spent the effort on.)
>
> There is obviously one very special indirect jump: "ret". That's the one
> that is common, and that tends to have a special branch target buffer that
> is a pure stack. And for that, there is usually a special branch target
> register that needs to be set up 'x' cycles before the ret in order to
> avoid the stall (then the predition is checking that register against the
> branch target stack, which is somewhat akin to a regular conditional
> branch comparison).
>
> So I strongly suspect that an indirect (non-ret) branch flushes the
> pipeline on sparc. It is possible that there is a "prepare to jump"
> instruction that prepares the indirect branch stack (kind of a "push
> prediction information"). I suspect Java sees a lot more indirect
> branches than traditional Unix loads, so maybe Sun did do that.

Probably true. OTOH, I've seen indirect branches get compiled to direct
branches or the common-case special cased into a direct branch

if (object->fn == default_object_fn)
  default_object_fn();

That might be an easy way to test suspicions about CPU scheduler
slowdowns... (adding a likely() there, and using likely profiling would
help ensure you got the defualt case right).
