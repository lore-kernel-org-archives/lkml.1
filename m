Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYHZFN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYHZFN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 01:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYHZFNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 01:13:48 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27922 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751008AbYHZFNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 01:13:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BFP0EL+evOlsra/C7ChgUKM6IvWP1dd/MWSS/ngthJKNZUJzosHU77MRu0m/cPIPV1bQTOVtgE0WOQOfL34rrcTkPEUuS9pCViVaX+n72UigvjbireVuqZrAwmZK7v7jF3mkpRsySg1zJOucG5toquDK5fH6x5dIgFywGP31vSo=  ;
X-YMail-OSG: cNiGFKwVM1kB5nfcysylPF3nQ3mKayqQZdgC4EyAEoUz2uzIHHrRhrPPGqVp2.IQrodPJjZCiwg8OW8ICbUoYH4ETLKnG4eRwOkqLDJ.uXKvwKUR8Rpq1jCxqGgUw.KlWA0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues =?iso-8859-1?q?rather=09than?= rcu
Date: Tue, 26 Aug 2008 15:13:40 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <1219677736.8515.69.camel@twins> <48B2D3BE.40101@linux-foundation.org>
In-Reply-To: <48B2D3BE.40101@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261513.40586.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 01:46, Christoph Lameter wrote:
> Peter Zijlstra wrote:
> > If we combine these two cases, and flip the counter as soon as we've
> > enqueued one callback, unless we're already waiting for a grace period
> > to end - which gives us a longer window to collect callbacks.
> >
> > And then the rcu_read_unlock() can do:
> >
> >   if (dec_and_zero(my_counter) && my_index == dying)
> >     raise_softirq(RCU)
> >
> > to fire off the callback stuff.
> >
> > /me ponders - there must be something wrong with that...
> >
> > Aaah, yes, the dec_and_zero is non trivial due to the fact that its a
> > distributed counter. Bugger..
>
> Then lets make it per cpu. If we get the cpu ops in then dec_and_zero would
> be very cheap.

Let's be very careful before making rcu read locks costly. Any reduction
in grace periods would be great, but IMO RCU should not be used in cases
where performance depends on the freed data remaining in cache.
