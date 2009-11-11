Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZKKJdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZKKJdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKKJdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:33:49 -0500
Received: from 1wt.eu ([62.212.114.60]:50997 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbZKKJds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:33:48 -0500
Date: Wed, 11 Nov 2009 10:32:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111093258.GE560@1wt.eu>
References: <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA6E50.7030808@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:57:04PM -0800, H. Peter Anvin wrote:
> On 11/10/2009 10:36 PM, Willy Tarreau wrote:
> >>
> >> Do you have *any* *evidence* *whatsoever* for that assertion?!
> > 
> > No, just basic feeling based on implementation cost and difficulty
> > vs gains as I explained.
> 
> Quite on the contrary; in hardware it would be pretty hard to *not* do
> the right thing.

It just depends on how the instruction prefetcher is implemented.
If the check is only performed on the first byte of the opcode,
we can miss the tail. In my experience, intel processors have
been doing instruction checks right, but I have no reason to be
absolutely certain that all other vendors do that right, especially
those targetting cheap embedded systems.

Eventhough this one is not for this precise case, here's an example
of such a missed boundary check :

  http://download.intel.com/design/processor/specupdt/315593.pdf

AK27: "general protection fault may not be signaled on data segment
       limit violation above 4-G limit". Status: "no fix".

Note that I don't find this can present a significant vulnerability
risk. Maybe if someone comes with a concrete case where it is a real
trouble, they will fix it.

> >> I personally will consider something that doesn't implement proper
> >> security check to be a potential security hole and will NAK the patch.
> > 
> > Even in the case of the NOPL instruction ? I clearly don't see
> > the potential security hole !
> > 
> 
> You have it backwards.  Prove that there *isn't* one and we'll talk.

You're not helping. You're asking me to prove that something has no
issue, all I can say is that it does not have any issue I can imagine.
Proving the opposite with an example would be easier.

All I can say is that executing a NOP results in no state change in
the processor except the instruction pointer which points to the
next instruction after execution. Since a NOP changes nothing, it
cannot be used alone to provide any privilege, access to data or
any such thing. Since it does not perform any jump, it cannot either
be used to take back control of the execution flow. And it is certain
that the next instruction after it will be executed, so if the NOP
crosses a page boundary and completes on a non-executable one, the
next instruction will trigger the PF.

So I can't see how a NOP can be used to circumvent any protection.

Willy

