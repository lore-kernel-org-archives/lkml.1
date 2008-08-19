Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYHSKuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYHSKuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYHSKuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:50:08 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21381 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751708AbYHSKuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:50:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y3qeNb0BUr5NpQ+YhL61YynIoyYDP4wocyn0122Uwt0u8OPZjBRiPRc8A+fYkeKtPDXE7HRKQyV1USabQRiG2ZpNjFdThaxAXVQEazozQcqELDU5/q3P9o42WwbtP6ndoKMz+G7dRjpq0it/JT8rynszf/kpuqBd9l69HHixpE8=  ;
X-YMail-OSG: ZDOqypYVM1lnnUZZVV5vsoE83hItOWgmRhlRpmYnAO7.87_QmOiXYjJM8Vnxa2E6rQUFE2JGZl1aVtoefdyAXNH2RLHxuDKruXZ.BDtD2TrX8umk0nnBPRiHhHZ18maubF20N6JFID1_poLSP6Y94AN_
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Date: Tue, 19 Aug 2008 20:49:51 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <patchbomb.1219083817@localhost> <200808191956.59898.nickpiggin@yahoo.com.au> <20080819102430.GD6722@elte.hu>
In-Reply-To: <20080819102430.GD6722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192049.51270.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 20:24, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > At least we could/should perhaps standardize/generalize all the
> > > 'specific' IPI handlers into the smp_function_call() framework: if
> > > function address equals to a pre-cooked IPI entry point we could
> > > call that function without a kmalloc. As these are all hardwired,
> > > __builtin_is_constant_p() could come to the help as well. Hm?
> >
> > No, it's not just the function call but also payload, list entry for
> > queue, scoreboard of CPUs have processed it, a lock, etc etc etc.
> >
> > smp_call_function is *always* going to be heavier than a hard wired
> > special case, no matter how it is implemented. For such low level
> > performance critical functionality, I miss the days when people were
> > rabid about saving every cycle rather than every line of code ;)
>
> no, i was thinking about really high level hardwiring, i.e. hardwiring
> the _function pointer_ knowledge into smp_function_call().
>
> for example for the reschedule IPI, it would be hardwired on x86 to just
> call into the special IPI handler, via:
>
>   smp_call_function_mask(target_mask, smp_send_reschedule, NULL, 0);
>
> Exactly same cost and call sequence as a direct hardwired-to-IPI
> function call (and the same underlying mechanism) - just consolidated
> around a single cross-call API.

So it would magically use a different IPI vector, magically be callable
from interrupt context, have a different function type etc.? Why would
we do such a thing? If it doesn't walk like a duck and doesn't quack
like a duck, why should we call it a duck? ;)


> Same for all the other special cross-CPU handlers. That way some
> architectures would hardwire it, some wouldnt, etc.

I think the right way is just to keep the "special" classes of IPI-ish
functions (I guess reschedule and TLB flush importantly). The arch code
is still free to implement these using their call function or a special
vector or whatever.
