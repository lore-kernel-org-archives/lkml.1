Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0BRSmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:42:17 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46460 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0BRSmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZyTbtzwboUMF5E9Y+AK8oMJ5iail3uf21KgAgIkgQjT7QYUunoq0oxpo2ywFfBkMs/
         CPERSbz0PTZ3LUGQUUkKZrfTcJ5T0TXgD7EjHBxGZtxmnDJ36acj94byxNffS659W1g2
         SbxwfCHzUI+jTVN7fJ84X8NsDgFLzjM24+Zak=
MIME-Version: 1.0
In-Reply-To: <4B7D86BC.10000@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz.box>
	 <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
	 <4B7D5BB4.4000307@zytor.com>
	 <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
	 <4B7D86BC.10000@zytor.com>
Date: Thu, 18 Feb 2010 19:42:11 +0100
X-Google-Sender-Auth: 7d503b2bec3aa066
Message-ID: <ff13bc9a1002181042p7414c18fu77208b6bc7aa41df@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We already do that kind of stuff, using
> kernel_fpu_begin()..kernel_fpu_end().  We went through some pain a bit
> ago to clean up "private hacks" that complicated things substantially.

But that saves the whole FPU state on the first usage, and also
triggers a fault when userspace attempts to use it again.
Additionally it does a clts/stts every time which is slow for small
algorithms (lke the atomic64 routines).

The first issue can be solved by using SSE and saving only the used
registers, and the second with lazy TS flag restoring.

How about something like:

static inline unsigned long kernel_sse_begin(void)
{
        struct thread_info *me = current_thread_info();
        preempt_disable();
        if (unlikely(!(me->status & TS_USEDFPU))) {
                unsigned long cr0 = read_cr0();
                if (unlikely(cr0 & X86_CR0_TS)) {
                        clts();
                        return cr0;
                }
        }
        return 0;
}

static inline void kernel_sse_end(unsigned long cr0)
{
        if (unlikely(cr0))
                write_cr0(cr0);
        preempt_enable();
}

to be improved with lazy TS restoring instead of the read_cr0/write_cr0?
