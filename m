Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbXERNeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbXERNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXERNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:34:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:13786 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbXERNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Dzbpimn1aEl0trSFaRjJ+gHojaMghfPcK9wO3pqS3ZkPc8iRpk1iFHSjlrFiWhuG4RST5kfAFYFb6jmm4HZ7eMia0YKsO7aCr4yul9OAmzPyucFc42C08jZ1GdBI/Yl1IusMfhWy8bjHIRYxmbkk648Rn+ElYsqlBwMBJyYvBFM=
Message-ID: <464DAB3D.4020000@gmail.com>
Date: Fri, 18 May 2007 15:33:49 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru> <20070518073517.GB1573@ff.dom.local>
In-Reply-To: <20070518073517.GB1573@ff.dom.local>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jarek Poplawski wrote:
> 2. IMHO the current solution with smp barriers is very good:
> these barriers are really needed and they should be enough.
> Oleg repeats all the time he hates barriers, but I think
> it's wrong approach - they should be seen as something
> natural for programming modern processors and trying to
> change the code only to avoid them is wrong (unless it
> could be done with some minor changes).
> 
> 3. The alternative solution without barriers, based on the
> idea of Tejun Heo and presented in the patch proposal from
> 2007-05-13, could be probably a little faster (for some
> processors), after some changes:
> 
> - I think, instead of separate __set_bit and __clear_bit,
> WORK_STRUCT_QUEUED bit should be changed during set_wq_data
> (additional parameter or new variant eg: set_wq_data_queued),
> and similarly something like  work_clear_pending_queued -
> so, without additional operations instead of these barriers.
> 
> - changing this if condition in try_to_grab_pending.
> 
> But there is a question - is this worth of one (last) bit
> occupied only for optimisation (but not always)?

I wasn't really aiming for performance optimization.  I agree that we
have to live with barriers but it's also true that they and other
synchronization constructs can be difficult to understand and thus to
verify, so IMHO, when it comes to synchronization constructs, it's best
stick to or make things look similar to more established ways, so that
people can categorize the usage and understand it more easily.

Locked enter/leave model, where each cpu has its own lock and whatever
entity enters and leaves a cpu while holding the respective per-cpu
lock, guarantees that while holding a per-cpu lock, no one enters or
leaves the cpu.  It's conceptually simple and basically the semantic
that we're all trying to achieve here.

I think things can be made more similar to the locked enter/leave model
using the extra bit by putting manipulation and testing of the bit into
accesor functions, so readability was my primary concern not
performance.  But, then again, we can probably make the barrier() model
readable enough too with proper accessor functions and plenty of
comments above them.

-- 
tejun
