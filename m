Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZLITZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZLITZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZLITZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:25:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63324 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbZLITZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eVnZFs9BiRrvZmJh9Ik1r1HMdstHWdnrUzlMrHu0z0+uVffjdBvgEbRkQY0TXhpNAz
         Fuwh1BJWpH3gJsOgPJDGuS7Cseu1mV+EO08qG0jbVVKUjJB3KIsWfdIm3hmG0UnmaaKn
         xEROFkWobXOyVv+JSg564IxTqIVUfD+49mUvE=
MIME-Version: 1.0
In-Reply-To: <4B1FF27E.8030701@zytor.com>
References: <20091203210913.GA24351@elte.hu>
	 <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
	 <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org>
	 <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
	 <4B1FF27E.8030701@zytor.com>
Date: Wed, 9 Dec 2009 14:25:14 -0500
Message-ID: <73c1f2160912091125s166219ddl56e7cbede800ac3@mail.gmail.com>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 1:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2009 10:47 AM, Linus Torvalds wrote:
>>
>> NOTE NOTE NOTE! Totally untested. Is the second argument even in %edx? I
>> don't remember, I didn't check, I'm just throwing this out as a "hey,
>> maybe something _like_ this can work" patch, and will be immediately
>> removing it from my machine after sending this email.
>>
>
> The second argument is in %edx, but unlike 64 bits, it is not loaded
> into that register a priory ("asmlinkage" means arguments are on the stack.)
>
> As such, we need something looking like:
>
> #define PTREGSCALL0(name)       \
> ptregs_##name:                  \
>        leal    4(%esp),%eax;   \
>        jmp sys_##name
>
> #define PTREGSCALL1(name)       \
> ptregs_##name:                  \
>        movl    4(%esp),%eax;   \
>        leal    4(%esp),%edx;   \
>        jmp sys_##name
>
> #define PTREGSCALL2(name)       \
> ptregs_##name:                  \
>        movl    4(%esp),%eax;   \
>        movl    8(%esp),%edx;   \
>        leal    4(%esp),%ecx;   \
>        jmp sys_##name
>
> If we need more than two arguments + pt_regs, then we have to set up a
> temporary stack frame.
>
> [Sorry, I'm sitting in a meeting so I can't actually write up a real patch]
>
>        -hpa

I had started working on a patchset like this when this issue came up
the first time.  I'll get it up to date and send it out.  It would be
nice if this could be done for all syscalls, so that
asmlinkage_protect() isn't needed.

--
Brian Gerst
