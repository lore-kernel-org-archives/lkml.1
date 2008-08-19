Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYHSKY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYHSKY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYHSKYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:24:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYHSKYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:24:48 -0400
Date: Tue, 19 Aug 2008 12:24:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819102430.GD6722@elte.hu>
References: <patchbomb.1219083817@localhost> <48AA5C19.3010204@goop.org> <20080819093130.GF28713@elte.hu> <200808191956.59898.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808191956.59898.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > At least we could/should perhaps standardize/generalize all the 
> > 'specific' IPI handlers into the smp_function_call() framework: if 
> > function address equals to a pre-cooked IPI entry point we could 
> > call that function without a kmalloc. As these are all hardwired, 
> > __builtin_is_constant_p() could come to the help as well. Hm?
> 
> No, it's not just the function call but also payload, list entry for 
> queue, scoreboard of CPUs have processed it, a lock, etc etc etc.
> 
> smp_call_function is *always* going to be heavier than a hard wired 
> special case, no matter how it is implemented. For such low level 
> performance critical functionality, I miss the days when people were 
> rabid about saving every cycle rather than every line of code ;)

no, i was thinking about really high level hardwiring, i.e. hardwiring 
the _function pointer_ knowledge into smp_function_call().

for example for the reschedule IPI, it would be hardwired on x86 to just 
call into the special IPI handler, via:

  smp_call_function_mask(target_mask, smp_send_reschedule, NULL, 0);

Exactly same cost and call sequence as a direct hardwired-to-IPI 
function call (and the same underlying mechanism) - just consolidated 
around a single cross-call API.

Same for all the other special cross-CPU handlers. That way some 
architectures would hardwire it, some wouldnt, etc.

	Ingo
