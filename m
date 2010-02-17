Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0BQWkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:40:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0BQWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:40:11 -0500
Message-ID: <4B7C7023.7060602@zytor.com>
Date: Wed, 17 Feb 2010 14:39:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 03:42 AM, Luca Barbieri wrote:
> This patch uses SSE movlps to perform 64-bit atomic reads and writes.
> 
> According to Intel manuals, all aligned 64-bit reads and writes are
> atomically, which should include movlps.
> 
> To do this, we need to disable preempt, clts if TS was set, and
> restore TS.
> 
> If we don't need to change TS, using SSE is much faster.
> 
> Otherwise, it should be essentially even, with the fastest method
> depending on the specific architecture.
> 
> Another important point is that with SSE atomic64_read can keep the
> cacheline in shared state.
> 
> If we could keep TS off and reenable it when returning to userspace,
> this would be even faster, but this is left for a later patch.
> 
> We use SSE because we can just save the low part %xmm0, whereas using
> the FPU or MMX requires at least saving the environment, and seems
> impossible to do fast.
> 
> Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>

I'm a bit unhappy about this patch.  It seems to violate the assumption
that we only ever use the FPU state guarded by
kernel_fpu_begin()..kernel_fpu_end() and instead it uses a local hack,
which seems like a recipe for all kinds of very subtle problems down the
line.

Unless the performance advantage is provably very compelling, I'm
inclined to say that this is not worth it.

	-hpa
