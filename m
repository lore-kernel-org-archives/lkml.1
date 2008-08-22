Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYHVJNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYHVJNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYHVJM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:12:59 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:45173 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751617AbYHVJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:12:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mpa+HfC6JINCYNonzGhSLlDlS2rDRthCIHGjONzKpC/7m+GyVnmqDk4FS0CHnFbMMRF/5Ev/3KXsfqKrDkjw5HK9BM3HADFUGphgguFXJ0p8fZwQsnWPAKMfLpaFBH/FGDzmIMesyIAP94Re7r1linJ7mPayyIIrsnXXpAJkrZs=  ;
X-YMail-OSG: tcu4ixQVM1md6IBdMFbzpVczSbHGWmc80lD8Fy9lTzrhW8Go_fUy0Xv7frGlQ9ZrRP9FDjrpa34jDqtwAGnhpPN_aJcAUmSgN168y9dvcZE71LvvMi1Cx87XDfirZmPMP5a.5Pn2hcFopNJ1LlQMMW84
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Date: Fri, 22 Aug 2008 19:12:45 +1000
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <48AE0883.6050701@goop.org> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <20080822071209.GZ14110@elte.hu>
In-Reply-To: <20080822071209.GZ14110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221912.46101.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 17:12, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Hi Ingo,
> >
> > On Fri, Aug 22, 2008 at 9:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > >> RCU can only control the lifetime of allocated memory blocks, which
> > >> forces all the call structures to be allocated.  This is expensive
> > >> compared to allocating them on the stack, which is the common case for
> > >> synchronous calls.
> > >>
> > >> This patch takes a different approach.  Rather than using RCU, the
> > >> queues are managed under rwlocks.  Adding or removing from the queue
> > >> requires holding the lock for writing, but multiple CPUs can walk the
> > >> queues to process function calls under read locks.  In the common
> > >> case, where the structures are stack allocated, the calling CPU need
> > >> only wait for its call to be done, take the lock for writing and
> > >> remove the call structure.
> > >>
> > >> Lock contention - particularly write vs read - is reduced by using
> > >> multiple queues.
> > >
> > > hm, is there any authorative data on what is cheaper on a big box, a
> > > full-blown MESI cache miss that occurs for every reader in this new
> > > fastpath, or a local SLAB/SLUB allocation+free that occurs with the
> > > current RCU approach?
> >
> > Christoph might have an idea about it.
>
> ... thought of that missing Cc: line entry exactly 1.3 seconds after
> having sent the mail :)
>
> Christoph, any preferences/suggestions?

I think it's just going to be a matter of benchmarking it and seeing.
And small/medium systems are probably more important than huge ones
unless there is a pathological scalability problem with one of the
approaches (which there probably isn't seeing as there is already
locking there).
