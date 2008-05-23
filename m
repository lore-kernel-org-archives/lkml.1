Return-Path: <linux-kernel-owner+w=401wt.eu-S1765122AbYEWDmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765122AbYEWDmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbYEWDmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:42:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:52424 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbYEWDmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eEqlkPdABhzFigOR8GpinpD/yUEvtZEV8rOaIaLMcWrV8wH22Wn6kHGx/Jw4pwNs1VpUK0d7YY0ww4IR06QfGLep+ATEu8vkgHpQOVhygS/YhS75fFBVnnzTIHH3o0N1byMnyJeNUZSZcIyWzXd2a22PoUA+CV+T+ERbwMJmE3w=
Message-ID: <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
Date: Fri, 23 May 2008 11:42:35 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080522203428.835D626FA24@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <1211446045.5610.33.camel@elijah.suse.cz>
	 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	 <20080522111826.BB90326FA24@magilla.localdomain>
	 <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	 <20080522203428.835D626FA24@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 4:34 AM, Roland McGrath <roland@redhat.com> wrote:
>> Sorry for confusion, Let me try to explain it more:
>
> I understand these code paths (I wrote them).
>
>> If TASK_TRACED is not set earlier before arch_ptrace_stop on ia64
>> ptrace_notify code path, some signals would be delivered without
>> letting debugger run.. (i.e. PTRACED logica in get_signal_to_deliver
>> would be ignored totally!). These should cause the test case hang on
>> ia64. And x86 just works..
>
> I do not understand this at all, and it has given no information you did
> not give before.  Please describe the scenario you see in fine-grained
> terms.
>
In the code path mentioned above, I see only ia64 has chance to let
ptraced thread deliver those pending signals before TASK_TRACED is
set. Then debugger thread would lose chance to interfere the
delivering of those signals if I correctly understand PT_PTRACED logic
in get_signal_to_deliver, and the relationship between the two flag :
TASK_TRACED and PT_TRACED.

Since you write those code, Please clarify, in ptrace_notify code
path, is it allowed that ptraced thread can run signal handler without
telling debugger what happened?

I noticed the only difference between x86 and IA64 ,  and it does make
the test case work on
x86, and fail on IA64... So I made the patch trying to eliminate the
difference. It indeed seems to solve my problem although it is still
hack, and I don't know what kind of signals strace handled has such
magic..

As for how the door is only open for ia64, I can explain further if
you want to know.
