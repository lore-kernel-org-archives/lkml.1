Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYGHAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYGHAiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYGHAiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:38:12 -0400
Received: from gw.goop.org ([64.81.55.164]:35525 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYGHAiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:38:11 -0400
Message-ID: <4872B6E2.5080003@goop.org>
Date: Mon, 07 Jul 2008 17:37:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jens Axboe <axboe@kernel.dk>,
       Xen devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Friebel <thomas.friebel@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
References: <20080707190749.299430659@goop.org> <200807081029.19242.rusty@rustcorp.com.au>
In-Reply-To: <200807081029.19242.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 08 July 2008 05:07:49 Jeremy Fitzhardinge wrote:
>   
>> At the most recent Xen Summit, Thomas Friebel presented a paper
>> ("Preventing Guests from Spinning Around",
>> http://xen.org/files/xensummitboston08/LHP.pdf) investigating the
>> interactions between spinlocks and virtual machines.  Specifically, he
>> looked at what happens when a lock-holding VCPU gets involuntarily
>> preempted.
>>     
>
> I find it interesting that gang scheduling the guest was not suggested as an 
> obvious solution.
>   

It's an obvious answer, but not an obvious solution.  You trade off 
wasting time spinning vs wasting time waiting for N vcpus to be free for 
scheduling.  Or something; seems much more complex, particularly if you 
can do a small guest tweak to solve the problem.

> Anyway, concept looks fine; lguest's solution is more elegant of course :)
>   

You could remove all mutable state and call it "erlang".

> A little disappointing that you can't patch your version inline.

Spinlock code isn't inlined currently, so I hadn't considered it.  The 
fast path code for both lock and unlock is nearly small enough to 
consider it, but it seems a bit fiddly.

If the "spin_lock" and "spin_unlock" functions were inlined functions 
which called the out of line __raw_spin_lock/unlock functions, then 
after patching they would result in a direct call to the backend lock 
functions, which would be exactly equivalent to what happens now (since 
I hook __raw_spin_lock into calls via pv_lock_ops).

    J

