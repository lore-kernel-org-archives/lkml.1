Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0BRK1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:27:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41242 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0BRK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZhdwpqSEKiI7ebLpYpmks5mfkmlQB3JLLxGOAVBcGFeU2daa7U2beaOOBXWbp/nPt/
         VaDt1Vp1ICNoNfBWN4tg1y2MKQYvFZ7ezwK7Uom537ViZlReJBWGL9fXdBHG17EtMc6B
         6JafzsXGDler2+0AxvIbVISw4ybHfqjXB7p88=
MIME-Version: 1.0
In-Reply-To: <20100218101156.GE5964@basil.fritz.box>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz.box>
Date: Thu, 18 Feb 2010 11:27:02 +0100
X-Google-Sender-Auth: 06c03c180727ac38
Message-ID: <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CR changes are slow and synchronize the CPU. The later is always slow.
>
> It sounds like you didn't time it?
I didn't, because I think it strongly depends on the microarchitecture
and I don't have a comprehensive set of machines to test on, so it
would just be a single data point.

The lock prefix on cmpxchg8b is also serializing so it might be as bad.

Anyway, if we use this, we should keep TS cleared in kernel mode and
lazily restore it on return to userspace.
This would make clts/stts performance mostly moot.

I agree that this feature would need to added too before putting the
SSE atomic64 code in a released kernel.

> It'll generate worse code because gcc can't use these registers
> at all in the C code. Some gcc versions also tend to give up when they run
> out of registers too badly.
Yes, but the C implementations are small and simple, and are only used
on 386/486.
Furthermore, the data in the global register variables is the main
input to the computation.

> So why don't you simply use normal asm inputs/outputs?
I do, on the caller side.

In the callee, I don't see any other robust way to implement parameter
passing in ebx/esi other than global register variables (without
resorting to pure assembly, which would prevent reusing the generic
atomic64 implementation).
