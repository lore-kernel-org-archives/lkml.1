Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0BRArl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:47:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37057 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab0BRArk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:47:40 -0500
Message-ID: <4B7C8E04.6070605@zytor.com>
Date: Wed, 17 Feb 2010 16:47:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>	 <4B7C7023.7060602@zytor.com> <ff13bc9a1002171641w372a587j39632cb856b995f1@mail.gmail.com>
In-Reply-To: <ff13bc9a1002171641w372a587j39632cb856b995f1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 04:41 PM, Luca Barbieri wrote:
>> I'm a bit unhappy about this patch.  It seems to violate the assumption
>> that we only ever use the FPU state guarded by
>> kernel_fpu_begin()..kernel_fpu_end() and instead it uses a local hack,
>> which seems like a recipe for all kinds of very subtle problems down the
>> line.
> 
> kernel_fpu_begin saves the whole FPU state, but to use SSE we don't
> really need that, since we can just save the %xmm registers we need,
> which is much faster.
> This is why SSE is used instead of just using an FPU double read.
> We could however add a kernel_sse_begin_nosave/kernel_sse_end_nosave to do this.
> 

We could, and that would definitely better than open-coding the operation.

>> Unless the performance advantage is provably very compelling, I'm
>> inclined to say that this is not worth it.
> There is the advantage of not taking the cacheline for writing in atomic64_read.
> Also locked cmpxchg8b is slow and if we were to restore the TS flag
> lazily on userspace return, it would significantly improve the
> function in all cases (with the current code, it depends on how fast
> the architecture does clts/stts vs lock cmpxchg8b).
> Of course the big-picture impact depends on the users of the interface.

It does, and I would prefer to not take it until there is a user of the
interface which motivates the performance.  Ingo, do you have a feel for
how performance-critical this actually is?

	-hpa

