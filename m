Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYKNBLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYKNBLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKNBLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:11:33 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:48871 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353AbYKNBLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:11:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SqU0CyODrQEPNYl68vq8nOdS4VTPDnKCwIKLLul/w+YOzPJYmxYexyRAk8nnMAjYL/mxx2NB8yWn4K5qNJnsxf7zqxYOpnJx99XxWMZQp8QZ6L1Nm2dao8BF2r9SByCFuR4moSovrjAMnP1XE97yu45AtHLf84pTGM9DhL+Sbm0=  ;
X-YMail-OSG: wv2ZrngVM1lGhMvkktCy5SPwqLA5GyO.o.QkR2_iNvhIfeXhken83wEKsIzsXNN0zONBJKU3E8QcgzlrxrxDO014wvR33rxdCW4x59akHbiwnT.D.3P0s0vy_d5P1k9Gx9yBKl9jPMD.hNE6pP.L_yGb2CmIv24h7nF1sE6iR9BJtZjsEYBGE6ACOj2L
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Date: Fri, 14 Nov 2008 12:11:22 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
References: <20081104122839.GA22864@mailshack.com> <20081104210643.GH29626@one.firstfloor.org> <20081105102643.GA11383@elte.hu>
In-Reply-To: <20081105102643.GA11383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141211.23496.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to reply so late on this slightly offtopic rant...

On Wednesday 05 November 2008 21:26, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> > On Tue, Nov 04, 2008 at 09:44:00PM +0100, Ingo Molnar wrote:

> > > It's only an issue on ancient CPUs that export all their LOCKed
> > > cycles to the bus. Pentium and older or so. The PPro got it right
> > > already.
> >
> > ???  LOCK slowness is not because of the bus. And I know you know
> > that Ingo, so I don't know why you wrote that bogosity above.
>
> .. of course the historic LOCK slowness was all due to the system bus:
> very old CPUs exported a LOCK signal to the system bus for every
> LOCK-prefix access (implicit and explicit) and that made it _really_
> expensive. (hundreds of cycles)
>
> ... on reasonably modern CPUs the LOCK-ed access has been abstracted
> away to within the CPU, and the cost of LOCK-ed access is rather low
> (think 10-20 cycles - of course only if there's no cache miss cost)
> (That's obviously the case with the GDT, with is both per CPU and well
> cached.)

Locked instruction AFAIR is about 50 cycles on Core2. I think it is
a bit lower on K8. On Nehalem, which has optimisations for these,
I have heard it is still about 20-25 cycles. Although I don't have
one, so I don't actually know.

These (on my Core2) don't seem to pipeline at all with other
instructions either. So on my Core2, a locked instruction is worth
maybe 150-200 regular pipelined, superscalar instructions.

There is another big reason why lock instructions are expensive,
and that is because they have to prevent subsequent loads from
passing any previous stores becoming visible. This in theory could
be somewhat speculated, but no matter what happens, the program
visible state can't be committed until the stores are.

I heard from an Intel hardware engineer that Nehalem has some
really fancy logic in it to make locked instructions "free", that
was nacked from earlier CPUs because it was too costly. So obviously
it is taking a fair whack of transistors or power for them to do it.
And even then it is far from free, but still seems to be one or two
orders of magnitude more expensive than a regular instruction.


> on _really_ modern CPUs LOCK can be as cheap as just a few cycles - so

Oh, maybe I'm mistaken about Nehalem then? How many is "just a few"?
If it is 25 non-pipelined cycles, then that's still 100 instructions
if it is a 4 issue machine.


> low that we can stop bothering about it in the future. There's no
> fundamental physical reason why the LOCK prefix (implicit or explicit)
> should be expensive.

Even if they could make it free on the software side, it is obviously
expensive on the hardware side. Not bothering about it is a copout.
The atomic instruction speedups in Nehalem are cool, but what would
have been even cooler is if Intel had decided *not* to spend resources
making this cheaper because they found Linux has so few locked
instructions :)

Even if somehow the x86 ISA didn't have the implicit memory ordering
requirement in the lock instruction, I think it's obviously a special
case path that doesn't fit in with a load/store uarch (whether they
implement it in uops with ll/sc like thing or whatnot, it's going to
need special logic).

IMO, we shouldn't stop bothering about LOCK prefix in the forseeable
future.

