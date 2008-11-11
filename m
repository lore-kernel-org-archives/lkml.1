Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYKKNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYKKNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYKKNtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:49:11 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:54468 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYKKNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:49:10 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
 chanes in stop_machine
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <19f34abd0811110536i71994436q4aa78a99d201c478@mail.gmail.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
	 <20081111105214.GA15645@elte.hu>
	 <19f34abd0811110536i71994436q4aa78a99d201c478@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 14:49:01 +0100
Message-Id: <1226411341.7685.1779.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 14:36 +0100, Vegard Nossum wrote:
> On Tue, Nov 11, 2008 at 11:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]
> 
> Heh. I am not expert, but I looked at the code. The obvious suspicious
> thing to see is the use of unpaired barriers? Maybe like this:
> 
>  47 static void set_state(enum stopmachine_state newstate)
> 48 {
> 49         /* Reset ack counter. */
> 50         atomic_set(&thread_ack, num_threads);
> 51         smp_wmb();
> 
> + /* force ordering between thread_ack/state */
> 
> 52         state = newstate;
> 53 }
> 54
> 55 /* Last one to ack a state moves to the next state. */
> 56 static void ack_state(void)
> 57 {
> 58         if (atomic_dec_and_test(&thread_ack))
> 
> Maybe
> + /* force ordering between thread_ack/state */
> + smp_rmb();
> here?

all atomic ops that have return values imply a full barrier, iirc

> 59                 set_state(state + 1);
> 60 }
> 61
> 
> Or maybe I am wrong. But Documentation/memory-barriers.txt is rather
> explicit on this point.
> 
> 
> Vegard
> 

