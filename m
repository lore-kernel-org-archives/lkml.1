Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0BRAlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:41:18 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64211 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0BRAlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LfR1lbvXyC+C4OiKCTLxiRqBumpy8z7AfeENR9H12T1NJejG2Mpz86EaIYNaYbTM73
         WZcP9t+D+M6gqHeRMOLk+qdaUvJRGssli+7vN1mZ+TdZq1jHxjpIdPqn0uVVNFZbM1Iy
         VcCdIM/dS8UyvTkLrA2vEg7L1MT1iSOdzWigY=
MIME-Version: 1.0
In-Reply-To: <4B7C7023.7060602@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <4B7C7023.7060602@zytor.com>
Date: Thu, 18 Feb 2010 01:41:13 +0100
X-Google-Sender-Auth: 5c1e7eccb4a4b6f3
Message-ID: <ff13bc9a1002171641w372a587j39632cb856b995f1@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm a bit unhappy about this patch.  It seems to violate the assumption
> that we only ever use the FPU state guarded by
> kernel_fpu_begin()..kernel_fpu_end() and instead it uses a local hack,
> which seems like a recipe for all kinds of very subtle problems down the
> line.

kernel_fpu_begin saves the whole FPU state, but to use SSE we don't
really need that, since we can just save the %xmm registers we need,
which is much faster.
This is why SSE is used instead of just using an FPU double read.
We could however add a kernel_sse_begin_nosave/kernel_sse_end_nosave to do this.

> Unless the performance advantage is provably very compelling, I'm
> inclined to say that this is not worth it.
There is the advantage of not taking the cacheline for writing in atomic64_read.
Also locked cmpxchg8b is slow and if we were to restore the TS flag
lazily on userspace return, it would significantly improve the
function in all cases (with the current code, it depends on how fast
the architecture does clts/stts vs lock cmpxchg8b).
Of course the big-picture impact depends on the users of the interface.

Anyway, feel free to ignore this patch for now (and the next one as well).
